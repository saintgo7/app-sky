import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/ai_models.dart';
import 'base_api_client.dart';

part 'ai_api_service.g.dart';

@RestApi()
abstract class AiApiService {
  factory AiApiService(Dio dio, {String baseUrl}) = _AiApiService;

  static AiApiService create() {
    return AiApiService(BaseApiClient().dio);
  }

  // Chat
  @POST('/ai/chat')
  Future<ChatResponse> sendMessage(
    @Header('Authorization') String token,
    @Body() ChatRequest request,
  );

  @GET('/ai/chat/history')
  Future<ChatHistoryResponse> getChatHistory({
    @Header('Authorization') String token,
    @Query('limit') int limit = 50,
    @Query('offset') int offset = 0,
  });

  @DELETE('/ai/chat/{sessionId}')
  Future<ApiResponse> clearChatHistory(
    @Header('Authorization') String token,
    @Path('sessionId') String sessionId,
  );

  // Travel Recommendations
  @POST('/ai/recommend')
  Future<RecommendationResponse> getRecommendations(
    @Header('Authorization') String token,
    @Body() RecommendationRequest request,
  );

  @GET('/ai/recommend/personalized')
  Future<PersonalizedRecommendationResponse> getPersonalizedRecommendations({
    @Header('Authorization') String token,
    @Query('user_id') String userId,
    @Query('limit') int limit = 10,
  });

  // Trip Planning
  @POST('/ai/plan-trip')
  Future<TripPlanResponse> createTripPlan(
    @Header('Authorization') String token,
    @Body() TripPlanRequest request,
  );

  @GET('/ai/plans')
  Future<TripPlanListResponse> getTripPlans({
    @Header('Authorization') String token,
    @Query('status') String? status,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
  });

  @GET('/ai/plans/{id}')
  Future<TripPlanDetailResponse> getTripPlan(
    @Header('Authorization') String token,
    @Path('id') String id,
  );

  @PUT('/ai/plans/{id}')
  Future<TripPlanResponse> updateTripPlan(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() UpdateTripPlanRequest request,
  );

  @DELETE('/ai/plans/{id}')
  Future<ApiResponse> deleteTripPlan(
    @Header('Authorization') String token,
    @Path('id') String id,
  );

  // Itinerary Generation
  @POST('/ai/itinerary')
  Future<ItineraryResponse> generateItinerary(
    @Header('Authorization') String token,
    @Body() ItineraryRequest request,
  );

  @GET('/ai/itineraries')
  Future<ItineraryListResponse> getItineraries({
    @Header('Authorization') String token,
    @Query('trip_plan_id') String? tripPlanId,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
  });

  @PUT('/ai/itineraries/{id}')
  Future<ItineraryResponse> updateItinerary(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() UpdateItineraryRequest request,
  );

  // Budget Analysis
  @POST('/ai/budget/analyze')
  Future<BudgetAnalysisResponse> analyzeBudget(
    @Header('Authorization') String token,
    @Body() BudgetAnalysisRequest request,
  );

  @POST('/ai/budget/optimize')
  Future<BudgetOptimizationResponse> optimizeBudget(
    @Header('Authorization') String token,
    @Body() BudgetOptimizationRequest request,
  );

  // Weather and Conditions
  @GET('/ai/weather')
  Future<WeatherResponse> getWeatherForecast({
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
    @Query('days') int days = 7,
  });

  @GET('/ai/conditions')
  Future<TravelConditionsResponse> getTravelConditions({
    @Query('destination') String destination,
    @Query('season') String? season,
  });

  // Language Translation
  @POST('/ai/translate')
  Future<TranslationResponse> translateText(
    @Body() TranslationRequest request,
  );

  // Image Analysis (for OCR, landmark recognition)
  @POST('/ai/analyze-image')
  @MultiPart()
  Future<ImageAnalysisResponse> analyzeImage(
    @Part(name: 'image') MultipartFile file,
    @Part(name: 'type') String type, // 'ocr', 'landmark', 'text'
  );
}

// Request Models
class ChatRequest {
  final String message;
  final String? sessionId;
  final Map<String, dynamic>? context;

