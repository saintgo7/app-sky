import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/ai_recommendation_model.dart';

part 'ai_service.g.dart';

@RestApi()
abstract class AIService {
  factory AIService(Dio dio, {String? baseUrl}) = _AIService;

  // Travel Recommendations
  @POST('/ai/recommendations')
  Future<RecommendationResponse> getRecommendations(
    @Header('Authorization') String token,
    @Body() RecommendationRequest request,
  );

  @GET('/ai/recommendations')
  Future<List<AIRecommendationModel>> getUserRecommendations(
    @Header('Authorization') String token,
    @Queries() RecommendationQuery query,
  );

  @PUT('/ai/recommendations/{id}/feedback')
  Future<void> provideFeedback(
    @Header('Authorization') String token,
    @Path('id') String recommendationId,
    @Body() RecommendationFeedback feedback,
  );

  // Custom Itinerary Generation
  @POST('/ai/itinerary/generate')
  Future<AIItineraryModel> generateItinerary(
    @Header('Authorization') String token,
    @Body() ItineraryGenerationRequest request,
  );

  @PUT('/ai/itinerary/{id}/modify')
  Future<AIItineraryModel> modifyItinerary(
    @Header('Authorization') String token,
    @Path('id') String itineraryId,
    @Body() ItineraryModificationRequest request,
  );

  @GET('/ai/itinerary/{id}')
  Future<AIItineraryModel> getItinerary(
    @Header('Authorization') String token,
    @Path('id') String itineraryId,
  );

  @GET('/ai/itinerary')
  Future<List<AIItineraryModel>> getUserItineraries(
    @Header('Authorization') String token,
    @Queries() ItineraryQuery query,
  );

  // Conversational AI (Chatbot)
  @POST('/ai/chat/sessions')
  Future<ChatSession> createChatSession(@Header('Authorization') String token);

  @POST('/ai/chat/sessions/{sessionId}/messages')
  Future<ChatResponse> sendMessage(
    @Header('Authorization') String token,
    @Path('sessionId') String sessionId,
    @Body() ChatMessage message,
  );

  @GET('/ai/chat/sessions/{sessionId}/messages')
  Future<List<ChatMessage>> getChatHistory(
    @Header('Authorization') String token,
    @Path('sessionId') String sessionId,
    @Queries() ChatHistoryQuery query,
  );

  @DELETE('/ai/chat/sessions/{sessionId}')
  Future<void> deleteChatSession(
    @Header('Authorization') String token,
    @Path('sessionId') String sessionId,
  );

  // Smart Search and Query Processing
  @POST('/ai/search/smart')
  Future<SmartSearchResponse> smartSearch(@Body() SmartSearchRequest request);

  @POST('/ai/search/autocomplete')
  Future<AutocompleteResponse> getAutocomplete(@Body() AutocompleteRequest request);

  @POST('/ai/search/intent')
  Future<SearchIntentResponse> analyzeSearchIntent(@Body() SearchIntentRequest request);

  // Image Recognition and Analysis
  @POST('/ai/image/analyze')
  Future<ImageAnalysisResponse> analyzeImage(
    @Header('Authorization') String token,
    @Body() ImageAnalysisRequest request,
  );

  @POST('/ai/image/destinations')
  Future<DestinationRecognitionResponse> recognizeDestination(
    @Body() DestinationRecognitionRequest request,
  );

  // Sentiment Analysis and Review Processing
  @POST('/ai/sentiment/analyze')
  Future<SentimentAnalysisResponse> analyzeSentiment(@Body() SentimentAnalysisRequest request);

  @POST('/ai/reviews/summarize')
  Future<ReviewSummaryResponse> summarizeReviews(@Body() ReviewSummaryRequest request);

  // Personalization and User Profiling
  @GET('/ai/profile/preferences')
  Future<UserPreferenceProfile> getUserPreferences(@Header('Authorization') String token);

  @PUT('/ai/profile/preferences')
  Future<UserPreferenceProfile> updateUserPreferences(
    @Header('Authorization') String token,
    @Body() UpdatePreferencesRequest request,
  );

  @POST('/ai/profile/learn')
  Future<void> recordUserBehavior(
    @Header('Authorization') String token,
    @Body() UserBehaviorEvent event,
  );

  // Price Prediction and Optimization
  @POST('/ai/pricing/predict')
  Future<PricePredictionResponse> predictPricing(@Body() PricePredictionRequest request);

