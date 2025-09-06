import 'dart:convert';
import 'dart:math';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../../../data/api/ai_service.dart';
import '../../../data/models/ai_recommendation_model.dart';
import '../../../core/environment/app_environment.dart';
import '../profiling/user_preference_analyzer.dart';
import '../profiling/travel_style_classifier.dart';
import '../profiling/budget_analyzer.dart';

enum ConversationState {
  greeting,
  gatheringPreferences,
  analyzing,
  presentingOptions,
  refining,
  finalizing,
  completed
}

enum IntentType {
  greeting,
  destinationInquiry,
  budgetInquiry,
  durationInquiry,
  activityInquiry,
  travelStyleInquiry,
  bookingIntent,
  comparison,
  modification,
  confirmation,
  unknown
}

class ConversationContext {
  final Map<String, dynamic> extractedInfo;
  final ConversationState currentState;
  final List<String> conversationHistory;
  final Map<String, double> confidenceScores;
  final UserPreferenceProfile? userPreferences;
  final TravelStyleProfile? travelStyle;
  final BudgetProfile? budgetProfile;
  final DateTime createdAt;
  final DateTime lastUpdated;

  const ConversationContext({
    required this.extractedInfo,
    required this.currentState,
    required this.conversationHistory,
    required this.confidenceScores,
    this.userPreferences,
    this.travelStyle,
    this.budgetProfile,
    required this.createdAt,
    required this.lastUpdated,
  });