  ChatRequest({
    required this.message,
    this.sessionId,
    this.context,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    if (sessionId != null) 'session_id': sessionId,
    if (context != null) 'context': context,
  };
}

class RecommendationRequest {
  final String query;
  final String? userId;
  final Map<String, dynamic>? preferences;
  final int limit;

  RecommendationRequest({
    required this.query,
    this.userId,
    this.preferences,
    this.limit = 10,
  });

  Map<String, dynamic> toJson() => {
    'query': query,
    if (userId != null) 'user_id': userId,
    if (preferences != null) 'preferences': preferences,
    'limit': limit,
  };
}

class TripPlanRequest {
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final double budget;
  final String currency;
  final List<String> interests;
  final List<String> preferences;
  final String? userId;

  TripPlanRequest({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    required this.budget,
    required this.currency,
    required this.interests,
    required this.preferences,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
    'destination': destination,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'travelers': travelers,
    'budget': budget,
    'currency': currency,
    'interests': interests,
    'preferences': preferences,
    if (userId != null) 'user_id': userId,
  };
}

class UpdateTripPlanRequest {
  final String? destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? travelers;
  final double? budget;
  final List<String>? interests;
  final List<String>? preferences;

  UpdateTripPlanRequest({
    this.destination,
    this.startDate,
    this.endDate,
    this.travelers,
    this.budget,
    this.interests,
    this.preferences,
  });

  Map<String, dynamic> toJson() => {
    if (destination != null) 'destination': destination,
    if (startDate != null) 'start_date': startDate!.toIso8601String(),
    if (endDate != null) 'end_date': endDate!.toIso8601String(),
    if (travelers != null) 'travelers': travelers,
    if (budget != null) 'budget': budget,
    if (interests != null) 'interests': interests,
    if (preferences != null) 'preferences': preferences,
  };
}

class ItineraryRequest {
  final String tripPlanId;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> activities;
  final Map<String, dynamic>? preferences;

  ItineraryRequest({
    required this.tripPlanId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.activities,
    this.preferences,
  });

  Map<String, dynamic> toJson() => {
    'trip_plan_id': tripPlanId,
    'destination': destination,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'activities': activities,
    if (preferences != null) 'preferences': preferences,
  };
}

class UpdateItineraryRequest {
  final List<String>? activities;
  final Map<String, dynamic>? preferences;

  UpdateItineraryRequest({
    this.activities,
    this.preferences,
  });

  Map<String, dynamic> toJson() => {
    if (activities != null) 'activities': activities,
    if (preferences != null) 'preferences': preferences,
  };
}

class BudgetAnalysisRequest {
  final double totalBudget;
  final String currency;
  final int duration;
  final int travelers;
  final String destination;
  final List<String> plannedActivities;

  BudgetAnalysisRequest({
    required this.totalBudget,
    required this.currency,
    required this.duration,
    required this.travelers,
    required this.destination,
    required this.plannedActivities,
  });

  Map<String, dynamic> toJson() => {
    'total_budget': totalBudget,
    'currency': currency,
    'duration': duration,
    'travelers': travelers,
    'destination': destination,
    'planned_activities': plannedActivities,
  };
}

class BudgetOptimizationRequest {
  final double currentBudget;
  final String currency;
  final int duration;
  final int travelers;
  final String destination;
  final List<String> mustHaveActivities;
  final List<String> optionalActivities;

  BudgetOptimizationRequest({
    required this.currentBudget,
    required this.currency,
    required this.duration,
    required this.travelers,
    required this.destination,
    required this.mustHaveActivities,
    required this.optionalActivities,
  });

  Map<String, dynamic> toJson() => {
    'current_budget': currentBudget,
    'currency': currency,
    'duration': duration,
    'travelers': travelers,
    'destination': destination,
    'must_have_activities': mustHaveActivities,
    'optional_activities': optionalActivities,
  };
}

class TranslationRequest {
  final String text;
  final String fromLanguage;
  final String toLanguage;

  TranslationRequest({
    required this.text,
    required this.fromLanguage,
    required this.toLanguage,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'from_language': fromLanguage,
    'to_language': toLanguage,
  };
}
