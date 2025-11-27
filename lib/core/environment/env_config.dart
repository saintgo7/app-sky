import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // API Configuration
  static String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: 'https://api.travelmate.com/v1');
  static String get apiKey => dotenv.get('API_KEY', fallback: 'your_api_key_here');

  // Authentication
  static String get authBaseUrl => dotenv.get('AUTH_BASE_URL', fallback: 'https://auth.travelmate.com');

  // External Services
  static String get naverMapClientId => dotenv.get('NAVER_MAP_CLIENT_ID', fallback: '');
  static String get naverMapClientSecret => dotenv.get('NAVER_MAP_CLIENT_SECRET', fallback: '');
  static String get googleMapsApiKey => dotenv.get('GOOGLE_MAPS_API_KEY', fallback: '');
  static String get iamportCode => dotenv.get('IAMPORT_CODE', fallback: '');
  static String get iamportApiKey => dotenv.get('IAMPORT_API_KEY', fallback: '');
  static String get iamportApiSecret => dotenv.get('IAMPORT_API_SECRET', fallback: '');

  // Firebase
  static String get firebaseApiKey => dotenv.get('FIREBASE_API_KEY', fallback: '');
  static String get firebaseProjectId => dotenv.get('FIREBASE_PROJECT_ID', fallback: '');
  static String get firebaseMessagingSenderId => dotenv.get('FIREBASE_MESSAGING_SENDER_ID', fallback: '');
  static String get firebaseAppId => dotenv.get('FIREBASE_APP_ID', fallback: '');

  // AI Service
  static String get aiServiceUrl => dotenv.get('AI_SERVICE_URL', fallback: 'https://ai.travelmate.com');
  static String get aiApiKey => dotenv.get('AI_API_KEY', fallback: '');

  // Environment
  static String get environment => dotenv.get('ENVIRONMENT', fallback: 'development');
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';

  // Database
  static String get databaseName => dotenv.get('DATABASE_NAME', fallback: 'travelmate.db');

  // Cache
  static Duration get cacheDuration => Duration(
    hours: int.parse(dotenv.get('CACHE_DURATION_HOURS', fallback: '24')),
  );

  // Timeout
  static Duration get apiTimeout => Duration(
    seconds: int.parse(dotenv.get('API_TIMEOUT_SECONDS', fallback: '30')),
  );
}
