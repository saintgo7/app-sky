import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../data/api/auth_api_service.dart';
import '../data/api/search_api_service.dart';
import '../data/api/booking_api_service.dart';
import '../data/local/hive_service.dart';
import '../domain/entities/booking.dart';
import '../domain/entities/user.dart';

enum NetworkStatus {
  online,
  offline,
  unknown,
}

class OfflineService {
  static final Connectivity _connectivity = Connectivity();
  static final StreamController<NetworkStatus> _networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  static Stream<NetworkStatus> get networkStatus => _networkStatusController.stream;

  static NetworkStatus _currentStatus = NetworkStatus.unknown;
  static bool _initialized = false;

  // 데이터 큐 (오프라인 작업 저장)
  static final List<Map<String, dynamic>> _pendingOperations = [];
  static Timer? _syncTimer;

  // 초기화
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 네트워크 상태 모니터링 시작
      _startNetworkMonitoring();

      // 초기 네트워크 상태 확인
      final result = await _connectivity.checkConnectivity();
      _updateNetworkStatus(_getNetworkStatusFromResult(result));

      // 저장된 오프라인 작업 로드
      await _loadPendingOperations();

      // 주기적인 동기화 시작
      _startPeriodicSync();

      _initialized = true;
    } catch (e) {
      print('Offline service initialization error: $e');
    }
  }

  // 네트워크 상태 모니터링
  static void _startNetworkMonitoring() {
    _connectivity.onConnectivityChanged.listen((result) {
      final status = _getNetworkStatusFromResult(result);
      _updateNetworkStatus(status);
    });
  }

  // 네트워크 상태 변환
  static NetworkStatus _getNetworkStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        return NetworkStatus.online;
      case ConnectivityResult.none:
        return NetworkStatus.offline;
      default:
        return NetworkStatus.unknown;
    }
  }

  // 네트워크 상태 업데이트
  static void _updateNetworkStatus(NetworkStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _networkStatusController.add(status);

      if (kDebugMode) {
        print('Network status changed: $status');
      }

      // 온라인으로 돌아오면 동기화 시작
      if (status == NetworkStatus.online) {
        _syncPendingOperations();
      }
    }
  }

  // 현재 네트워크 상태 확인
  static NetworkStatus getCurrentNetworkStatus() {
    return _currentStatus;
  }

  // 온라인 상태 확인
  static bool get isOnline => _currentStatus == NetworkStatus.online;

  // 오프라인 상태 확인
  static bool get isOffline => _currentStatus == NetworkStatus.offline;

  // 오프라인 작업 추가
  static Future<void> addPendingOperation({
    required String operation,
    required String endpoint,
    required Map<String, dynamic> data,
    String? id,
    int priority = 0, // 0: 낮음, 1: 보통, 2: 높음
  }) async {
    final pendingOperation = {
      'id': id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'operation': operation,
      'endpoint': endpoint,
      'data': data,
      'priority': priority,
      'timestamp': DateTime.now().toIso8601String(),
      'retry_count': 0,
    };

    _pendingOperations.add(pendingOperation);

    // 우선순위에 따라 정렬 (높은 우선순위 먼저)
    _pendingOperations.sort((a, b) => b['priority'].compareTo(a['priority']));

    await _savePendingOperations();

    if (kDebugMode) {
      print('Added pending operation: $operation');
    }
  }

  // 오프라인 작업 저장
  static Future<void> _savePendingOperations() async {
    final operationsJson = json.encode(_pendingOperations);
    await HiveService.saveSetting('pending_operations', operationsJson);
  }

  // 오프라인 작업 로드
  static Future<void> _loadPendingOperations() async {
    try {
      final operationsJson = HiveService.getSetting('pending_operations');
      if (operationsJson != null) {
        final operations = json.decode(operationsJson) as List;
        _pendingOperations.clear();
        _pendingOperations.addAll(operations.map((op) => Map<String, dynamic>.from(op)));
      }
    } catch (e) {
      print('Load pending operations error: $e');
    }
  }

  // 오프라인 작업 동기화
  static Future<void> _syncPendingOperations() async {
    if (!isOnline || _pendingOperations.isEmpty) return;

    final operationsToProcess = List.from(_pendingOperations);

    for (final operation in operationsToProcess) {
      try {
        final success = await _processPendingOperation(operation);
        if (success) {
          _pendingOperations.remove(operation);
        } else {
          operation['retry_count'] = (operation['retry_count'] ?? 0) + 1;

          // 최대 재시도 횟수 초과 시 제거
          if (operation['retry_count'] >= 3) {
            _pendingOperations.remove(operation);
            print('Removed failed operation after max retries: ${operation['operation']}');
          }
        }
      } catch (e) {
        print('Sync operation error: $e');
        operation['retry_count'] = (operation['retry_count'] ?? 0) + 1;
      }
    }

    await _savePendingOperations();
  }

  // 개별 오프라인 작업 처리
  static Future<bool> _processPendingOperation(Map<String, dynamic> operation) async {
    final op = operation['operation'];
    final data = operation['data'] as Map<String, dynamic>;

    try {
      switch (op) {
        case 'create_booking':
          final bookingData = data;
          // 실제 API 호출로 교체
          print('Processing create booking: $bookingData');
          return true;

        case 'update_profile':
          final profileData = data;
          // 실제 API 호출로 교체
          print('Processing update profile: $profileData');
          return true;

        case 'send_message':
          final messageData = data;
          // 실제 API 호출로 교체
          print('Processing send message: $messageData');
          return true;

        default:
          print('Unknown operation: $op');
          return false;
      }
    } catch (e) {
      print('Process operation error: $e');
      return false;
    }
  }

  // 주기적인 동기화 시작
  static void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (isOnline) {
        _syncPendingOperations();
      }
    });
  }

  // 즉시 동기화
  static Future<void> syncNow() async {
    if (isOnline) {
      await _syncPendingOperations();
    }
  }

  // 오프라인 작업 큐 상태 확인
  static Map<String, dynamic> getQueueStatus() {
    final highPriority = _pendingOperations.where((op) => op['priority'] == 2).length;
    final mediumPriority = _pendingOperations.where((op) => op['priority'] == 1).length;
    final lowPriority = _pendingOperations.where((op) => op['priority'] == 0).length;

    return {
      'total': _pendingOperations.length,
      'high_priority': highPriority,
      'medium_priority': mediumPriority,
      'low_priority': lowPriority,
      'oldest_operation': _pendingOperations.isNotEmpty
          ? _pendingOperations.first['timestamp']
          : null,
    };
  }

  // 캐시된 데이터 관리
  static Future<void> cacheData({
    required String key,
    required dynamic data,
    Duration? expiry,
  }) async {
    final expiryTime = expiry ?? const Duration(hours: 24);
    final expiresAt = DateTime.now().add(expiryTime);

    final cacheData = {
      'data': data,
      'expires_at': expiresAt.toIso8601String(),
      'cached_at': DateTime.now().toIso8601String(),
    };

    await HiveService.saveToCache(key, cacheData);
  }

  // 캐시된 데이터 가져오기
  static T? getCachedData<T>(String key) {
    final cached = HiveService.getFromCache(key);
    if (cached == null) return null;

    final cacheData = cached as Map<String, dynamic>;
    final expiresAt = DateTime.parse(cacheData['expires_at']);

    if (DateTime.now().isAfter(expiresAt)) {
      // 캐시 만료됨
      HiveService.saveToCache(key, null); // 캐시 삭제
      return null;
    }

    return cacheData['data'] as T;
  }

  // 캐시 정리
  static Future<void> clearExpiredCache() async {
    await HiveService.clearExpiredCache();
  }

  // 모든 캐시 정리
  static Future<void> clearAllCache() async {
    await HiveService.clearCache();
  }

  // 오프라인 데이터 저장 (특정 엔티티용)
  static Future<void> saveOfflineData({
    required String entityType,
    required String id,
    required Map<String, dynamic> data,
    bool syncImmediately = false,
  }) async {
    final offlineData = {
      'id': id,
      'entity_type': entityType,
      'data': data,
      'last_modified': DateTime.now().toIso8601String(),
      'sync_status': 'pending',
    };

    final key = 'offline_${entityType}_$id';
    await HiveService.saveToCache(key, offlineData);

    if (syncImmediately && isOnline) {
      // 즉시 동기화 시도
      await _syncOfflineData(offlineData);
    }
  }

  // 오프라인 데이터 가져오기
  static Map<String, dynamic>? getOfflineData(String entityType, String id) {
    final key = 'offline_${entityType}_$id';
    return HiveService.getFromCache(key);
  }

  // 오프라인 데이터 동기화
  static Future<void> _syncOfflineData(Map<String, dynamic> offlineData) async {
    final entityType = offlineData['entity_type'];
    final data = offlineData['data'] as Map<String, dynamic>;

    try {
      switch (entityType) {
        case 'booking':
          // 예약 데이터 동기화
          print('Syncing booking data: ${data['id']}');
          break;
        case 'user':
          // 사용자 데이터 동기화
          print('Syncing user data: ${data['id']}');
          break;
        case 'message':
          // 메시지 데이터 동기화
          print('Syncing message data: ${data['id']}');
          break;
      }

      // 동기화 성공 시 로컬 데이터 업데이트
      offlineData['sync_status'] = 'synced';
      offlineData['synced_at'] = DateTime.now().toIso8601String();

      final key = 'offline_${entityType}_${data['id']}';
      await HiveService.saveToCache(key, offlineData);

    } catch (e) {
      print('Offline data sync error: $e');
      offlineData['sync_status'] = 'failed';
      offlineData['error'] = e.toString();
    }
  }

  // 모든 오프라인 데이터 동기화
  static Future<void> syncAllOfflineData() async {
    if (!isOnline) return;

    // 캐시에서 오프라인 데이터 찾기
    final allCache = await _getAllOfflineData();

    for (final entry in allCache.entries) {
      if (entry.key.startsWith('offline_')) {
        final offlineData = entry.value as Map<String, dynamic>;
        if (offlineData['sync_status'] == 'pending') {
          await _syncOfflineData(offlineData);
        }
      }
    }
  }

  // 모든 오프라인 데이터 가져오기 (내부용)
  static Future<Map<String, dynamic>> _getAllOfflineData() async {
    // 실제 구현에서는 Hive에서 모든 오프라인 데이터를 가져오는 로직
    // 현재는 빈 맵 반환
    return {};
  }

  // 충돌 해결 전략
  static Future<void> resolveConflict({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> serverData,
    required Map<String, dynamic> localData,
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.serverWins,
  }) async {
    Map<String, dynamic> resolvedData;

    switch (strategy) {
      case ConflictResolutionStrategy.serverWins:
        resolvedData = serverData;
        break;
      case ConflictResolutionStrategy.clientWins:
        resolvedData = localData;
        break;
      case ConflictResolutionStrategy.manual:
        // 수동 해결 필요 - UI에서 처리
        return;
      case ConflictResolutionStrategy.merge:
        resolvedData = _mergeData(serverData, localData);
        break;
    }

    // 해결된 데이터 저장
    await saveOfflineData(
      entityType: entityType,
      id: entityId,
      data: resolvedData,
      syncImmediately: true,
    );
  }

  // 데이터 병합
  static Map<String, dynamic> _mergeData(
    Map<String, dynamic> serverData,
    Map<String, dynamic> localData,
  ) {
    final merged = Map<String, dynamic>.from(serverData);

    // 로컬 데이터의 필드가 서버 데이터에 없는 경우 추가
    localData.forEach((key, value) {
      if (!merged.containsKey(key)) {
        merged[key] = value;
      }
    });

    return merged;
  }

  // 오프라인 모드 전환 콜백
  static VoidCallback? onOfflineModeEntered;
  static VoidCallback? onOnlineModeEntered;

  // 오프라인 모드 알림
  static void _notifyOfflineMode() {
    onOfflineModeEntered?.call();
  }

  static void _notifyOnlineMode() {
    onOnlineModeEntered?.call();
  }

  // 서비스 정리
  static void dispose() {
    _syncTimer?.cancel();
    _networkStatusController.close();
  }
}

// 충돌 해결 전략
enum ConflictResolutionStrategy {
  serverWins,  // 서버 데이터 우선
  clientWins,  // 클라이언트 데이터 우선
  manual,      // 수동 해결
  merge,       // 데이터 병합
}
