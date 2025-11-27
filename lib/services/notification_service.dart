import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../core/environment/env_config.dart';
import '../data/local/hive_service.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static String? _deviceToken;
  static bool _initialized = false;

  // Initialize Firebase Messaging
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Firebase 초기화
      await Firebase.initializeApp();

      // 로컬 알림 초기화
      await _initializeLocalNotifications();

      // FCM 권한 요청
      await _requestPermission();

      // 토큰 가져오기
      _deviceToken = await _firebaseMessaging.getToken();
      if (_deviceToken != null) {
        await HiveService.saveSetting('device_token', _deviceToken);
        print('Device Token: $_deviceToken');
      }

      // 토큰 갱신 리스너
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        _deviceToken = newToken;
        await HiveService.saveSetting('device_token', newToken);
        await _updateDeviceToken(newToken);
      });

      // 포그라운드 메시지 리스너
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 백그라운드 메시지 리스너
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // 앱이 종료된 상태에서 메시지를 탭했을 때
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleTerminatedMessage(initialMessage);
      }

      _initialized = true;
    } catch (e) {
      print('Notification service initialization error: $e');
    }
  }

  // 로컬 알림 초기화
  static Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    // Android 채널 생성
    const androidChannel = AndroidNotificationChannel(
      'travelmate_channel',
      'TravelMate 알림',
      description: '여행 예약 및 프로모션 알림',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // 권한 요청
  static Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  // 디바이스 토큰 가져오기
  static String? getDeviceToken() {
    return _deviceToken ?? HiveService.getSetting('device_token');
  }

  // 서버에 디바이스 토큰 업데이트
  static Future<void> _updateDeviceToken(String token) async {
    try {
      // 서버에 토큰 업데이트 API 호출
      // 실제 구현 시 사용자 인증 토큰과 함께 전송
      print('Updating device token on server: $token');
    } catch (e) {
      print('Device token update error: $e');
    }
  }

  // 포그라운드 메시지 처리
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Foreground message received: ${message.notification?.title}');

    // 로컬 알림 표시
    await _showLocalNotification(message);
  }

  // 백그라운드 메시지 처리
  static void _handleBackgroundMessage(RemoteMessage message) {
    print('Background message opened: ${message.notification?.title}');

    // 메시지 데이터에 따라 적절한 화면으로 이동
    _navigateToScreen(message.data);
  }

  // 종료된 앱에서 메시지 탭 처리
  static void _handleTerminatedMessage(RemoteMessage message) {
    print('Terminated app message opened: ${message.notification?.title}');

    _navigateToScreen(message.data);
  }

  // 로컬 알림 표시
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'travelmate_channel',
      'TravelMate 알림',
      channelDescription: '여행 예약 및 프로모션 알림',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'TravelMate',
      message.notification?.body ?? '새로운 알림이 있습니다.',
      details,
      payload: json.encode(message.data),
    );
  }

  // 로컬 알림 탭 처리
  static void _handleLocalNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      final data = json.decode(response.payload!) as Map<String, dynamic>;
      _navigateToScreen(data);
    }
  }

  // 메시지 데이터에 따른 화면 이동
  static void _navigateToScreen(Map<String, dynamic> data) {
    final screen = data['screen'];
    final id = data['id'];

    switch (screen) {
      case 'booking':
        if (id != null) {
          // 예약 상세 화면으로 이동
          print('Navigate to booking detail: $id');
        }
        break;
      case 'promotion':
        // 프로모션 화면으로 이동
        print('Navigate to promotion');
        break;
      case 'chat':
        // AI 채팅 화면으로 이동
        print('Navigate to AI chat');
        break;
      default:
        // 홈 화면으로 이동
        print('Navigate to home');
    }
  }

  // 로컬 알림 표시 (커스텀)
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'travelmate_channel',
      'TravelMate 알림',
      channelDescription: '여행 예약 및 프로모션 알림',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // 서버에 푸시 알림 전송 (관리자용)
  static Future<bool> sendPushNotification({
    required String title,
    required String body,
    required String token,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Firebase Cloud Messaging을 통한 서버 사이드 전송
      // 실제 구현 시 서버 API 호출
      const String serverKey = 'your_server_key';

      final message = {
        'to': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data ?? {},
      };

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: json.encode(message),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Send push notification error: $e');
      return false;
    }
  }

  // 알림 구독 (토픽 기반)
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Topic subscription error: $e');
    }
  }

  // 알림 구독 취소
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Topic unsubscription error: $e');
    }
  }

  // 알림 설정 업데이트
  static Future<void> updateNotificationSettings({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    List<String>? topics,
  }) async {
    try {
      if (pushEnabled != null) {
        await HiveService.saveSetting('push_notifications_enabled', pushEnabled);
      }

      if (emailEnabled != null) {
        await HiveService.saveSetting('email_notifications_enabled', emailEnabled);
      }

      if (smsEnabled != null) {
        await HiveService.saveSetting('sms_notifications_enabled', smsEnabled);
      }

      if (topics != null) {
        await HiveService.saveSetting('notification_topics', topics);
      }

      // 토픽 구독/구독취소
      if (topics != null) {
        final currentTopics = HiveService.getSetting('notification_topics', defaultValue: <String>[]);
        final topicsToAdd = topics.where((topic) => !currentTopics.contains(topic));
        final topicsToRemove = currentTopics.where((topic) => !topics.contains(topic));

        for (final topic in topicsToAdd) {
          await subscribeToTopic(topic);
        }

        for (final topic in topicsToRemove) {
          await unsubscribeFromTopic(topic);
        }
      }
    } catch (e) {
      print('Notification settings update error: $e');
    }
  }

  // 알림 설정 가져오기
  static Map<String, dynamic> getNotificationSettings() {
    return {
      'push_enabled': HiveService.getSetting('push_notifications_enabled', defaultValue: true),
      'email_enabled': HiveService.getSetting('email_notifications_enabled', defaultValue: true),
      'sms_enabled': HiveService.getSetting('sms_notifications_enabled', defaultValue: false),
      'topics': HiveService.getSetting('notification_topics', defaultValue: <String>[]),
    };
  }

  // 알림 기록 저장
  static Future<void> saveNotificationHistory(Map<String, dynamic> notification) async {
    try {
      final history = HiveService.getSetting('notification_history', defaultValue: <Map<String, dynamic>>[]);
      history.add({
        ...notification,
        'received_at': DateTime.now().toIso8601String(),
      });

      // 최근 100개만 유지
      if (history.length > 100) {
        history.removeRange(0, history.length - 100);
      }

      await HiveService.saveSetting('notification_history', history);
    } catch (e) {
      print('Save notification history error: $e');
    }
  }

  // 알림 기록 가져오기
  static List<Map<String, dynamic>> getNotificationHistory() {
    return HiveService.getSetting('notification_history', defaultValue: <Map<String, dynamic>>[]);
  }

  // 알림 배지 카운트
  static Future<void> setBadgeCount(int count) async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(badge: true);

    await _localNotifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.setBadgeCount(count);
  }

  // 모든 알림 초기화
  static Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
    await setBadgeCount(0);
  }
}