  ConversationContext copyWith({
    Map<String, dynamic>? extractedInfo,
    ConversationState? currentState,
    List<String>? conversationHistory,
    Map<String, double>? confidenceScores,
    UserPreferenceProfile? userPreferences,
    TravelStyleProfile? travelStyle,
    BudgetProfile? budgetProfile,
    DateTime? lastUpdated,
  }) {
    return ConversationContext(
      extractedInfo: extractedInfo ?? this.extractedInfo,
      currentState: currentState ?? this.currentState,
      conversationHistory: conversationHistory ?? this.conversationHistory,
      confidenceScores: confidenceScores ?? this.confidenceScores,
      userPreferences: userPreferences ?? this.userPreferences,
      travelStyle: travelStyle ?? this.travelStyle,
      budgetProfile: budgetProfile ?? this.budgetProfile,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class DialogflowResponse {
  final String response;
  final List<QuickReply> quickReplies;
  final List<ActionSuggestion> suggestions;
  final ConversationContext updatedContext;
  final List<AIRecommendationModel>? recommendations;
  final bool needsUserInput;
  final double confidence;

  const DialogflowResponse({
    required this.response,
    required this.quickReplies,
    required this.suggestions,
    required this.updatedContext,
    this.recommendations,
    required this.needsUserInput,
    required this.confidence,
  });
}

class DialogflowService {
  final AIService _aiService;
  final Map<String, ConversationContext> _activeContexts = {};

  // NLP patterns for intent recognition
  static const Map<IntentType, List<String>> _intentPatterns = {
    IntentType.greeting: ['hello', 'hi', 'hey', '안녕', 'start', 'help'],
    IntentType.destinationInquiry: ['where', 'destination', '어디', 'country', 'city', '여행지', '목적지'],
    IntentType.budgetInquiry: ['budget', 'price', 'cost', 'money', '예산', '가격', '비용', 'cheap', 'expensive'],
    IntentType.durationInquiry: ['duration', 'days', 'weeks', '기간', '며칠', 'long', 'short'],
    IntentType.activityInquiry: ['activity', 'do', 'experience', '활동', '체험', 'sightseeing', 'adventure'],
    IntentType.travelStyleInquiry: ['style', 'type', 'luxury', 'budget', 'family', '스타일', '종류'],
    IntentType.bookingIntent: ['book', 'reserve', 'buy', '예약', '구매', 'purchase'],
    IntentType.comparison: ['compare', 'vs', 'versus', '비교', 'better', 'difference'],
    IntentType.modification: ['change', 'modify', 'different', '변경', '바꿔', 'another'],
    IntentType.confirmation: ['yes', 'ok', 'sure', 'confirm', '네', '좋아', 'agree'],
  };

  // Response templates
  static const Map<ConversationState, List<String>> _responseTemplates = {
    ConversationState.greeting: [
      "안녕하세요! TravelMate AI 여행 컨설턴트입니다. 완벽한 여행을 계획해드릴게요! 어떤 여행을 원하시나요?",
      "반갑습니다! 맞춤형 여행 추천을 위해 도와드리겠습니다. 먼저 어디로 여행을 가고 싶으신가요?",
      "Hello! I'm your TravelMate AI consultant. Let me help you plan the perfect trip! What kind of travel experience are you looking for?",
    ],
    ConversationState.gatheringPreferences: [
      "좋은 선택이네요! {destination}에 대해 더 알려주세요. 예산 범위는 어느 정도 생각하고 계신가요?",
      "훌륭합니다! 며칠 정도 여행을 계획하고 계신가요?",
      "어떤 종류의 활동을 선호하시나요? 예를 들어, 관광, 휴식, 모험 등?",
    ],
    ConversationState.analyzing: [
      "정보를 분석하고 있습니다... 잠시만 기다려주세요.",
      "맞춤형 추천을 준비하고 있어요. 곧 완성됩니다!",
      "최적의 여행 옵션을 찾고 있습니다...",
    ],
    ConversationState.presentingOptions: [
      "분석이 완료되었습니다! 고객님께 완벽한 여행 옵션들을 찾았어요.",
      "맞춤형 추천이 준비되었습니다. 이런 옵션들은 어떠신가요?",
      "여러분의 취향에 맞는 여행 패키지를 선별했습니다.",
    ],
  };

  DialogflowService(this._aiService);

  /// Processes user message and returns AI response
  Future<DialogflowResponse> processMessage({
    required String sessionId,
    required String message,
    UserPreferenceProfile? userPreferences,
    TravelStyleProfile? travelStyle,
    BudgetProfile? budgetProfile,
  }) async {
    try {
      // Get or create conversation context
      var context = _activeContexts[sessionId] ?? _createInitialContext(
        userPreferences: userPreferences,
        travelStyle: travelStyle,
        budgetProfile: budgetProfile,
      );

      // Analyze user intent
      final intent = await _analyzeIntent(message);
      final extractedInfo = await _extractInformation(message, intent);

      // Update context with new information
      context = _updateContext(context, message, intent, extractedInfo);

      // Determine next state and response
      final nextState = _determineNextState(context, intent);
      final response = await _generateResponse(context, nextState, intent);

      // Update context with new state
      final updatedContext = context.copyWith(
        currentState: nextState,
        lastUpdated: DateTime.now(),
      );
      _activeContexts[sessionId] = updatedContext;

      return response;
    } catch (e) {
      return _createErrorResponse(
        _activeContexts[sessionId] ?? _createInitialContext(),
        e.toString(),
      );
    }
  }

  /// Analyzes image to extract travel-related information
  Future<Map<String, dynamic>> analyzeImageContext(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final imageLabeler = ImageLabeler(options: ImageLabelerOptions());
      final textRecognizer = TextRecognizer();

      // Extract labels from image
      final labels = await imageLabeler.processImage(inputImage);
      final recognizedText = await textRecognizer.processImage(inputImage);

      // Analyze labels for travel-related content
      final travelKeywords = <String>[];
      final landmarks = <String>[];
      final activities = <String>[];

      for (final label in labels) {
        final labelText = label.label.toLowerCase();
        
        if (_isTravelRelated(labelText)) {
          travelKeywords.add(label.label);
          
          if (_isLandmark(labelText)) {
            landmarks.add(label.label);
          }
          
          if (_isActivity(labelText)) {
            activities.add(label.label);
          }
        }
      }

      // Extract text that might contain location info
      final locationTexts = <String>[];
      for (final textBlock in recognizedText.blocks) {
        final text = textBlock.text.toLowerCase();
        if (_containsLocationInfo(text)) {
          locationTexts.add(textBlock.text);
        }
      }

      // Cleanup
      imageLabeler.close();
      textRecognizer.close();

      return {
        'keywords': travelKeywords,
        'landmarks': landmarks,
        'activities': activities,
        'locationTexts': locationTexts,
        'confidence': _calculateImageAnalysisConfidence(labels, recognizedText),
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'keywords': <String>[],
        'landmarks': <String>[],
        'activities': <String>[],
        'locationTexts': <String>[],
        'confidence': 0.0,
      };
    }
  }

  /// Generates personalized conversation starters
  Future<List<String>> generateConversationStarters({
    UserPreferenceProfile? userPreferences,
    TravelStyleProfile? travelStyle,
    BudgetProfile? budgetProfile,
  }) async {
    final starters = <String>[];

    // Based on travel style
    if (travelStyle != null) {
      switch (travelStyle.primaryStyle) {
        case TravelStyle.luxury:
          starters.add("럭셔리 여행을 원하시는군요! 어떤 프리미엄 경험을 찾고 계신가요?");
          break;
        case TravelStyle.budget:
          starters.add("합리적인 여행을 계획하시는군요! 저렴하면서도 특별한 여행지를 추천해드릴게요.");
          break;
        case TravelStyle.family:
          starters.add("가족 여행을 계획하고 계시네요! 온 가족이 즐길 수 있는 여행지를 찾아보실까요?");
          break;
        case TravelStyle.adventure:
          starters.add("모험을 원하시는군요! 어떤 스릴 넘치는 활동을 경험해보고 싶으신가요?");
          break;
        default:
          starters.add("어떤 스타일의 여행을 원하시는지 알려주세요!");
      }
    }

    // Based on preferences
    if (userPreferences != null) {
      final topDestination = userPreferences.destinationPreferences.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      starters.add("${topDestination.key} 같은 곳을 좋아하시는군요! 비슷한 매력의 여행지를 추천해드릴까요?");

      final topActivity = userPreferences.activityPreferences.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      starters.add("${topActivity.key}을 즐기시는군요! 관련된 특별한 체험을 찾아보실까요?");
    }

    // Based on budget
    if (budgetProfile != null) {
      switch (budgetProfile.primaryCategory) {
        case BudgetCategory.luxury:
          starters.add("프리미엄 여행 경험을 원하시는군요! 최고급 서비스를 경험할 수 있는 곳을 추천해드릴게요.");
          break;
        case BudgetCategory.budget:
          starters.add("가성비 좋은 여행을 찾고 계시는군요! 저렴하지만 만족스러운 여행지를 소개해드릴게요.");
          break;
        default:
          starters.add("적절한 예산으로 최고의 경험을 만들어드릴게요!");
      }
    }

    // Default starters
    if (starters.isEmpty) {
      starters.addAll([
        "어디로 여행을 떠나고 싶으신가요? 🌍",
        "어떤 종류의 여행 경험을 원하시나요? ✈️",
        "언제쯤 여행을 계획하고 계신가요? 📅",
        "누구와 함께 여행하실 예정인가요? 👥",
      ]);
    }

    return starters;
  }

  /// Ends conversation session
  void endSession(String sessionId) {
    _activeContexts.remove(sessionId);
  }

  /// Gets current conversation context
  ConversationContext? getContext(String sessionId) {
    return _activeContexts[sessionId];
  }

  // Private helper methods

  ConversationContext _createInitialContext({
    UserPreferenceProfile? userPreferences,
    TravelStyleProfile? travelStyle,
    BudgetProfile? budgetProfile,
  }) {
    return ConversationContext(
      extractedInfo: <String, dynamic>{},
      currentState: ConversationState.greeting,
      conversationHistory: [],
      confidenceScores: <String, double>{},
      userPreferences: userPreferences,
      travelStyle: travelStyle,
      budgetProfile: budgetProfile,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  Future<IntentType> _analyzeIntent(String message) async {
    final lowerMessage = message.toLowerCase();
    final scores = <IntentType, double>{};

    for (final intent in IntentType.values) {
      final patterns = _intentPatterns[intent] ?? [];
      double score = 0.0;

      for (final pattern in patterns) {
        if (lowerMessage.contains(pattern)) {
          score += 1.0;
        }
        
        // Fuzzy matching for similar words
        if (_calculateSimilarity(pattern, lowerMessage) > 0.7) {
          score += 0.5;
        }
      }

      scores[intent] = score;
    }

    // Return intent with highest score
    final bestIntent = scores.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    return bestIntent.value > 0 ? bestIntent.key : IntentType.unknown;
  }

  Future<Map<String, dynamic>> _extractInformation(String message, IntentType intent) async {
    final info = <String, dynamic>{};

    switch (intent) {
      case IntentType.destinationInquiry:
        info['destination'] = await _extractDestination(message);
        break;
      case IntentType.budgetInquiry:
        info['budget'] = await _extractBudget(message);
        break;
      case IntentType.durationInquiry:
        info['duration'] = await _extractDuration(message);
        break;
      case IntentType.activityInquiry:
        info['activities'] = await _extractActivities(message);
        break;
      case IntentType.travelStyleInquiry:
        info['travelStyle'] = await _extractTravelStyle(message);
        break;
      default:
        break;
    }

    return info;
  }

  ConversationContext _updateContext(
    ConversationContext context,
    String message,
    IntentType intent,
    Map<String, dynamic> extractedInfo,
  ) {
    final updatedInfo = Map<String, dynamic>.from(context.extractedInfo);
    final updatedHistory = List<String>.from(context.conversationHistory)..add(message);
    final updatedConfidence = Map<String, double>.from(context.confidenceScores);

    // Merge extracted information
    extractedInfo.forEach((key, value) {
      if (value != null) {
        updatedInfo[key] = value;
        updatedConfidence[key] = _calculateExtractionConfidence(key, value);
      }
    });

    return context.copyWith(
      extractedInfo: updatedInfo,
      conversationHistory: updatedHistory,
      confidenceScores: updatedConfidence,
      lastUpdated: DateTime.now(),
    );
  }

  ConversationState _determineNextState(ConversationContext context, IntentType intent) {
    final currentState = context.currentState;
    final hasRequiredInfo = _hasRequiredInformation(context);

    switch (currentState) {
      case ConversationState.greeting:
        return ConversationState.gatheringPreferences;
        
      case ConversationState.gatheringPreferences:
        if (hasRequiredInfo) {
          return ConversationState.analyzing;
        }
        return ConversationState.gatheringPreferences;
        
      case ConversationState.analyzing:
        return ConversationState.presentingOptions;
        
      case ConversationState.presentingOptions:
        if (intent == IntentType.modification) {
          return ConversationState.refining;
        } else if (intent == IntentType.confirmation || intent == IntentType.bookingIntent) {
          return ConversationState.finalizing;
        }
        return ConversationState.presentingOptions;
        
      case ConversationState.refining:
        return ConversationState.presentingOptions;
        
      case ConversationState.finalizing:
        return ConversationState.completed;
        
      case ConversationState.completed:
        return ConversationState.completed;
    }
  }

  Future<DialogflowResponse> _generateResponse(
    ConversationContext context,
    ConversationState nextState,
    IntentType intent,
  ) async {
    final templates = _responseTemplates[nextState] ?? ['죄송합니다. 다시 말씀해주시겠어요?'];
    var response = _selectRandomTemplate(templates);

    // Personalize response based on context
    response = _personalizeResponse(response, context);

    // Generate quick replies and suggestions
    final quickReplies = await _generateQuickReplies(nextState, context);
    final suggestions = await _generateSuggestions(nextState, context);

    // Generate recommendations if in presenting options state
    List<AIRecommendationModel>? recommendations;
    if (nextState == ConversationState.presentingOptions) {
      recommendations = await _generateRecommendations(context);
    }

    return DialogflowResponse(
      response: response,
      quickReplies: quickReplies,
      suggestions: suggestions,
      updatedContext: context.copyWith(currentState: nextState),
      recommendations: recommendations,
      needsUserInput: _needsUserInput(nextState),
      confidence: _calculateResponseConfidence(context, nextState),
    );
  }

  DialogflowResponse _createErrorResponse(ConversationContext context, String error) {
    return DialogflowResponse(
      response: "죄송합니다. 처리 중 오류가 발생했습니다. 다시 시도해주시겠어요?",
      quickReplies: [
        const QuickReply(text: "다시 시도", value: "retry"),
        const QuickReply(text: "처음부터", value: "restart"),
      ],
      suggestions: [],
      updatedContext: context,
      recommendations: null,
      needsUserInput: true,
      confidence: 0.1,
    );
  }

  // Information extraction methods

  Future<String?> _extractDestination(String message) async {
    final destinations = [
      'japan', 'korea', 'thailand', 'vietnam', 'singapore', 'malaysia', 'china',
      '일본', '한국', '태국', '베트남', '싱가포르', '말레이시아', '중국'
    ];

    final lowerMessage = message.toLowerCase();
    for (final destination in destinations) {
      if (lowerMessage.contains(destination)) {
        return destination;
      }
    }

    return null;
  }

  Future<Map<String, double>?> _extractBudget(String message) async {
    // Extract budget information using regex
    final budgetPatterns = [
      RegExp(r'(\d+)만원'),
      RegExp(r'(\d+)천만원'),
      RegExp(r'(\d+)\s*million'),
      RegExp(r'(\d+)\s*thousand'),
    ];

    for (final pattern in budgetPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final amount = double.tryParse(match.group(1) ?? '0') ?? 0;
        return {
          'min': amount * 0.8,
          'max': amount * 1.2,
          'preferred': amount,
        };
      }
    }

    // Budget category keywords
    if (message.contains('저렴') || message.contains('budget') || message.contains('cheap')) {
      return {'min': 500000, 'max': 1500000, 'preferred': 1000000};
    } else if (message.contains('럭셔리') || message.contains('luxury') || message.contains('expensive')) {
      return {'min': 3000000, 'max': 10000000, 'preferred': 5000000};
    }

    return null;
  }

  Future<Map<String, int>?> _extractDuration(String message) async {
    final durationPatterns = [
      RegExp(r'(\d+)일'),
      RegExp(r'(\d+)\s*days?'),
      RegExp(r'(\d+)박\s*(\d+)일'),
    ];

    for (final pattern in durationPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final days = int.tryParse(match.group(1) ?? '0') ?? 0;
        return {'days': days, 'nights': max(0, days - 1)};
      }
    }

    return null;
  }

  Future<List<String>?> _extractActivities(String message) async {
    final activityMap = {
      '관광': 'sightseeing',
      '휴식': 'relaxation',
      '모험': 'adventure',
      '문화': 'culture',
      '음식': 'culinary',
      '쇼핑': 'shopping',
      'spa': 'wellness',
      '자연': 'nature',
    };

    final foundActivities = <String>[];
    final lowerMessage = message.toLowerCase();

    activityMap.forEach((korean, english) {
      if (lowerMessage.contains(korean) || lowerMessage.contains(english)) {
        foundActivities.add(english);
      }
    });

    return foundActivities.isNotEmpty ? foundActivities : null;
  }

  Future<String?> _extractTravelStyle(String message) async {
    final styleMap = {
      '럭셔리': 'luxury',
      '버젯': 'budget',
      '가족': 'family',
      '비즈니스': 'business',
      '모험': 'adventure',
      '문화': 'cultural',
    };

    final lowerMessage = message.toLowerCase();
    for (final entry in styleMap.entries) {
      if (lowerMessage.contains(entry.key) || lowerMessage.contains(entry.value)) {
        return entry.value;
      }
    }

    return null;
  }

  // Helper methods for ML Kit image analysis

  bool _isTravelRelated(String label) {
    const travelKeywords = [
      'building', 'landmark', 'tower', 'temple', 'church', 'beach', 'mountain',
      'architecture', 'tourism', 'city', 'nature', 'water', 'sky', 'food'
    ];
    return travelKeywords.any((keyword) => label.contains(keyword));
  }

  bool _isLandmark(String label) {
    const landmarkKeywords = [
      'tower', 'temple', 'church', 'castle', 'monument', 'statue', 'bridge'
    ];
    return landmarkKeywords.any((keyword) => label.contains(keyword));
  }

  bool _isActivity(String label) {
    const activityKeywords = [
      'sport', 'hiking', 'swimming', 'skiing', 'diving', 'climbing', 'surfing'
    ];
    return activityKeywords.any((keyword) => label.contains(keyword));
  }

  bool _containsLocationInfo(String text) {
    // Check if text contains location-related information
    const locationPatterns = [
      'hotel', 'restaurant', 'airport', 'station', 'street', 'avenue', 'road'
    ];
    final lowerText = text.toLowerCase();
    return locationPatterns.any((pattern) => lowerText.contains(pattern));
  }

  double _calculateImageAnalysisConfidence(List<ImageLabel> labels, RecognizedText recognizedText) {
    if (labels.isEmpty && recognizedText.blocks.isEmpty) return 0.0;

    final labelConfidence = labels.isEmpty 
        ? 0.0 
        : labels.map((label) => label.confidence).reduce((a, b) => a + b) / labels.length;

    final textConfidence = recognizedText.blocks.isEmpty 
        ? 0.0 
        : 0.8; // Assume good text recognition if text found

    return (labelConfidence + textConfidence) / 2;
  }

  // Utility methods

  double _calculateSimilarity(String pattern, String message) {
    // Simple similarity calculation (can be enhanced with more sophisticated NLP)
    if (pattern.length > message.length) return _calculateSimilarity(message, pattern);
    
    int matches = 0;
    for (int i = 0; i < pattern.length; i++) {
      if (message.contains(pattern[i])) matches++;
    }
    
    return matches / pattern.length;
  }

  double _calculateExtractionConfidence(String key, dynamic value) {
    // Calculate confidence based on extraction type and value
    switch (key) {
      case 'destination':
        return value is String && value.isNotEmpty ? 0.8 : 0.3;
      case 'budget':
        return value is Map ? 0.9 : 0.4;
      case 'duration':
        return value is Map ? 0.9 : 0.4;
      case 'activities':
        return value is List && (value as List).isNotEmpty ? 0.7 : 0.3;
      default:
        return 0.5;
    }
  }

  bool _hasRequiredInformation(ConversationContext context) {
    final info = context.extractedInfo;
    return info.containsKey('destination') && 
           (info.containsKey('budget') || info.containsKey('duration'));
  }

  String _selectRandomTemplate(List<String> templates) {
    final random = Random();
    return templates[random.nextInt(templates.length)];
  }

  String _personalizeResponse(String response, ConversationContext context) {
    var personalizedResponse = response;

    // Replace placeholders with actual information
    final destination = context.extractedInfo['destination'];
    if (destination != null) {
      personalizedResponse = personalizedResponse.replaceAll('{destination}', destination);
    }

    // Add personal touches based on travel style
    if (context.travelStyle?.primaryStyle == TravelStyle.luxury) {
      personalizedResponse = personalizedResponse.replaceAll('여행', '프리미엄 여행');
    }

    return personalizedResponse;
  }

  Future<List<QuickReply>> _generateQuickReplies(
    ConversationState state,
    ConversationContext context,
  ) async {
    switch (state) {
      case ConversationState.greeting:
        return [
          const QuickReply(text: "국내 여행", value: "domestic"),
          const QuickReply(text: "해외 여행", value: "international"),
          const QuickReply(text: "추천받기", value: "recommend"),
        ];
        
      case ConversationState.gatheringPreferences:
        final replies = <QuickReply>[];
        if (!context.extractedInfo.containsKey('budget')) {
          replies.addAll([
            const QuickReply(text: "100만원 이하", value: "budget_low"),
            const QuickReply(text: "200만원 정도", value: "budget_mid"),
            const QuickReply(text: "500만원 이상", value: "budget_high"),
          ]);
        }
        if (!context.extractedInfo.containsKey('duration')) {
          replies.addAll([
            const QuickReply(text: "2-3일", value: "duration_short"),
            const QuickReply(text: "일주일", value: "duration_week"),
            const QuickReply(text: "2주 이상", value: "duration_long"),
          ]);
        }
        return replies;
        
      case ConversationState.presentingOptions:
        return [
          const QuickReply(text: "자세히 보기", value: "details"),
          const QuickReply(text: "다른 옵션", value: "alternatives"),
          const QuickReply(text: "예약하기", value: "book"),
        ];
        
      default:
        return [];
    }
  }

  Future<List<ActionSuggestion>> _generateSuggestions(
    ConversationState state,
    ConversationContext context,
  ) async {
    switch (state) {
      case ConversationState.presentingOptions:
        return [
          const ActionSuggestion(
            action: "view_package",
            title: "패키지 상세보기",
            description: "추천된 여행 패키지의 자세한 정보를 확인하세요",
          ),
          const ActionSuggestion(
            action: "compare_options",
            title: "옵션 비교하기",
            description: "여러 여행 옵션을 비교해보세요",
          ),
        ];
      default:
        return [];
    }
  }

  Future<List<AIRecommendationModel>?> _generateRecommendations(
    ConversationContext context,
  ) async {
    // This would typically call the RecommendationEngine
    // For now, return null to indicate no recommendations generated
    return null;
  }

  bool _needsUserInput(ConversationState state) {
    return state != ConversationState.analyzing && state != ConversationState.completed;
  }

  double _calculateResponseConfidence(ConversationContext context, ConversationState state) {
    final infoConfidence = context.confidenceScores.values.isEmpty 
        ? 0.5 
        : context.confidenceScores.values.reduce((a, b) => a + b) / context.confidenceScores.length;

    final stateConfidence = state == ConversationState.presentingOptions ? 0.9 : 0.7;

    return (infoConfidence + stateConfidence) / 2;
  }
}