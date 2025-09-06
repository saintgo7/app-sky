import 'dart:convert';
import 'package:dio/dio.dart';

/// HyperCLOVA X SEED 경량화 모델 서비스
/// 네이버의 AI 모델을 활용한 여행 추천 및 상담 서비스
class HyperClovaService {
  static const String _baseUrl = 'https://clovastudio.stream.ntruss.com';
  static const String _modelId = 'HCX-DASH-001'; // HyperCLOVA X SEED 경량화 모델
  
  final Dio _dio;
  final String _apiKey;
  final String _apigwApiKey;
  
  // 모델 설정
  static const double _temperature = 0.7; // 창의성 레벨
  static const int _maxTokens = 1024; // 최대 응답 길이
  static const double _topP = 0.9; // 토큰 선택 확률
  static const int _topK = 40; // 상위 K개 토큰 고려
  
  HyperClovaService({
    required String apiKey,
    required String apigwApiKey,
  }) : _apiKey = apiKey,
       _apigwApiKey = apigwApiKey,
       _dio = Dio()..options = BaseOptions(
         baseUrl: _baseUrl,
         headers: {
           'Content-Type': 'application/json',
           'Accept': 'application/json',
         },
         connectTimeout: const Duration(seconds: 30),
         receiveTimeout: const Duration(seconds: 30),
       );

