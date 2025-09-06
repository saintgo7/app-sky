import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, staging, production }

class AppEnvironment {
  static Environment _currentEnvironment = Environment.development;
  
  static Environment get currentEnvironment => _currentEnvironment;
  
  static Future<void> initialize(Environment environment) async {
    _currentEnvironment = environment;
    
    switch (environment) {
      case Environment.development:
        await dotenv.load(fileName: '.env.dev');
        break;
      case Environment.staging:
        await dotenv.load(fileName: '.env.staging');
        break;
      case Environment.production:
        await dotenv.load(fileName: '.env.prod');
        break;
    }
  }
  
  static String get baseApiUrl => dotenv.env['BASE_API_URL'] ?? '';
  static String get socketServerUrl => dotenv.env['SOCKET_SERVER_URL'] ?? '';
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static String get iamportUserCode => dotenv.env['IAMPORT_USER_CODE'] ?? '';
  static String get bootpayApplicationId => dotenv.env['BOOTPAY_APPLICATION_ID'] ?? '';
  static String get dialogflowProjectId => dotenv.env['DIALOGFLOW_PROJECT_ID'] ?? '';
  
  static bool get isDebugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  static bool get isDevelopment => _currentEnvironment == Environment.development;
  static bool get isStaging => _currentEnvironment == Environment.staging;
  static bool get isProduction => _currentEnvironment == Environment.production;
}