  @POST('/ai/pricing/optimize')
  Future<PriceOptimizationResponse> optimizePricing(
    @Header('Authorization') String token,
    @Body() PriceOptimizationRequest request,
  );

  // Travel Trend Analysis
  @GET('/ai/trends/destinations')
  Future<TrendAnalysisResponse> getDestinationTrends(@Queries() TrendQuery query);

  @GET('/ai/trends/activities')
  Future<TrendAnalysisResponse> getActivityTrends(@Queries() TrendQuery query);

  @GET('/ai/trends/seasonal')
  Future<SeasonalTrendResponse> getSeasonalTrends(@Queries() SeasonalTrendQuery query);
}

// Request Models
@JsonSerializable()
class RecommendationRequest {
  final List<String>? interests;
  final String? destination;
  final double? budget;
  final String? budgetCurrency;
  final DateTime? travelStartDate;
  final DateTime? travelEndDate;
  final int? travelers;
  final String? travelStyle;
  final List<String>? previousDestinations;
  final String? occasion;
  final Map<String, dynamic>? context;

  const RecommendationRequest({
    this.interests,
    this.destination,
    this.budget,
    this.budgetCurrency,
    this.travelStartDate,
    this.travelEndDate,
    this.travelers,
    this.travelStyle,
    this.previousDestinations,
    this.occasion,
    this.context,
  });

  factory RecommendationRequest.fromJson(Map<String, dynamic> json) => _$RecommendationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationRequestToJson(this);
}

@JsonSerializable()
class RecommendationQuery {
  final RecommendationType? type;
  final int? limit;
  final double? minConfidence;
  final bool? includeViewed;
  final String? sortBy;

  const RecommendationQuery({
    this.type,
    this.limit,
    this.minConfidence,
    this.includeViewed,
    this.sortBy,
  });

  Map<String, dynamic> toJson() => _$RecommendationQueryToJson(this);
}

@JsonSerializable()
class RecommendationFeedback {
  final bool isLiked;
  final bool isBookmarked;
  final bool isBooked;
  final double? rating;
  final String? comment;

  const RecommendationFeedback({
    required this.isLiked,
    required this.isBookmarked,
    required this.isBooked,
    this.rating,
    this.comment,
  });

  factory RecommendationFeedback.fromJson(Map<String, dynamic> json) => _$RecommendationFeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationFeedbackToJson(this);
}

@JsonSerializable()
class ItineraryGenerationRequest {
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String budgetCurrency;
  final List<String> interests;
  final String travelStyle;
  final int travelers;
  final String? accommodationType;
  final List<String>? dietaryRestrictions;
  final String? accessibility;
  final List<String>? mustVisit;
  final List<String>? avoid;

  const ItineraryGenerationRequest({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.budgetCurrency,
    required this.interests,
    required this.travelStyle,
    required this.travelers,
    this.accommodationType,
    this.dietaryRestrictions,
    this.accessibility,
    this.mustVisit,
    this.avoid,
  });

  factory ItineraryGenerationRequest.fromJson(Map<String, dynamic> json) => _$ItineraryGenerationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryGenerationRequestToJson(this);
}

@JsonSerializable()
class ItineraryModificationRequest {
  final int? dayNumber;
  final String? modificationType; // 'add_activity', 'remove_activity', 'change_activity', 'adjust_timing'
  final Map<String, dynamic> modifications;
  final String? reason;

  const ItineraryModificationRequest({
    this.dayNumber,
    this.modificationType,
    required this.modifications,
    this.reason,
  });

  factory ItineraryModificationRequest.fromJson(Map<String, dynamic> json) => _$ItineraryModificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryModificationRequestToJson(this);
}

@JsonSerializable()
class ItineraryQuery {
  final String? destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final String? sortBy;

  const ItineraryQuery({
    this.destination,
    this.startDate,
    this.endDate,
    this.limit,
    this.sortBy,
  });

  Map<String, dynamic> toJson() => _$ItineraryQueryToJson(this);
}

@JsonSerializable()
class ChatMessage {
  final String? id;
  final String message;
  final String? messageType; // 'text', 'image', 'location', 'booking_inquiry'
  final DateTime? timestamp;
  final String? sender; // 'user' or 'ai'
  final Map<String, dynamic>? metadata;

