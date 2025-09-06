// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIRecommendationModel _$AIRecommendationModelFromJson(
        Map<String, dynamic> json) =>
    AIRecommendationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$RecommendationTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      confidenceLevel:
          $enumDecode(_$ConfidenceLevelEnumMap, json['confidenceLevel']),
      content: RecommendationContent.fromJson(
          json['content'] as Map<String, dynamic>),
      reasons:
          (json['reasons'] as List<dynamic>).map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      userContext:
          UserContext.fromJson(json['userContext'] as Map<String, dynamic>),
      matchedPreferences: (json['matchedPreferences'] as List<dynamic>)
          .map((e) => UserPreference.fromJson(e as Map<String, dynamic>))
          .toList(),
      modelInfo: ModelInfo.fromJson(json['modelInfo'] as Map<String, dynamic>),
      additionalData: json['additionalData'] as Map<String, dynamic>,
      isViewed: json['isViewed'] as bool,
      isLiked: json['isLiked'] as bool,
      isBookmarked: json['isBookmarked'] as bool,
      isBooked: json['isBooked'] as bool,
      viewedAt: json['viewedAt'] == null
          ? null
          : DateTime.parse(json['viewedAt'] as String),
      interactedAt: json['interactedAt'] == null
          ? null
          : DateTime.parse(json['interactedAt'] as String),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$AIRecommendationModelToJson(
        AIRecommendationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$RecommendationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'confidence': instance.confidence,
      'confidenceLevel': _$ConfidenceLevelEnumMap[instance.confidenceLevel]!,
      'content': instance.content,
      'reasons': instance.reasons,
      'tags': instance.tags,
      'rating': instance.rating,
      'imageUrl': instance.imageUrl,
      'userContext': instance.userContext,
      'matchedPreferences': instance.matchedPreferences,
      'modelInfo': instance.modelInfo,
      'additionalData': instance.additionalData,
      'isViewed': instance.isViewed,
      'isLiked': instance.isLiked,
      'isBookmarked': instance.isBookmarked,
      'isBooked': instance.isBooked,
      'viewedAt': instance.viewedAt?.toIso8601String(),
      'interactedAt': instance.interactedAt?.toIso8601String(),
      'generatedAt': instance.generatedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

const _$RecommendationTypeEnumMap = {
  RecommendationType.destination: 'destination',
  RecommendationType.package: 'package',
  RecommendationType.activity: 'activity',
  RecommendationType.restaurant: 'restaurant',
  RecommendationType.hotel: 'hotel',
};

const _$ConfidenceLevelEnumMap = {
  ConfidenceLevel.low: 'low',
  ConfidenceLevel.medium: 'medium',
  ConfidenceLevel.high: 'high',
  ConfidenceLevel.veryHigh: 'veryHigh',
};

RecommendationContent _$RecommendationContentFromJson(
        Map<String, dynamic> json) =>
    RecommendationContent(
      packageId: json['packageId'] as String?,
      destinationId: json['destinationId'] as String?,
      hotelId: json['hotelId'] as String?,
      activityId: json['activityId'] as String?,
      restaurantId: json['restaurantId'] as String?,
      priceRange: json['priceRange'] == null
          ? null
          : PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>),
      currency: json['currency'] as String?,
      hasDiscount: json['hasDiscount'] as bool?,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      location: json['location'] == null
          ? null
          : LocationInfo.fromJson(json['location'] as Map<String, dynamic>),
      duration: json['duration'] as String?,
      highlights: (json['highlights'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      inclusions: (json['inclusions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      customData: json['customData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RecommendationContentToJson(
        RecommendationContent instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'destinationId': instance.destinationId,
      'hotelId': instance.hotelId,
      'activityId': instance.activityId,
      'restaurantId': instance.restaurantId,
      'priceRange': instance.priceRange,
      'currency': instance.currency,
      'hasDiscount': instance.hasDiscount,
      'originalPrice': instance.originalPrice,
      'discountedPrice': instance.discountedPrice,
      'location': instance.location,
      'duration': instance.duration,
      'highlights': instance.highlights,
      'inclusions': instance.inclusions,
      'customData': instance.customData,
    };

PriceRange _$PriceRangeFromJson(Map<String, dynamic> json) => PriceRange(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      category: json['category'] as String,
    );

Map<String, dynamic> _$PriceRangeToJson(PriceRange instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'category': instance.category,
    };

LocationInfo _$LocationInfoFromJson(Map<String, dynamic> json) => LocationInfo(
      country: json['country'] as String,
      city: json['city'] as String,
      region: json['region'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$LocationInfoToJson(LocationInfo instance) =>
    <String, dynamic>{
      'country': instance.country,
      'city': instance.city,
      'region': instance.region,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
    };

UserContext _$UserContextFromJson(Map<String, dynamic> json) => UserContext(
      searchHistory: (json['searchHistory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bookingHistory: (json['bookingHistory'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      viewedItems: (json['viewedItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      likedItems: (json['likedItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      seasonalContext: json['seasonalContext'] == null
          ? null
          : SeasonalContext.fromJson(
              json['seasonalContext'] as Map<String, dynamic>),
      socialContext: json['socialContext'] == null
          ? null
          : SocialContext.fromJson(
              json['socialContext'] as Map<String, dynamic>),
      currentLocation: json['currentLocation'] as String?,
      contextTimestamp: DateTime.parse(json['contextTimestamp'] as String),
    );

Map<String, dynamic> _$UserContextToJson(UserContext instance) =>
    <String, dynamic>{
      'searchHistory': instance.searchHistory,
      'bookingHistory': instance.bookingHistory,
      'viewedItems': instance.viewedItems,
      'likedItems': instance.likedItems,
      'seasonalContext': instance.seasonalContext,
      'socialContext': instance.socialContext,
      'currentLocation': instance.currentLocation,
      'contextTimestamp': instance.contextTimestamp.toIso8601String(),
    };

SeasonalContext _$SeasonalContextFromJson(Map<String, dynamic> json) =>
    SeasonalContext(
      currentSeason: json['currentSeason'] as String,
      seasonalPreferences: (json['seasonalPreferences'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      weatherPreference: json['weatherPreference'] as String?,
      seasonalActivities: (json['seasonalActivities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SeasonalContextToJson(SeasonalContext instance) =>
    <String, dynamic>{
      'currentSeason': instance.currentSeason,
      'seasonalPreferences': instance.seasonalPreferences,
      'weatherPreference': instance.weatherPreference,
      'seasonalActivities': instance.seasonalActivities,
    };

SocialContext _$SocialContextFromJson(Map<String, dynamic> json) =>
    SocialContext(
      travelCompanion: json['travelCompanion'] as String,
      groupSize: (json['groupSize'] as num?)?.toInt(),
      groupPreferences: (json['groupPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      occasion: json['occasion'] as String?,
    );

Map<String, dynamic> _$SocialContextToJson(SocialContext instance) =>
    <String, dynamic>{
      'travelCompanion': instance.travelCompanion,
      'groupSize': instance.groupSize,
      'groupPreferences': instance.groupPreferences,
      'occasion': instance.occasion,
    };

UserPreference _$UserPreferenceFromJson(Map<String, dynamic> json) =>
    UserPreference(
      id: json['id'] as String,
      category: $enumDecode(_$PreferenceCategoryEnumMap, json['category']),
      name: json['name'] as String,
      weight: (json['weight'] as num).toDouble(),
      value: json['value'] as String,
      matchScore: (json['matchScore'] as num).toDouble(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$UserPreferenceToJson(UserPreference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': _$PreferenceCategoryEnumMap[instance.category]!,
      'name': instance.name,
      'weight': instance.weight,
      'value': instance.value,
      'matchScore': instance.matchScore,
      'reason': instance.reason,
    };

const _$PreferenceCategoryEnumMap = {
  PreferenceCategory.budget: 'budget',
  PreferenceCategory.activity: 'activity',
  PreferenceCategory.accommodation: 'accommodation',
  PreferenceCategory.cuisine: 'cuisine',
  PreferenceCategory.climate: 'climate',
  PreferenceCategory.culture: 'culture',
};

ModelInfo _$ModelInfoFromJson(Map<String, dynamic> json) => ModelInfo(
      modelName: json['modelName'] as String,
      modelVersion: json['modelVersion'] as String,
      algorithm: json['algorithm'] as String,
      accuracy: (json['accuracy'] as num).toDouble(),
      trainedAt: DateTime.parse(json['trainedAt'] as String),
      hyperparameters: json['hyperparameters'] as Map<String, dynamic>,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ModelInfoToJson(ModelInfo instance) => <String, dynamic>{
      'modelName': instance.modelName,
      'modelVersion': instance.modelVersion,
      'algorithm': instance.algorithm,
      'accuracy': instance.accuracy,
      'trainedAt': instance.trainedAt.toIso8601String(),
      'hyperparameters': instance.hyperparameters,
      'features': instance.features,
    };

AIItineraryModel _$AIItineraryModelFromJson(Map<String, dynamic> json) =>
    AIItineraryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      destination: json['destination'] as String,
      durationDays: (json['durationDays'] as num).toInt(),
      days: (json['days'] as List<dynamic>)
          .map((e) => ItineraryDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      preferences: ItineraryPreferences.fromJson(
          json['preferences'] as Map<String, dynamic>),
      confidence: (json['confidence'] as num).toDouble(),
      reasons:
          (json['reasons'] as List<dynamic>).map((e) => e as String).toList(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      modifiedAt: json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
    );

Map<String, dynamic> _$AIItineraryModelToJson(AIItineraryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'destination': instance.destination,
      'durationDays': instance.durationDays,
      'days': instance.days,
      'preferences': instance.preferences,
      'confidence': instance.confidence,
      'reasons': instance.reasons,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt?.toIso8601String(),
    };

ItineraryDay _$ItineraryDayFromJson(Map<String, dynamic> json) => ItineraryDay(
      dayNumber: (json['dayNumber'] as num).toInt(),
      theme: json['theme'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ItineraryActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      accommodation: json['accommodation'] as String?,
      meals:
          (json['meals'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notes: json['notes'] as String?,
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
    );

Map<String, dynamic> _$ItineraryDayToJson(ItineraryDay instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'theme': instance.theme,
      'activities': instance.activities,
      'accommodation': instance.accommodation,
      'meals': instance.meals,
      'notes': instance.notes,
      'estimatedCost': instance.estimatedCost,
    };

ItineraryActivity _$ItineraryActivityFromJson(Map<String, dynamic> json) =>
    ItineraryActivity(
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      location: json['location'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      cost: (json['cost'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ItineraryActivityToJson(ItineraryActivity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'location': instance.location,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'cost': instance.cost,
      'rating': instance.rating,
      'tags': instance.tags,
    };

ItineraryPreferences _$ItineraryPreferencesFromJson(
        Map<String, dynamic> json) =>
    ItineraryPreferences(
      budget: (json['budget'] as num).toDouble(),
      budgetCategory: json['budgetCategory'] as String,
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      pace: json['pace'] as String,
      accommodationType: json['accommodationType'] as String,
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      includeTransport: json['includeTransport'] as bool,
    );

Map<String, dynamic> _$ItineraryPreferencesToJson(
        ItineraryPreferences instance) =>
    <String, dynamic>{
      'budget': instance.budget,
      'budgetCategory': instance.budgetCategory,
      'interests': instance.interests,
      'pace': instance.pace,
      'accommodationType': instance.accommodationType,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'includeTransport': instance.includeTransport,
    };
