import 'package:json_annotation/json_annotation.dart';

part 'ai_recommendation_model.g.dart';

enum RecommendationType { destination, package, activity, restaurant, hotel }
enum ConfidenceLevel { low, medium, high, veryHigh }
enum PreferenceCategory { budget, activity, accommodation, cuisine, climate, culture }

@JsonSerializable()
class AIRecommendationModel {
  final String id;
  final String userId;
  final RecommendationType type;
  final String title;
  final String description;
  final double confidence;
  final ConfidenceLevel confidenceLevel;
  
  // Recommendation Details
  final RecommendationContent content;
  final List<String> reasons;
  final List<String> tags;
  final double? rating;
  final String? imageUrl;
  
  // User Context
  final UserContext userContext;
  final List<UserPreference> matchedPreferences;
  
  // AI Model Information
  final ModelInfo modelInfo;
  final Map<String, dynamic> additionalData;
  
  // Interaction Tracking
  final bool isViewed;
  final bool isLiked;
  final bool isBookmarked;
  final bool isBooked;
  final DateTime? viewedAt;
  final DateTime? interactedAt;
  
  // Timestamps
  final DateTime generatedAt;
  final DateTime expiresAt;

  const AIRecommendationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
    required this.confidenceLevel,
    required this.content,
    required this.reasons,
    required this.tags,
    this.rating,
    this.imageUrl,
    required this.userContext,
    required this.matchedPreferences,
    required this.modelInfo,
    required this.additionalData,
    required this.isViewed,
    required this.isLiked,
    required this.isBookmarked,
    required this.isBooked,
    this.viewedAt,
    this.interactedAt,
    required this.generatedAt,
    required this.expiresAt,
  });

  factory AIRecommendationModel.fromJson(Map<String, dynamic> json) => _$AIRecommendationModelFromJson(json);
  Map<String, dynamic> toJson() => _$AIRecommendationModelToJson(this);
}

@JsonSerializable()
class RecommendationContent {
  final String? packageId;
  final String? destinationId;
  final String? hotelId;
  final String? activityId;
  final String? restaurantId;
  
  // Pricing Information
  final PriceRange? priceRange;
  final String? currency;
  final bool? hasDiscount;
  final double? originalPrice;
  final double? discountedPrice;
  
  // Location Information
  final LocationInfo? location;
  
  // Additional Details
  final String? duration;
  final List<String>? highlights;
  final List<String>? inclusions;
  final Map<String, dynamic>? customData;

  const RecommendationContent({
    this.packageId,
    this.destinationId,
    this.hotelId,
    this.activityId,
    this.restaurantId,
    this.priceRange,
    this.currency,
    this.hasDiscount,
    this.originalPrice,
    this.discountedPrice,
    this.location,
    this.duration,
    this.highlights,
    this.inclusions,
    this.customData,
  });

  factory RecommendationContent.fromJson(Map<String, dynamic> json) => _$RecommendationContentFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationContentToJson(this);
}

@JsonSerializable()
class PriceRange {
  final double min;
  final double max;
  final String category; // 'budget', 'mid-range', 'luxury'

  const PriceRange({
    required this.min,
    required this.max,
    required this.category,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) => _$PriceRangeFromJson(json);
  Map<String, dynamic> toJson() => _$PriceRangeToJson(this);
}

@JsonSerializable()
class LocationInfo {
  final String country;
  final String city;
  final String? region;
  final double? latitude;
  final double? longitude;
  final String? timezone;

