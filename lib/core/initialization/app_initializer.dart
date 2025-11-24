import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../data/local/hive_service.dart';
import '../../services/notification_service.dart';
import '../../services/offline_service.dart';
import '../../presentation/providers/api_providers.dart';

class AppInitializer {
  static bool _initialized = false;

  // 앱 초기화
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 환경 변수 로드
      await dotenv.load(fileName: '.env');

      // Hive 초기화
      await HiveService.init();

      // 오프라인 서비스 초기화
      await OfflineService.initialize();

      // 알림 서비스 초기화
      await NotificationService.initialize();

      // 캐시 정리 (주기적)
      await _cleanupExpiredData();

      _initialized = true;
      print('App initialization completed');
    } catch (e) {
      print('App initialization error: $e');
      // 초기화 실패 시에도 앱은 실행되도록 함
    }
  }

  // 만료된 데이터 정리
  static Future<void> _cleanupExpiredData() async {
    try {
      // Hive 캐시 정리
      await HiveService.clearExpiredCache();

      // 오프라인 서비스 캐시 정리
      await OfflineService.clearExpiredCache();

      print('Expired data cleanup completed');
    } catch (e) {
      print('Data cleanup error: $e');
    }
  }

  // 앱 종료 시 정리
  static Future<void> dispose() async {
    try {
      await HiveService.close();
      OfflineService.dispose();
      print('App disposal completed');
    } catch (e) {
      print('App disposal error: $e');
    }
  }

  // 초기화 상태 확인
  static bool get isInitialized => _initialized;

  // 초기화 상태 재설정 (테스트용)
  static void reset() {
    _initialized = false;
  }
}