  const ChatMessage({
    this.id,
    required this.message,
    this.messageType,
    this.timestamp,
    this.sender,
    this.metadata,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

@JsonSerializable()
class ChatHistoryQuery {
  final int? limit;
  final DateTime? before;
  final DateTime? after;

  const ChatHistoryQuery({
    this.limit,
    this.before,
    this.after,
  });

  Map<String, dynamic> toJson() => _$ChatHistoryQueryToJson(this);
}

@JsonSerializable()
class SmartSearchRequest {
  final String query;
  final String? context;
  final Map<String, dynamic>? filters;
  final String? userId;

  const SmartSearchRequest({
    required this.query,
    this.context,
    this.filters,
    this.userId,
  });

  factory SmartSearchRequest.fromJson(Map<String, dynamic> json) => _$SmartSearchRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SmartSearchRequestToJson(this);
}

@JsonSerializable()
class AutocompleteRequest {
  final String query;
  final String? type; // 'destination', 'activity', 'hotel'
  final int? limit;

  const AutocompleteRequest({
    required this.query,
    this.type,
    this.limit,
  });

  factory AutocompleteRequest.fromJson(Map<String, dynamic> json) => _$AutocompleteRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AutocompleteRequestToJson(this);
}

@JsonSerializable()
class SearchIntentRequest {
  final String query;
  final String? context;

  const SearchIntentRequest({
    required this.query,
    this.context,
  });

  factory SearchIntentRequest.fromJson(Map<String, dynamic> json) => _$SearchIntentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SearchIntentRequestToJson(this);
}

@JsonSerializable()
class ImageAnalysisRequest {
  final String imageUrl;
  final String? analysisType; // 'destination', 'landmark', 'activity', 'food'

  const ImageAnalysisRequest({
    required this.imageUrl,
    this.analysisType,
  });

  factory ImageAnalysisRequest.fromJson(Map<String, dynamic> json) => _$ImageAnalysisRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ImageAnalysisRequestToJson(this);
}

@JsonSerializable()
class DestinationRecognitionRequest {
  final String imageUrl;

  const DestinationRecognitionRequest({required this.imageUrl});

  factory DestinationRecognitionRequest.fromJson(Map<String, dynamic> json) => _$DestinationRecognitionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DestinationRecognitionRequestToJson(this);
}

// Response Models
@JsonSerializable()
class RecommendationResponse {
  final List<AIRecommendationModel> recommendations;
  final String? explanation;
  final double confidence;
  final Map<String, dynamic>? metadata;

  const RecommendationResponse({
    required this.recommendations,
    this.explanation,
    required this.confidence,
    this.metadata,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) => _$RecommendationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationResponseToJson(this);
}

@JsonSerializable()
class ChatSession {
  final String sessionId;
  final DateTime createdAt;
  final DateTime expiresAt;

  const ChatSession({
    required this.sessionId,
    required this.createdAt,
    required this.expiresAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => _$ChatSessionFromJson(json);
  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);
}

@JsonSerializable()
class ChatResponse {
  final ChatMessage message;
  final List<QuickReply>? quickReplies;
  final List<ActionSuggestion>? suggestions;
  final double confidence;

  const ChatResponse({
    required this.message,
    this.quickReplies,
    this.suggestions,
    required this.confidence,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => _$ChatResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);
}

@JsonSerializable()
class QuickReply {
  final String text;
  final String value;
  final String? type;

  const QuickReply({
    required this.text,
    required this.value,
    this.type,
  });

  factory QuickReply.fromJson(Map<String, dynamic> json) => _$QuickReplyFromJson(json);
  Map<String, dynamic> toJson() => _$QuickReplyToJson(this);
}

@JsonSerializable()
class ActionSuggestion {
  final String action;
  final String title;
  final String description;
  final Map<String, dynamic>? parameters;

  const ActionSuggestion({
    required this.action,
    required this.title,
    required this.description,
    this.parameters,
  });

  factory ActionSuggestion.fromJson(Map<String, dynamic> json) => _$ActionSuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$ActionSuggestionToJson(this);
}

@JsonSerializable()
class SmartSearchResponse {
  final List<SearchResult> results;
  final SearchIntent intent;
  final List<SearchSuggestion>? suggestions;
  final int totalCount;

  const SmartSearchResponse({
    required this.results,
    required this.intent,
    this.suggestions,
    required this.totalCount,
  });

  factory SmartSearchResponse.fromJson(Map<String, dynamic> json) => _$SmartSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SmartSearchResponseToJson(this);
}

@JsonSerializable()
class SearchResult {
  final String id;
  final String type;
  final String title;
  final String description;
  final String? imageUrl;
  final double relevanceScore;
  final Map<String, dynamic> data;

  const SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.relevanceScore,
    required this.data,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

@JsonSerializable()
class SearchIntent {
  final String primaryIntent;
  final List<String> secondaryIntents;
  final Map<String, dynamic> extractedEntities;
  final double confidence;

  const SearchIntent({
    required this.primaryIntent,
    required this.secondaryIntents,
    required this.extractedEntities,
    required this.confidence,
  });

  factory SearchIntent.fromJson(Map<String, dynamic> json) => _$SearchIntentFromJson(json);
  Map<String, dynamic> toJson() => _$SearchIntentToJson(this);
}

@JsonSerializable()
class SearchSuggestion {
  final String suggestion;
  final String type;
  final double relevanceScore;

  const SearchSuggestion({
    required this.suggestion,
    required this.type,
    required this.relevanceScore,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) => _$SearchSuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$SearchSuggestionToJson(this);
}

@JsonSerializable()
class AutocompleteResponse {
  final List<AutocompleteSuggestion> suggestions;

  const AutocompleteResponse({required this.suggestions});

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) => _$AutocompleteResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AutocompleteResponseToJson(this);
}

@JsonSerializable()
class AutocompleteSuggestion {
  final String text;
  final String value;
  final String type;
  final double score;
  final String? description;

  const AutocompleteSuggestion({
    required this.text,
    required this.value,
    required this.type,
    required this.score,
    this.description,
  });

  factory AutocompleteSuggestion.fromJson(Map<String, dynamic> json) => _$AutocompleteSuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$AutocompleteSuggestionToJson(this);
}

@JsonSerializable()
class SearchIntentResponse {
  final SearchIntent intent;
  final List<String> suggestedQueries;

  const SearchIntentResponse({
    required this.intent,
    required this.suggestedQueries,
  });

  factory SearchIntentResponse.fromJson(Map<String, dynamic> json) => _$SearchIntentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchIntentResponseToJson(this);
}

@JsonSerializable()
class ImageAnalysisResponse {
  final List<RecognizedObject> objects;
  final List<String> landmarks;
  final List<String> activities;
  final String? primaryDestination;
  final double confidence;
  final Map<String, dynamic>? metadata;

  const ImageAnalysisResponse({
    required this.objects,
    required this.landmarks,
    required this.activities,
    this.primaryDestination,
    required this.confidence,
    this.metadata,
  });

  factory ImageAnalysisResponse.fromJson(Map<String, dynamic> json) => _$ImageAnalysisResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ImageAnalysisResponseToJson(this);
}

@JsonSerializable()
class RecognizedObject {
  final String name;
  final double confidence;
  final String category;
  final Map<String, double>? boundingBox;

  const RecognizedObject({
    required this.name,
    required this.confidence,
    required this.category,
    this.boundingBox,
  });

  factory RecognizedObject.fromJson(Map<String, dynamic> json) => _$RecognizedObjectFromJson(json);
  Map<String, dynamic> toJson() => _$RecognizedObjectToJson(this);
}

@JsonSerializable()
class DestinationRecognitionResponse {
  final List<RecognizedDestination> destinations;
  final double confidence;

  const DestinationRecognitionResponse({
    required this.destinations,
    required this.confidence,
  });

  factory DestinationRecognitionResponse.fromJson(Map<String, dynamic> json) => _$DestinationRecognitionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DestinationRecognitionResponseToJson(this);
}

@JsonSerializable()
class RecognizedDestination {
  final String name;
  final String country;
  final String? city;
  final double confidence;
  final Map<String, dynamic>? additionalInfo;

  const RecognizedDestination({
    required this.name,
    required this.country,
    this.city,
    required this.confidence,
    this.additionalInfo,
  });

  factory RecognizedDestination.fromJson(Map<String, dynamic> json) => _$RecognizedDestinationFromJson(json);
  Map<String, dynamic> toJson() => _$RecognizedDestinationToJson(this);
}

// Additional Request/Response Models for remaining endpoints would follow the same pattern...

@JsonSerializable()
class SentimentAnalysisRequest {
  final List<String> texts;
  final String? language;

  const SentimentAnalysisRequest({
    required this.texts,
    this.language,
  });

  factory SentimentAnalysisRequest.fromJson(Map<String, dynamic> json) => _$SentimentAnalysisRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SentimentAnalysisRequestToJson(this);
}

@JsonSerializable()
class SentimentAnalysisResponse {
  final List<SentimentResult> results;
  final SentimentSummary summary;

  const SentimentAnalysisResponse({
    required this.results,
    required this.summary,
  });

  factory SentimentAnalysisResponse.fromJson(Map<String, dynamic> json) => _$SentimentAnalysisResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SentimentAnalysisResponseToJson(this);
}

@JsonSerializable()
class SentimentResult {
  final String text;
  final String sentiment; // 'positive', 'negative', 'neutral'
  final double confidence;
  final Map<String, double> emotions;

  const SentimentResult({
    required this.text,
    required this.sentiment,
    required this.confidence,
    required this.emotions,
  });

  factory SentimentResult.fromJson(Map<String, dynamic> json) => _$SentimentResultFromJson(json);
  Map<String, dynamic> toJson() => _$SentimentResultToJson(this);
}

@JsonSerializable()
class SentimentSummary {
  final double overallScore;
  final String overallSentiment;
  final Map<String, int> sentimentDistribution;
  final List<String> keyThemes;

  const SentimentSummary({
    required this.overallScore,
    required this.overallSentiment,
    required this.sentimentDistribution,
    required this.keyThemes,
  });

  factory SentimentSummary.fromJson(Map<String, dynamic> json) => _$SentimentSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SentimentSummaryToJson(this);
}

@JsonSerializable()
class ReviewSummaryRequest {
  final String itemId;
  final String itemType;
  final int? maxReviews;

  const ReviewSummaryRequest({
    required this.itemId,
    required this.itemType,
    this.maxReviews,
  });

  factory ReviewSummaryRequest.fromJson(Map<String, dynamic> json) => _$ReviewSummaryRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewSummaryRequestToJson(this);
}

@JsonSerializable()
class ReviewSummaryResponse {
  final String summary;
  final List<String> pros;
  final List<String> cons;
  final List<String> keyTopics;
  final SentimentSummary sentimentSummary;
  final int totalReviewsAnalyzed;

  const ReviewSummaryResponse({
    required this.summary,
    required this.pros,
    required this.cons,
    required this.keyTopics,
    required this.sentimentSummary,
    required this.totalReviewsAnalyzed,
  });

  factory ReviewSummaryResponse.fromJson(Map<String, dynamic> json) => _$ReviewSummaryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewSummaryResponseToJson(this);
}

@JsonSerializable()
class UserPreferenceProfile {
  final String userId;
  final Map<String, double> interestWeights;
  final Map<String, String> preferences;
  final List<String> favoriteDestinations;
  final String travelStyle;
  final String budgetRange;
  final DateTime lastUpdated;

  const UserPreferenceProfile({
    required this.userId,
    required this.interestWeights,
    required this.preferences,
    required this.favoriteDestinations,
    required this.travelStyle,
    required this.budgetRange,
    required this.lastUpdated,
  });

  factory UserPreferenceProfile.fromJson(Map<String, dynamic> json) => _$UserPreferenceProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferenceProfileToJson(this);
}

@JsonSerializable()
class UpdatePreferencesRequest {
  final Map<String, double>? interestWeights;
  final Map<String, String>? preferences;
  final List<String>? favoriteDestinations;
  final String? travelStyle;
  final String? budgetRange;

  const UpdatePreferencesRequest({
    this.interestWeights,
    this.preferences,
    this.favoriteDestinations,
    this.travelStyle,
    this.budgetRange,
  });

  factory UpdatePreferencesRequest.fromJson(Map<String, dynamic> json) => _$UpdatePreferencesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePreferencesRequestToJson(this);
}

@JsonSerializable()
class UserBehaviorEvent {
  final String eventType;
  final String itemId;
  final String itemType;
  final Map<String, dynamic> eventData;
  final DateTime timestamp;

  const UserBehaviorEvent({
    required this.eventType,
    required this.itemId,
    required this.itemType,
    required this.eventData,
    required this.timestamp,
  });

  factory UserBehaviorEvent.fromJson(Map<String, dynamic> json) => _$UserBehaviorEventFromJson(json);
  Map<String, dynamic> toJson() => _$UserBehaviorEventToJson(this);
}

@JsonSerializable()
class PricePredictionRequest {
  final String itemId;
  final String itemType;
  final DateTime? targetDate;
  final int? daysAhead;

  const PricePredictionRequest({
    required this.itemId,
    required this.itemType,
    this.targetDate,
    this.daysAhead,
  });

  factory PricePredictionRequest.fromJson(Map<String, dynamic> json) => _$PricePredictionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PricePredictionRequestToJson(this);
}

@JsonSerializable()
class PricePredictionResponse {
  final String itemId;
  final double currentPrice;
  final double predictedPrice;
  final String currency;
  final double confidence;
  final String trend; // 'up', 'down', 'stable'
  final String recommendation;
  final DateTime predictionDate;

  const PricePredictionResponse({
    required this.itemId,
    required this.currentPrice,
    required this.predictedPrice,
    required this.currency,
    required this.confidence,
    required this.trend,
    required this.recommendation,
    required this.predictionDate,
  });

  factory PricePredictionResponse.fromJson(Map<String, dynamic> json) => _$PricePredictionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PricePredictionResponseToJson(this);
}

@JsonSerializable()
class PriceOptimizationRequest {
  final List<String> itemIds;
  final String itemType;
  final double budget;
  final String currency;
  final DateTime? travelDate;

  const PriceOptimizationRequest({
    required this.itemIds,
    required this.itemType,
    required this.budget,
    required this.currency,
    this.travelDate,
  });

  factory PriceOptimizationRequest.fromJson(Map<String, dynamic> json) => _$PriceOptimizationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PriceOptimizationRequestToJson(this);
}

@JsonSerializable()
class PriceOptimizationResponse {
  final List<OptimizedItem> recommendations;
  final double totalSavings;
  final String currency;
  final String strategy;

  const PriceOptimizationResponse({
    required this.recommendations,
    required this.totalSavings,
    required this.currency,
    required this.strategy,
  });

  factory PriceOptimizationResponse.fromJson(Map<String, dynamic> json) => _$PriceOptimizationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PriceOptimizationResponseToJson(this);
}

@JsonSerializable()
class OptimizedItem {
  final String itemId;
  final double originalPrice;
  final double optimizedPrice;
  final double savings;
  final String reason;

  const OptimizedItem({
    required this.itemId,
    required this.originalPrice,
    required this.optimizedPrice,
    required this.savings,
    required this.reason,
  });

  factory OptimizedItem.fromJson(Map<String, dynamic> json) => _$OptimizedItemFromJson(json);
  Map<String, dynamic> toJson() => _$OptimizedItemToJson(this);
}

@JsonSerializable()
class TrendQuery {
  final String? timeframe; // 'week', 'month', 'quarter', 'year'
  final String? region;
  final int? limit;

  const TrendQuery({
    this.timeframe,
    this.region,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$TrendQueryToJson(this);
}

@JsonSerializable()
class TrendAnalysisResponse {
  final List<TrendItem> trends;
  final String timeframe;
  final DateTime generatedAt;

  const TrendAnalysisResponse({
    required this.trends,
    required this.timeframe,
    required this.generatedAt,
  });

  factory TrendAnalysisResponse.fromJson(Map<String, dynamic> json) => _$TrendAnalysisResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TrendAnalysisResponseToJson(this);
}

@JsonSerializable()
class TrendItem {
  final String name;
  final double trendScore;
  final String changeDirection; // 'up', 'down', 'stable'
  final double changePercentage;
  final List<String> reasons;

  const TrendItem({
    required this.name,
    required this.trendScore,
    required this.changeDirection,
    required this.changePercentage,
    required this.reasons,
  });

  factory TrendItem.fromJson(Map<String, dynamic> json) => _$TrendItemFromJson(json);
  Map<String, dynamic> toJson() => _$TrendItemToJson(this);
}

@JsonSerializable()
class SeasonalTrendQuery {
  final String season; // 'spring', 'summer', 'fall', 'winter'
  final String? region;
  final int? year;

  const SeasonalTrendQuery({
    required this.season,
    this.region,
    this.year,
  });

  Map<String, dynamic> toJson() => _$SeasonalTrendQueryToJson(this);
}

@JsonSerializable()
class SeasonalTrendResponse {
  final String season;
  final List<SeasonalTrend> trends;
  final List<String> recommendations;
  final DateTime generatedAt;

  const SeasonalTrendResponse({
    required this.season,
    required this.trends,
    required this.recommendations,
    required this.generatedAt,
  });

  factory SeasonalTrendResponse.fromJson(Map<String, dynamic> json) => _$SeasonalTrendResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonalTrendResponseToJson(this);
}

@JsonSerializable()
class SeasonalTrend {
  final String destination;
  final double popularityScore;
  final double priceIndex;
  final String weatherCondition;
  final List<String> activities;

  const SeasonalTrend({
    required this.destination,
    required this.popularityScore,
    required this.priceIndex,
    required this.weatherCondition,
    required this.activities,
  });

  factory SeasonalTrend.fromJson(Map<String, dynamic> json) => _$SeasonalTrendFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonalTrendToJson(this);
}