  const LocationInfo({
    required this.country,
    required this.city,
    this.region,
    this.latitude,
    this.longitude,
    this.timezone,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => _$LocationInfoFromJson(json);
  Map<String, dynamic> toJson() => _$LocationInfoToJson(this);
}

@JsonSerializable()
class UserContext {
  final List<String> searchHistory;
  final List<String> bookingHistory;
  final List<String> viewedItems;
  final List<String> likedItems;
  final SeasonalContext? seasonalContext;
  final SocialContext? socialContext;
  final String? currentLocation;
  final DateTime contextTimestamp;

  const UserContext({
    required this.searchHistory,
    required this.bookingHistory,
    required this.viewedItems,
    required this.likedItems,
    this.seasonalContext,
    this.socialContext,
    this.currentLocation,
    required this.contextTimestamp,
  });

  factory UserContext.fromJson(Map<String, dynamic> json) => _$UserContextFromJson(json);
  Map<String, dynamic> toJson() => _$UserContextToJson(this);
}

@JsonSerializable()
class SeasonalContext {
  final String currentSeason;
  final List<String> seasonalPreferences;
  final String? weatherPreference;
  final List<String> seasonalActivities;

  const SeasonalContext({
    required this.currentSeason,
    required this.seasonalPreferences,
    this.weatherPreference,
    required this.seasonalActivities,
  });

  factory SeasonalContext.fromJson(Map<String, dynamic> json) => _$SeasonalContextFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonalContextToJson(this);
}

@JsonSerializable()
class SocialContext {
  final String travelCompanion; // 'solo', 'couple', 'family', 'friends', 'business'
  final int? groupSize;
  final List<String>? groupPreferences;
  final String? occasion; // 'vacation', 'business', 'honeymoon', 'anniversary'

  const SocialContext({
    required this.travelCompanion,
    this.groupSize,
    this.groupPreferences,
    this.occasion,
  });

  factory SocialContext.fromJson(Map<String, dynamic> json) => _$SocialContextFromJson(json);
  Map<String, dynamic> toJson() => _$SocialContextToJson(this);
}

@JsonSerializable()
class UserPreference {
  final String id;
  final PreferenceCategory category;
  final String name;
  final double weight;
  final String value;
  final double matchScore;
  final String? reason;

  const UserPreference({
    required this.id,
    required this.category,
    required this.name,
    required this.weight,
    required this.value,
    required this.matchScore,
    this.reason,
  });

  factory UserPreference.fromJson(Map<String, dynamic> json) => _$UserPreferenceFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferenceToJson(this);
}

@JsonSerializable()
class ModelInfo {
  final String modelName;
  final String modelVersion;
  final String algorithm;
  final double accuracy;
  final DateTime trainedAt;
  final Map<String, dynamic> hyperparameters;
  final List<String> features;

  const ModelInfo({
    required this.modelName,
    required this.modelVersion,
    required this.algorithm,
    required this.accuracy,
    required this.trainedAt,
    required this.hyperparameters,
    required this.features,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) => _$ModelInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ModelInfoToJson(this);
}

@JsonSerializable()
class AIItineraryModel {
  final String id;
  final String userId;
  final String title;
  final String destination;
  final int durationDays;
  final List<ItineraryDay> days;
  final ItineraryPreferences preferences;
  final double confidence;
  final List<String> reasons;
  final DateTime generatedAt;
  final DateTime? modifiedAt;

  const AIItineraryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.destination,
    required this.durationDays,
    required this.days,
    required this.preferences,
    required this.confidence,
    required this.reasons,
    required this.generatedAt,
    this.modifiedAt,
  });

  factory AIItineraryModel.fromJson(Map<String, dynamic> json) => _$AIItineraryModelFromJson(json);
  Map<String, dynamic> toJson() => _$AIItineraryModelToJson(this);
}

@JsonSerializable()
class ItineraryDay {
  final int dayNumber;
  final String theme;
  final List<ItineraryActivity> activities;
  final String? accommodation;
  final List<String>? meals;
  final String? notes;
  final double estimatedCost;

  const ItineraryDay({
    required this.dayNumber,
    required this.theme,
    required this.activities,
    this.accommodation,
    this.meals,
    this.notes,
    required this.estimatedCost,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> json) => _$ItineraryDayFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryDayToJson(this);
}

@JsonSerializable()
class ItineraryActivity {
  final String name;
  final String description;
  final String type;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final double? cost;
  final double? rating;
  final List<String>? tags;

  const ItineraryActivity({
    required this.name,
    required this.description,
    required this.type,
    this.location,
    required this.startTime,
    required this.endTime,
    this.cost,
    this.rating,
    this.tags,
  });

  factory ItineraryActivity.fromJson(Map<String, dynamic> json) => _$ItineraryActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryActivityToJson(this);
}

@JsonSerializable()
class ItineraryPreferences {
  final double budget;
  final String budgetCategory;
  final List<String> interests;
  final String pace; // 'relaxed', 'moderate', 'fast'
  final String accommodationType;
  final List<String> dietaryRestrictions;
  final bool includeTransport;

  const ItineraryPreferences({
    required this.budget,
    required this.budgetCategory,
    required this.interests,
    required this.pace,
    required this.accommodationType,
    required this.dietaryRestrictions,
    required this.includeTransport,
  });

  factory ItineraryPreferences.fromJson(Map<String, dynamic> json) => _$ItineraryPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryPreferencesToJson(this);
}