  /// 여행 추천 요청
  Future<TravelRecommendation> getTravelRecommendation({
    required String userQuery,
    TravelContext? context,
  }) async {
    try {
      final prompt = _buildTravelPrompt(userQuery, context);
      
      final response = await _dio.post(
        '/testapp/v1/chat-completions/HCX-DASH-001',
        options: Options(
          headers: {
            'X-NCP-CLOVASTUDIO-API-KEY': _apiKey,
            'X-NCP-APIGW-API-KEY': _apigwApiKey,
          },
        ),
        data: {
          'messages': [
            {
              'role': 'system',
              'content': _getSystemPrompt(),
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': _temperature,
          'maxTokens': _maxTokens,
          'topP': _topP,
          'topK': _topK,
          'includeAiFilters': true,
          'stream': false,
        },
      );

      final content = response.data['result']['message']['content'];
      return _parseRecommendation(content);
      
    } on DioException catch (e) {
      throw HyperClovaException(
        message: 'API 요청 실패: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw HyperClovaException(message: '알 수 없는 오류: $e');
    }
  }

  /// 대화형 여행 상담
  Future<String> chatWithAssistant({
    required List<ChatMessage> messages,
    required String userMessage,
  }) async {
    try {
      final formattedMessages = [
        {
          'role': 'system',
          'content': _getSystemPrompt(),
        },
        ...messages.map((msg) => {
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.content,
        }),
        {
          'role': 'user',
          'content': userMessage,
        },
      ];

      final response = await _dio.post(
        '/testapp/v1/chat-completions/HCX-DASH-001',
        options: Options(
          headers: {
            'X-NCP-CLOVASTUDIO-API-KEY': _apiKey,
            'X-NCP-APIGW-API-KEY': _apigwApiKey,
          },
        ),
        data: {
          'messages': formattedMessages,
          'temperature': _temperature,
          'maxTokens': _maxTokens,
          'topP': _topP,
          'topK': _topK,
          'includeAiFilters': true,
          'stream': false,
        },
      );

      return response.data['result']['message']['content'];
      
    } on DioException catch (e) {
      throw HyperClovaException(
        message: 'Chat API 요청 실패: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  /// 여행 일정 생성
  Future<TravelItinerary> generateItinerary({
    required String destination,
    required int days,
    required List<String> preferences,
    required int budget,
  }) async {
    final prompt = '''
여행지: $destination
기간: $days일
예산: ${_formatCurrency(budget)}원
선호사항: ${preferences.join(', ')}

위 정보를 바탕으로 일별 상세 여행 일정을 JSON 형식으로 생성해주세요.
각 일정에는 시간, 장소, 활동, 예상 비용, 이동 수단을 포함해주세요.
''';

    try {
      final response = await _dio.post(
        '/testapp/v1/chat-completions/HCX-DASH-001',
        options: Options(
          headers: {
            'X-NCP-CLOVASTUDIO-API-KEY': _apiKey,
            'X-NCP-APIGW-API-KEY': _apigwApiKey,
          },
        ),
        data: {
          'messages': [
            {
              'role': 'system',
              'content': '당신은 전문 여행 플래너입니다. 사용자의 요구사항에 맞는 최적의 여행 일정을 JSON 형식으로 생성해주세요.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.5, // 일정 생성은 더 정확하게
          'maxTokens': 2048,
          'topP': _topP,
          'topK': _topK,
          'includeAiFilters': true,
          'stream': false,
        },
      );

      final content = response.data['result']['message']['content'];
      return _parseItinerary(content);
      
    } on DioException catch (e) {
      throw HyperClovaException(
        message: 'Itinerary 생성 실패: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  /// 실시간 여행 정보 분석
  Future<TravelInsights> analyzeTravelTrends({
    required String destination,
    DateTime? travelDate,
  }) async {
    final prompt = '''
목적지: $destination
여행 시기: ${travelDate?.toString() ?? '미정'}

해당 여행지의 최신 트렌드, 추천 시기, 주의사항, 인기 명소를 분석해주세요.
''';

    try {
      final response = await _dio.post(
        '/testapp/v1/chat-completions/HCX-DASH-001',
        options: Options(
          headers: {
            'X-NCP-CLOVASTUDIO-API-KEY': _apiKey,
            'X-NCP-APIGW-API-KEY': _apigwApiKey,
          },
        ),
        data: {
          'messages': [
            {
              'role': 'system',
              'content': '당신은 여행 트렌드 분석 전문가입니다. 최신 정보를 바탕으로 실용적인 여행 인사이트를 제공해주세요.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.6,
          'maxTokens': _maxTokens,
          'topP': _topP,
          'topK': _topK,
          'includeAiFilters': true,
          'stream': false,
        },
      );

      final content = response.data['result']['message']['content'];
      return _parseInsights(content);
      
    } on DioException catch (e) {
      throw HyperClovaException(
        message: 'Travel insights 분석 실패: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  // Private helper methods
  String _getSystemPrompt() {
    return '''
당신은 스카이 항공의 AI 여행 컨설턴트입니다.
HyperCLOVA X SEED 모델을 기반으로 한국인 여행자에게 최적화된 서비스를 제공합니다.

주요 역할:
1. 맞춤형 여행지 추천
2. 실시간 여행 정보 제공
3. 예산에 맞는 여행 계획 수립
4. 문화적 특성을 고려한 조언
5. 안전하고 즐거운 여행을 위한 팁 제공

응답 원칙:
- 친절하고 전문적인 톤 유지
- 구체적이고 실용적인 정보 제공
- 한국인 여행자의 선호도 고려
- 최신 트렌드와 정보 반영
''';
  }

  String _buildTravelPrompt(String userQuery, TravelContext? context) {
    final buffer = StringBuffer(userQuery);
    
    if (context != null) {
      buffer.writeln('\n\n추가 정보:');
      if (context.budget != null) {
        buffer.writeln('- 예산: ${_formatCurrency(context.budget!)}원');
      }
      if (context.duration != null) {
        buffer.writeln('- 기간: ${context.duration}일');
      }
      if (context.travelers != null) {
        buffer.writeln('- 인원: ${context.travelers}명');
      }
      if (context.preferences.isNotEmpty) {
        buffer.writeln('- 선호사항: ${context.preferences.join(', ')}');
      }
    }
    
    return buffer.toString();
  }

  String _formatCurrency(int amount) {
    final formatter = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return formatter;
  }

  TravelRecommendation _parseRecommendation(String content) {
    // AI 응답을 구조화된 추천으로 파싱
    return TravelRecommendation(
      destinations: _extractDestinations(content),
      activities: _extractActivities(content),
      estimatedBudget: _extractBudget(content),
      bestTimeToVisit: _extractBestTime(content),
      tips: _extractTips(content),
      reasoning: content,
    );
  }

  TravelItinerary _parseItinerary(String content) {
    try {
      // JSON 부분 추출
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final json = jsonDecode(jsonStr);
        return TravelItinerary.fromJson(json);
      }
    } catch (e) {
      // JSON 파싱 실패 시 텍스트 기반 파싱
    }
    
    return TravelItinerary(
      days: _extractDayPlans(content),
      totalBudget: _extractTotalBudget(content),
      highlights: _extractHighlights(content),
    );
  }

  TravelInsights _parseInsights(String content) {
    return TravelInsights(
      trends: _extractTrends(content),
      bestSeasons: _extractSeasons(content),
      warnings: _extractWarnings(content),
      popularSpots: _extractSpots(content),
      localTips: _extractLocalTips(content),
    );
  }

  // 추출 헬퍼 메서드들
  List<String> _extractDestinations(String content) {
    final matches = RegExp(r'추천 여행지[:\s]*([^\n]+)').allMatches(content);
    return matches.map((m) => m.group(1)?.trim() ?? '').where((s) => s.isNotEmpty).toList();
  }

  List<String> _extractActivities(String content) {
    final matches = RegExp(r'활동|액티비티[:\s]*([^\n]+)').allMatches(content);
    return matches.map((m) => m.group(1)?.trim() ?? '').where((s) => s.isNotEmpty).toList();
  }

  int? _extractBudget(String content) {
    final match = RegExp(r'(\d{1,3}(?:,\d{3})*)\s*원').firstMatch(content);
    if (match != null) {
      final budgetStr = match.group(1)?.replaceAll(',', '');
      return int.tryParse(budgetStr ?? '');
    }
    return null;
  }

  String? _extractBestTime(String content) {
    final match = RegExp(r'최적 시기[:\s]*([^\n]+)').firstMatch(content);
    return match?.group(1)?.trim();
  }

  List<String> _extractTips(String content) {
    final lines = content.split('\n');
    return lines.where((line) => line.contains('팁') || line.contains('조언')).toList();
  }

  List<DayPlan> _extractDayPlans(String content) {
    // 일정 파싱 로직
    return [];
  }

  int _extractTotalBudget(String content) {
    final match = RegExp(r'총\s*예산[:\s]*(\d{1,3}(?:,\d{3})*)\s*원').firstMatch(content);
    if (match != null) {
      final budgetStr = match.group(1)?.replaceAll(',', '');
      return int.tryParse(budgetStr ?? '') ?? 0;
    }
    return 0;
  }

  List<String> _extractHighlights(String content) {
    final matches = RegExp(r'하이라이트[:\s]*([^\n]+)').allMatches(content);
    return matches.map((m) => m.group(1)?.trim() ?? '').where((s) => s.isNotEmpty).toList();
  }

  List<String> _extractTrends(String content) {
    return content.split('\n').where((line) => line.contains('트렌드')).toList();
  }

  List<String> _extractSeasons(String content) {
    return content.split('\n').where((line) => line.contains('계절') || line.contains('시기')).toList();
  }

  List<String> _extractWarnings(String content) {
    return content.split('\n').where((line) => line.contains('주의') || line.contains('경고')).toList();
  }

  List<String> _extractSpots(String content) {
    return content.split('\n').where((line) => line.contains('명소') || line.contains('관광지')).toList();
  }

  List<String> _extractLocalTips(String content) {
    return content.split('\n').where((line) => line.contains('현지') || line.contains('로컬')).toList();
  }
}

// Data Models
class TravelContext {
  final int? budget;
  final int? duration;
  final int? travelers;
  final List<String> preferences;

  TravelContext({
    this.budget,
    this.duration,
    this.travelers,
    this.preferences = const [],
  });
}

class TravelRecommendation {
  final List<String> destinations;
  final List<String> activities;
  final int? estimatedBudget;
  final String? bestTimeToVisit;
  final List<String> tips;
  final String reasoning;

  TravelRecommendation({
    required this.destinations,
    required this.activities,
    this.estimatedBudget,
    this.bestTimeToVisit,
    required this.tips,
    required this.reasoning,
  });
}

class TravelItinerary {
  final List<DayPlan> days;
  final int totalBudget;
  final List<String> highlights;

  TravelItinerary({
    required this.days,
    required this.totalBudget,
    required this.highlights,
  });

  factory TravelItinerary.fromJson(Map<String, dynamic> json) {
    return TravelItinerary(
      days: (json['days'] as List?)
          ?.map((d) => DayPlan.fromJson(d))
          .toList() ?? [],
      totalBudget: json['totalBudget'] ?? 0,
      highlights: List<String>.from(json['highlights'] ?? []),
    );
  }
}

class DayPlan {
  final int day;
  final List<Activity> activities;
  final int dailyBudget;

  DayPlan({
    required this.day,
    required this.activities,
    required this.dailyBudget,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      day: json['day'] ?? 0,
      activities: (json['activities'] as List?)
          ?.map((a) => Activity.fromJson(a))
          .toList() ?? [],
      dailyBudget: json['dailyBudget'] ?? 0,
    );
  }
}

class Activity {
  final String time;
  final String place;
  final String description;
  final int? cost;
  final String? transportation;

  Activity({
    required this.time,
    required this.place,
    required this.description,
    this.cost,
    this.transportation,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      time: json['time'] ?? '',
      place: json['place'] ?? '',
      description: json['description'] ?? '',
      cost: json['cost'],
      transportation: json['transportation'],
    );
  }
}

class TravelInsights {
  final List<String> trends;
  final List<String> bestSeasons;
  final List<String> warnings;
  final List<String> popularSpots;
  final List<String> localTips;

  TravelInsights({
    required this.trends,
    required this.bestSeasons,
    required this.warnings,
    required this.popularSpots,
    required this.localTips,
  });
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class HyperClovaException implements Exception {
  final String message;
  final int? code;

  HyperClovaException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'HyperClovaException: $message (code: $code)';
}