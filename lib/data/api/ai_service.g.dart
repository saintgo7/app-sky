// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationRequest _$RecommendationRequestFromJson(
        Map<String, dynamic> json) =>
    RecommendationRequest(
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      destination: json['destination'] as String?,
      budget: (json['budget'] as num?)?.toDouble(),
      budgetCurrency: json['budgetCurrency'] as String?,
      travelStartDate: json['travelStartDate'] == null
          ? null
          : DateTime.parse(json['travelStartDate'] as String),
      travelEndDate: json['travelEndDate'] == null
          ? null
          : DateTime.parse(json['travelEndDate'] as String),
      travelers: (json['travelers'] as num?)?.toInt(),
      travelStyle: json['travelStyle'] as String?,
      previousDestinations: (json['previousDestinations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      occasion: json['occasion'] as String?,
      context: json['context'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RecommendationRequestToJson(
        RecommendationRequest instance) =>
    <String, dynamic>{
      'interests': instance.interests,
      'destination': instance.destination,
      'budget': instance.budget,
      'budgetCurrency': instance.budgetCurrency,
      'travelStartDate': instance.travelStartDate?.toIso8601String(),
      'travelEndDate': instance.travelEndDate?.toIso8601String(),
      'travelers': instance.travelers,
      'travelStyle': instance.travelStyle,
      'previousDestinations': instance.previousDestinations,
      'occasion': instance.occasion,
      'context': instance.context,
    };

RecommendationQuery _$RecommendationQueryFromJson(Map<String, dynamic> json) =>
    RecommendationQuery(
      type: $enumDecodeNullable(_$RecommendationTypeEnumMap, json['type']),
      limit: (json['limit'] as num?)?.toInt(),
      minConfidence: (json['minConfidence'] as num?)?.toDouble(),
      includeViewed: json['includeViewed'] as bool?,
      sortBy: json['sortBy'] as String?,
    );

Map<String, dynamic> _$RecommendationQueryToJson(
        RecommendationQuery instance) =>
    <String, dynamic>{
      'type': _$RecommendationTypeEnumMap[instance.type],
      'limit': instance.limit,
      'minConfidence': instance.minConfidence,
      'includeViewed': instance.includeViewed,
      'sortBy': instance.sortBy,
    };

const _$RecommendationTypeEnumMap = {
  RecommendationType.destination: 'destination',
  RecommendationType.package: 'package',
  RecommendationType.activity: 'activity',
  RecommendationType.restaurant: 'restaurant',
  RecommendationType.hotel: 'hotel',
};

RecommendationFeedback _$RecommendationFeedbackFromJson(
        Map<String, dynamic> json) =>
    RecommendationFeedback(
      isLiked: json['isLiked'] as bool,
      isBookmarked: json['isBookmarked'] as bool,
      isBooked: json['isBooked'] as bool,
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$RecommendationFeedbackToJson(
        RecommendationFeedback instance) =>
    <String, dynamic>{
      'isLiked': instance.isLiked,
      'isBookmarked': instance.isBookmarked,
      'isBooked': instance.isBooked,
      'rating': instance.rating,
      'comment': instance.comment,
    };

ItineraryGenerationRequest _$ItineraryGenerationRequestFromJson(
        Map<String, dynamic> json) =>
    ItineraryGenerationRequest(
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      budget: (json['budget'] as num).toDouble(),
      budgetCurrency: json['budgetCurrency'] as String,
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      travelStyle: json['travelStyle'] as String,
      travelers: (json['travelers'] as num).toInt(),
      accommodationType: json['accommodationType'] as String?,
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accessibility: json['accessibility'] as String?,
      mustVisit: (json['mustVisit'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      avoid:
          (json['avoid'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ItineraryGenerationRequestToJson(
        ItineraryGenerationRequest instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'budget': instance.budget,
      'budgetCurrency': instance.budgetCurrency,
      'interests': instance.interests,
      'travelStyle': instance.travelStyle,
      'travelers': instance.travelers,
      'accommodationType': instance.accommodationType,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'accessibility': instance.accessibility,
      'mustVisit': instance.mustVisit,
      'avoid': instance.avoid,
    };

ItineraryModificationRequest _$ItineraryModificationRequestFromJson(
        Map<String, dynamic> json) =>
    ItineraryModificationRequest(
      dayNumber: (json['dayNumber'] as num?)?.toInt(),
      modificationType: json['modificationType'] as String?,
      modifications: json['modifications'] as Map<String, dynamic>,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ItineraryModificationRequestToJson(
        ItineraryModificationRequest instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'modificationType': instance.modificationType,
      'modifications': instance.modifications,
      'reason': instance.reason,
    };

ItineraryQuery _$ItineraryQueryFromJson(Map<String, dynamic> json) =>
    ItineraryQuery(
      destination: json['destination'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      limit: (json['limit'] as num?)?.toInt(),
      sortBy: json['sortBy'] as String?,
    );

Map<String, dynamic> _$ItineraryQueryToJson(ItineraryQuery instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'limit': instance.limit,
      'sortBy': instance.sortBy,
    };

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String?,
      message: json['message'] as String,
      messageType: json['messageType'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      sender: json['sender'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'messageType': instance.messageType,
      'timestamp': instance.timestamp?.toIso8601String(),
      'sender': instance.sender,
      'metadata': instance.metadata,
    };

ChatHistoryQuery _$ChatHistoryQueryFromJson(Map<String, dynamic> json) =>
    ChatHistoryQuery(
      limit: (json['limit'] as num?)?.toInt(),
      before: json['before'] == null
          ? null
          : DateTime.parse(json['before'] as String),
      after: json['after'] == null
          ? null
          : DateTime.parse(json['after'] as String),
    );

Map<String, dynamic> _$ChatHistoryQueryToJson(ChatHistoryQuery instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'before': instance.before?.toIso8601String(),
      'after': instance.after?.toIso8601String(),
    };

SmartSearchRequest _$SmartSearchRequestFromJson(Map<String, dynamic> json) =>
    SmartSearchRequest(
      query: json['query'] as String,
      context: json['context'] as String?,
      filters: json['filters'] as Map<String, dynamic>?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$SmartSearchRequestToJson(SmartSearchRequest instance) =>
    <String, dynamic>{
      'query': instance.query,
      'context': instance.context,
      'filters': instance.filters,
      'userId': instance.userId,
    };

AutocompleteRequest _$AutocompleteRequestFromJson(Map<String, dynamic> json) =>
    AutocompleteRequest(
      query: json['query'] as String,
      type: json['type'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AutocompleteRequestToJson(
        AutocompleteRequest instance) =>
    <String, dynamic>{
      'query': instance.query,
      'type': instance.type,
      'limit': instance.limit,
    };

SearchIntentRequest _$SearchIntentRequestFromJson(Map<String, dynamic> json) =>
    SearchIntentRequest(
      query: json['query'] as String,
      context: json['context'] as String?,
    );

Map<String, dynamic> _$SearchIntentRequestToJson(
        SearchIntentRequest instance) =>
    <String, dynamic>{
      'query': instance.query,
      'context': instance.context,
    };

ImageAnalysisRequest _$ImageAnalysisRequestFromJson(
        Map<String, dynamic> json) =>
    ImageAnalysisRequest(
      imageUrl: json['imageUrl'] as String,
      analysisType: json['analysisType'] as String?,
    );

Map<String, dynamic> _$ImageAnalysisRequestToJson(
        ImageAnalysisRequest instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'analysisType': instance.analysisType,
    };

DestinationRecognitionRequest _$DestinationRecognitionRequestFromJson(
        Map<String, dynamic> json) =>
    DestinationRecognitionRequest(
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$DestinationRecognitionRequestToJson(
        DestinationRecognitionRequest instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
    };

RecommendationResponse _$RecommendationResponseFromJson(
        Map<String, dynamic> json) =>
    RecommendationResponse(
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => AIRecommendationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RecommendationResponseToJson(
        RecommendationResponse instance) =>
    <String, dynamic>{
      'recommendations': instance.recommendations,
      'explanation': instance.explanation,
      'confidence': instance.confidence,
      'metadata': instance.metadata,
    };

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) => ChatSession(
      sessionId: json['sessionId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$ChatSessionToJson(ChatSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
      message: ChatMessage.fromJson(json['message'] as Map<String, dynamic>),
      quickReplies: (json['quickReplies'] as List<dynamic>?)
          ?.map((e) => QuickReply.fromJson(e as Map<String, dynamic>))
          .toList(),
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => ActionSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'quickReplies': instance.quickReplies,
      'suggestions': instance.suggestions,
      'confidence': instance.confidence,
    };

QuickReply _$QuickReplyFromJson(Map<String, dynamic> json) => QuickReply(
      text: json['text'] as String,
      value: json['value'] as String,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$QuickReplyToJson(QuickReply instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
      'type': instance.type,
    };

ActionSuggestion _$ActionSuggestionFromJson(Map<String, dynamic> json) =>
    ActionSuggestion(
      action: json['action'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      parameters: json['parameters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ActionSuggestionToJson(ActionSuggestion instance) =>
    <String, dynamic>{
      'action': instance.action,
      'title': instance.title,
      'description': instance.description,
      'parameters': instance.parameters,
    };

SmartSearchResponse _$SmartSearchResponseFromJson(Map<String, dynamic> json) =>
    SmartSearchResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      intent: SearchIntent.fromJson(json['intent'] as Map<String, dynamic>),
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => SearchSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$SmartSearchResponseToJson(
        SmartSearchResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
      'intent': instance.intent,
      'suggestions': instance.suggestions,
      'totalCount': instance.totalCount,
    };

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'relevanceScore': instance.relevanceScore,
      'data': instance.data,
    };

SearchIntent _$SearchIntentFromJson(Map<String, dynamic> json) => SearchIntent(
      primaryIntent: json['primaryIntent'] as String,
      secondaryIntents: (json['secondaryIntents'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      extractedEntities: json['extractedEntities'] as Map<String, dynamic>,
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$SearchIntentToJson(SearchIntent instance) =>
    <String, dynamic>{
      'primaryIntent': instance.primaryIntent,
      'secondaryIntents': instance.secondaryIntents,
      'extractedEntities': instance.extractedEntities,
      'confidence': instance.confidence,
    };

SearchSuggestion _$SearchSuggestionFromJson(Map<String, dynamic> json) =>
    SearchSuggestion(
      suggestion: json['suggestion'] as String,
      type: json['type'] as String,
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
    );

Map<String, dynamic> _$SearchSuggestionToJson(SearchSuggestion instance) =>
    <String, dynamic>{
      'suggestion': instance.suggestion,
      'type': instance.type,
      'relevanceScore': instance.relevanceScore,
    };

AutocompleteResponse _$AutocompleteResponseFromJson(
        Map<String, dynamic> json) =>
    AutocompleteResponse(
      suggestions: (json['suggestions'] as List<dynamic>)
          .map(
              (e) => AutocompleteSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AutocompleteResponseToJson(
        AutocompleteResponse instance) =>
    <String, dynamic>{
      'suggestions': instance.suggestions,
    };

AutocompleteSuggestion _$AutocompleteSuggestionFromJson(
        Map<String, dynamic> json) =>
    AutocompleteSuggestion(
      text: json['text'] as String,
      value: json['value'] as String,
      type: json['type'] as String,
      score: (json['score'] as num).toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AutocompleteSuggestionToJson(
        AutocompleteSuggestion instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
      'type': instance.type,
      'score': instance.score,
      'description': instance.description,
    };

SearchIntentResponse _$SearchIntentResponseFromJson(
        Map<String, dynamic> json) =>
    SearchIntentResponse(
      intent: SearchIntent.fromJson(json['intent'] as Map<String, dynamic>),
      suggestedQueries: (json['suggestedQueries'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SearchIntentResponseToJson(
        SearchIntentResponse instance) =>
    <String, dynamic>{
      'intent': instance.intent,
      'suggestedQueries': instance.suggestedQueries,
    };

ImageAnalysisResponse _$ImageAnalysisResponseFromJson(
        Map<String, dynamic> json) =>
    ImageAnalysisResponse(
      objects: (json['objects'] as List<dynamic>)
          .map((e) => RecognizedObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      landmarks:
          (json['landmarks'] as List<dynamic>).map((e) => e as String).toList(),
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      primaryDestination: json['primaryDestination'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ImageAnalysisResponseToJson(
        ImageAnalysisResponse instance) =>
    <String, dynamic>{
      'objects': instance.objects,
      'landmarks': instance.landmarks,
      'activities': instance.activities,
      'primaryDestination': instance.primaryDestination,
      'confidence': instance.confidence,
      'metadata': instance.metadata,
    };

RecognizedObject _$RecognizedObjectFromJson(Map<String, dynamic> json) =>
    RecognizedObject(
      name: json['name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      category: json['category'] as String,
      boundingBox: (json['boundingBox'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$RecognizedObjectToJson(RecognizedObject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'confidence': instance.confidence,
      'category': instance.category,
      'boundingBox': instance.boundingBox,
    };

DestinationRecognitionResponse _$DestinationRecognitionResponseFromJson(
        Map<String, dynamic> json) =>
    DestinationRecognitionResponse(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => RecognizedDestination.fromJson(e as Map<String, dynamic>))
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$DestinationRecognitionResponseToJson(
        DestinationRecognitionResponse instance) =>
    <String, dynamic>{
      'destinations': instance.destinations,
      'confidence': instance.confidence,
    };

RecognizedDestination _$RecognizedDestinationFromJson(
        Map<String, dynamic> json) =>
    RecognizedDestination(
      name: json['name'] as String,
      country: json['country'] as String,
      city: json['city'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RecognizedDestinationToJson(
        RecognizedDestination instance) =>
    <String, dynamic>{
      'name': instance.name,
      'country': instance.country,
      'city': instance.city,
      'confidence': instance.confidence,
      'additionalInfo': instance.additionalInfo,
    };

SentimentAnalysisRequest _$SentimentAnalysisRequestFromJson(
        Map<String, dynamic> json) =>
    SentimentAnalysisRequest(
      texts: (json['texts'] as List<dynamic>).map((e) => e as String).toList(),
      language: json['language'] as String?,
    );

Map<String, dynamic> _$SentimentAnalysisRequestToJson(
        SentimentAnalysisRequest instance) =>
    <String, dynamic>{
      'texts': instance.texts,
      'language': instance.language,
    };

SentimentAnalysisResponse _$SentimentAnalysisResponseFromJson(
        Map<String, dynamic> json) =>
    SentimentAnalysisResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => SentimentResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary:
          SentimentSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SentimentAnalysisResponseToJson(
        SentimentAnalysisResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
      'summary': instance.summary,
    };

SentimentResult _$SentimentResultFromJson(Map<String, dynamic> json) =>
    SentimentResult(
      text: json['text'] as String,
      sentiment: json['sentiment'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      emotions: (json['emotions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$SentimentResultToJson(SentimentResult instance) =>
    <String, dynamic>{
      'text': instance.text,
      'sentiment': instance.sentiment,
      'confidence': instance.confidence,
      'emotions': instance.emotions,
    };

SentimentSummary _$SentimentSummaryFromJson(Map<String, dynamic> json) =>
    SentimentSummary(
      overallScore: (json['overallScore'] as num).toDouble(),
      overallSentiment: json['overallSentiment'] as String,
      sentimentDistribution:
          Map<String, int>.from(json['sentimentDistribution'] as Map),
      keyThemes:
          (json['keyThemes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SentimentSummaryToJson(SentimentSummary instance) =>
    <String, dynamic>{
      'overallScore': instance.overallScore,
      'overallSentiment': instance.overallSentiment,
      'sentimentDistribution': instance.sentimentDistribution,
      'keyThemes': instance.keyThemes,
    };

ReviewSummaryRequest _$ReviewSummaryRequestFromJson(
        Map<String, dynamic> json) =>
    ReviewSummaryRequest(
      itemId: json['itemId'] as String,
      itemType: json['itemType'] as String,
      maxReviews: (json['maxReviews'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReviewSummaryRequestToJson(
        ReviewSummaryRequest instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemType': instance.itemType,
      'maxReviews': instance.maxReviews,
    };

ReviewSummaryResponse _$ReviewSummaryResponseFromJson(
        Map<String, dynamic> json) =>
    ReviewSummaryResponse(
      summary: json['summary'] as String,
      pros: (json['pros'] as List<dynamic>).map((e) => e as String).toList(),
      cons: (json['cons'] as List<dynamic>).map((e) => e as String).toList(),
      keyTopics:
          (json['keyTopics'] as List<dynamic>).map((e) => e as String).toList(),
      sentimentSummary: SentimentSummary.fromJson(
          json['sentimentSummary'] as Map<String, dynamic>),
      totalReviewsAnalyzed: (json['totalReviewsAnalyzed'] as num).toInt(),
    );

Map<String, dynamic> _$ReviewSummaryResponseToJson(
        ReviewSummaryResponse instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'pros': instance.pros,
      'cons': instance.cons,
      'keyTopics': instance.keyTopics,
      'sentimentSummary': instance.sentimentSummary,
      'totalReviewsAnalyzed': instance.totalReviewsAnalyzed,
    };

UserPreferenceProfile _$UserPreferenceProfileFromJson(
        Map<String, dynamic> json) =>
    UserPreferenceProfile(
      userId: json['userId'] as String,
      interestWeights: (json['interestWeights'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      preferences: Map<String, String>.from(json['preferences'] as Map),
      favoriteDestinations: (json['favoriteDestinations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      travelStyle: json['travelStyle'] as String,
      budgetRange: json['budgetRange'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$UserPreferenceProfileToJson(
        UserPreferenceProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'interestWeights': instance.interestWeights,
      'preferences': instance.preferences,
      'favoriteDestinations': instance.favoriteDestinations,
      'travelStyle': instance.travelStyle,
      'budgetRange': instance.budgetRange,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

UpdatePreferencesRequest _$UpdatePreferencesRequestFromJson(
        Map<String, dynamic> json) =>
    UpdatePreferencesRequest(
      interestWeights: (json['interestWeights'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      preferences: (json['preferences'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      favoriteDestinations: (json['favoriteDestinations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      travelStyle: json['travelStyle'] as String?,
      budgetRange: json['budgetRange'] as String?,
    );

Map<String, dynamic> _$UpdatePreferencesRequestToJson(
        UpdatePreferencesRequest instance) =>
    <String, dynamic>{
      'interestWeights': instance.interestWeights,
      'preferences': instance.preferences,
      'favoriteDestinations': instance.favoriteDestinations,
      'travelStyle': instance.travelStyle,
      'budgetRange': instance.budgetRange,
    };

UserBehaviorEvent _$UserBehaviorEventFromJson(Map<String, dynamic> json) =>
    UserBehaviorEvent(
      eventType: json['eventType'] as String,
      itemId: json['itemId'] as String,
      itemType: json['itemType'] as String,
      eventData: json['eventData'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserBehaviorEventToJson(UserBehaviorEvent instance) =>
    <String, dynamic>{
      'eventType': instance.eventType,
      'itemId': instance.itemId,
      'itemType': instance.itemType,
      'eventData': instance.eventData,
      'timestamp': instance.timestamp.toIso8601String(),
    };

PricePredictionRequest _$PricePredictionRequestFromJson(
        Map<String, dynamic> json) =>
    PricePredictionRequest(
      itemId: json['itemId'] as String,
      itemType: json['itemType'] as String,
      targetDate: json['targetDate'] == null
          ? null
          : DateTime.parse(json['targetDate'] as String),
      daysAhead: (json['daysAhead'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PricePredictionRequestToJson(
        PricePredictionRequest instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemType': instance.itemType,
      'targetDate': instance.targetDate?.toIso8601String(),
      'daysAhead': instance.daysAhead,
    };

PricePredictionResponse _$PricePredictionResponseFromJson(
        Map<String, dynamic> json) =>
    PricePredictionResponse(
      itemId: json['itemId'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      predictedPrice: (json['predictedPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      trend: json['trend'] as String,
      recommendation: json['recommendation'] as String,
      predictionDate: DateTime.parse(json['predictionDate'] as String),
    );

Map<String, dynamic> _$PricePredictionResponseToJson(
        PricePredictionResponse instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'currentPrice': instance.currentPrice,
      'predictedPrice': instance.predictedPrice,
      'currency': instance.currency,
      'confidence': instance.confidence,
      'trend': instance.trend,
      'recommendation': instance.recommendation,
      'predictionDate': instance.predictionDate.toIso8601String(),
    };

PriceOptimizationRequest _$PriceOptimizationRequestFromJson(
        Map<String, dynamic> json) =>
    PriceOptimizationRequest(
      itemIds:
          (json['itemIds'] as List<dynamic>).map((e) => e as String).toList(),
      itemType: json['itemType'] as String,
      budget: (json['budget'] as num).toDouble(),
      currency: json['currency'] as String,
      travelDate: json['travelDate'] == null
          ? null
          : DateTime.parse(json['travelDate'] as String),
    );

Map<String, dynamic> _$PriceOptimizationRequestToJson(
        PriceOptimizationRequest instance) =>
    <String, dynamic>{
      'itemIds': instance.itemIds,
      'itemType': instance.itemType,
      'budget': instance.budget,
      'currency': instance.currency,
      'travelDate': instance.travelDate?.toIso8601String(),
    };

PriceOptimizationResponse _$PriceOptimizationResponseFromJson(
        Map<String, dynamic> json) =>
    PriceOptimizationResponse(
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => OptimizedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSavings: (json['totalSavings'] as num).toDouble(),
      currency: json['currency'] as String,
      strategy: json['strategy'] as String,
    );

Map<String, dynamic> _$PriceOptimizationResponseToJson(
        PriceOptimizationResponse instance) =>
    <String, dynamic>{
      'recommendations': instance.recommendations,
      'totalSavings': instance.totalSavings,
      'currency': instance.currency,
      'strategy': instance.strategy,
    };

OptimizedItem _$OptimizedItemFromJson(Map<String, dynamic> json) =>
    OptimizedItem(
      itemId: json['itemId'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      optimizedPrice: (json['optimizedPrice'] as num).toDouble(),
      savings: (json['savings'] as num).toDouble(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$OptimizedItemToJson(OptimizedItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'originalPrice': instance.originalPrice,
      'optimizedPrice': instance.optimizedPrice,
      'savings': instance.savings,
      'reason': instance.reason,
    };

TrendQuery _$TrendQueryFromJson(Map<String, dynamic> json) => TrendQuery(
      timeframe: json['timeframe'] as String?,
      region: json['region'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TrendQueryToJson(TrendQuery instance) =>
    <String, dynamic>{
      'timeframe': instance.timeframe,
      'region': instance.region,
      'limit': instance.limit,
    };

TrendAnalysisResponse _$TrendAnalysisResponseFromJson(
        Map<String, dynamic> json) =>
    TrendAnalysisResponse(
      trends: (json['trends'] as List<dynamic>)
          .map((e) => TrendItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeframe: json['timeframe'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$TrendAnalysisResponseToJson(
        TrendAnalysisResponse instance) =>
    <String, dynamic>{
      'trends': instance.trends,
      'timeframe': instance.timeframe,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

TrendItem _$TrendItemFromJson(Map<String, dynamic> json) => TrendItem(
      name: json['name'] as String,
      trendScore: (json['trendScore'] as num).toDouble(),
      changeDirection: json['changeDirection'] as String,
      changePercentage: (json['changePercentage'] as num).toDouble(),
      reasons:
          (json['reasons'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TrendItemToJson(TrendItem instance) => <String, dynamic>{
      'name': instance.name,
      'trendScore': instance.trendScore,
      'changeDirection': instance.changeDirection,
      'changePercentage': instance.changePercentage,
      'reasons': instance.reasons,
    };

SeasonalTrendQuery _$SeasonalTrendQueryFromJson(Map<String, dynamic> json) =>
    SeasonalTrendQuery(
      season: json['season'] as String,
      region: json['region'] as String?,
      year: (json['year'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SeasonalTrendQueryToJson(SeasonalTrendQuery instance) =>
    <String, dynamic>{
      'season': instance.season,
      'region': instance.region,
      'year': instance.year,
    };

SeasonalTrendResponse _$SeasonalTrendResponseFromJson(
        Map<String, dynamic> json) =>
    SeasonalTrendResponse(
      season: json['season'] as String,
      trends: (json['trends'] as List<dynamic>)
          .map((e) => SeasonalTrend.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$SeasonalTrendResponseToJson(
        SeasonalTrendResponse instance) =>
    <String, dynamic>{
      'season': instance.season,
      'trends': instance.trends,
      'recommendations': instance.recommendations,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

SeasonalTrend _$SeasonalTrendFromJson(Map<String, dynamic> json) =>
    SeasonalTrend(
      destination: json['destination'] as String,
      popularityScore: (json['popularityScore'] as num).toDouble(),
      priceIndex: (json['priceIndex'] as num).toDouble(),
      weatherCondition: json['weatherCondition'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SeasonalTrendToJson(SeasonalTrend instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'popularityScore': instance.popularityScore,
      'priceIndex': instance.priceIndex,
      'weatherCondition': instance.weatherCondition,
      'activities': instance.activities,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _AIService implements AIService {
  _AIService(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<RecommendationResponse> getRecommendations(
    String token,
    RecommendationRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<RecommendationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/recommendations',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RecommendationResponse _value;
    try {
      _value = RecommendationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<AIRecommendationModel>> getUserRecommendations(
    String token,
    RecommendationQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<AIRecommendationModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/recommendations',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<AIRecommendationModel> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              AIRecommendationModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> provideFeedback(
    String token,
    String recommendationId,
    RecommendationFeedback feedback,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(feedback.toJson());
    final _options = _setStreamType<void>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/recommendations/${recommendationId}/feedback',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<AIItineraryModel> generateItinerary(
    String token,
    ItineraryGenerationRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<AIItineraryModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/itinerary/generate',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AIItineraryModel _value;
    try {
      _value = AIItineraryModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AIItineraryModel> modifyItinerary(
    String token,
    String itineraryId,
    ItineraryModificationRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<AIItineraryModel>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/itinerary/${itineraryId}/modify',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AIItineraryModel _value;
    try {
      _value = AIItineraryModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AIItineraryModel> getItinerary(
    String token,
    String itineraryId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<AIItineraryModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/itinerary/${itineraryId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AIItineraryModel _value;
    try {
      _value = AIItineraryModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<AIItineraryModel>> getUserItineraries(
    String token,
    ItineraryQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<AIItineraryModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/itinerary',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<AIItineraryModel> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              AIItineraryModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ChatSession> createChatSession(String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ChatSession>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/chat/sessions',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ChatSession _value;
    try {
      _value = ChatSession.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ChatResponse> sendMessage(
    String token,
    String sessionId,
    ChatMessage message,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(message.toJson());
    final _options = _setStreamType<ChatResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/chat/sessions/${sessionId}/messages',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ChatResponse _value;
    try {
      _value = ChatResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<ChatMessage>> getChatHistory(
    String token,
    String sessionId,
    ChatHistoryQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<ChatMessage>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/chat/sessions/${sessionId}/messages',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<ChatMessage> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => ChatMessage.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> deleteChatSession(
    String token,
    String sessionId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/chat/sessions/${sessionId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<SmartSearchResponse> smartSearch(SmartSearchRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<SmartSearchResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/search/smart',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SmartSearchResponse _value;
    try {
      _value = SmartSearchResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AutocompleteResponse> getAutocomplete(
      AutocompleteRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<AutocompleteResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/search/autocomplete',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AutocompleteResponse _value;
    try {
      _value = AutocompleteResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SearchIntentResponse> analyzeSearchIntent(
      SearchIntentRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<SearchIntentResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/search/intent',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SearchIntentResponse _value;
    try {
      _value = SearchIntentResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ImageAnalysisResponse> analyzeImage(
    String token,
    ImageAnalysisRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<ImageAnalysisResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/image/analyze',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ImageAnalysisResponse _value;
    try {
      _value = ImageAnalysisResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DestinationRecognitionResponse> recognizeDestination(
      DestinationRecognitionRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<DestinationRecognitionResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/image/destinations',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DestinationRecognitionResponse _value;
    try {
      _value = DestinationRecognitionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SentimentAnalysisResponse> analyzeSentiment(
      SentimentAnalysisRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<SentimentAnalysisResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/sentiment/analyze',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SentimentAnalysisResponse _value;
    try {
      _value = SentimentAnalysisResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReviewSummaryResponse> summarizeReviews(
      ReviewSummaryRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<ReviewSummaryResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/reviews/summarize',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReviewSummaryResponse _value;
    try {
      _value = ReviewSummaryResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UserPreferenceProfile> getUserPreferences(String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<UserPreferenceProfile>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/profile/preferences',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UserPreferenceProfile _value;
    try {
      _value = UserPreferenceProfile.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UserPreferenceProfile> updateUserPreferences(
    String token,
    UpdatePreferencesRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<UserPreferenceProfile>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/profile/preferences',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UserPreferenceProfile _value;
    try {
      _value = UserPreferenceProfile.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> recordUserBehavior(
    String token,
    UserBehaviorEvent event,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(event.toJson());
    final _options = _setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/profile/learn',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<PricePredictionResponse> predictPricing(
      PricePredictionRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<PricePredictionResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/pricing/predict',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PricePredictionResponse _value;
    try {
      _value = PricePredictionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PriceOptimizationResponse> optimizePricing(
    String token,
    PriceOptimizationRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<PriceOptimizationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/pricing/optimize',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PriceOptimizationResponse _value;
    try {
      _value = PriceOptimizationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TrendAnalysisResponse> getDestinationTrends(TrendQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TrendAnalysisResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/trends/destinations',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TrendAnalysisResponse _value;
    try {
      _value = TrendAnalysisResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TrendAnalysisResponse> getActivityTrends(TrendQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TrendAnalysisResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/trends/activities',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TrendAnalysisResponse _value;
    try {
      _value = TrendAnalysisResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SeasonalTrendResponse> getSeasonalTrends(
      SeasonalTrendQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<SeasonalTrendResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/ai/trends/seasonal',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SeasonalTrendResponse _value;
    try {
      _value = SeasonalTrendResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
