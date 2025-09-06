import 'package:json_annotation/json_annotation.dart';

part 'travel_package_model.g.dart';

enum PackageType { package, freeTravel, customized }
enum PricingPolicy { fixed, dynamic, negotiable }

@JsonSerializable()
class TravelPackageModel {
  final String id;
  final String title;
  final String description;
  final String destination;
  final List<String> countries;
  final List<String> cities;
  final PackageType packageType;
  final int durationDays;
  final int durationNights;
  final List<String> images;
  final String? thumbnailImage;
  
  // Pricing
  final PricingInfo pricingInfo;
  final List<PriceOption> priceOptions;
  
  // Inclusions
  final PackageInclusions inclusions;
  
  // Availability
  final List<AvailabilitySlot> availability;
  final int maxParticipants;
  final int minParticipants;
  
  // Ratings and Reviews
  final double rating;
  final int reviewCount;
  
  // Categories and Tags
  final List<String> categories;
  final List<String> tags;
  
  // Itinerary
  final List<ItineraryDay> itinerary;
  
  // Status
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TravelPackageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.destination,
    required this.countries,
    required this.cities,
    required this.packageType,
    required this.durationDays,
    required this.durationNights,
    required this.images,
    this.thumbnailImage,
    required this.pricingInfo,
    required this.priceOptions,
    required this.inclusions,
    required this.availability,
    required this.maxParticipants,
    required this.minParticipants,
    required this.rating,
    required this.reviewCount,
    required this.categories,
    required this.tags,
    required this.itinerary,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TravelPackageModel.fromJson(Map<String, dynamic> json) => _$TravelPackageModelFromJson(json);
  Map<String, dynamic> toJson() => _$TravelPackageModelToJson(this);
}

@JsonSerializable()
class PricingInfo {
  final PricingPolicy policy;
  final double basePrice;
  final String currency;
  final double? discountPercentage;
  final DateTime? discountValidUntil;
  final bool dynamicPricing;

  const PricingInfo({
    required this.policy,
    required this.basePrice,
    required this.currency,
    this.discountPercentage,
    this.discountValidUntil,
    required this.dynamicPricing,
  });

  factory PricingInfo.fromJson(Map<String, dynamic> json) => _$PricingInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PricingInfoToJson(this);
}

@JsonSerializable()
class PriceOption {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> inclusions;
  final List<String> exclusions;

  const PriceOption({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.inclusions,
    required this.exclusions,
  });

  factory PriceOption.fromJson(Map<String, dynamic> json) => _$PriceOptionFromJson(json);
  Map<String, dynamic> toJson() => _$PriceOptionToJson(this);
}

@JsonSerializable()
class PackageInclusions {
  final bool flights;
  final bool accommodation;
  final bool meals;
  final bool transportation;
  final bool activities;
  final bool insurance;
  final bool visa;
  final bool guide;
  final List<String> specificInclusions;
  final List<String> exclusions;

  const PackageInclusions({
    required this.flights,
    required this.accommodation,
    required this.meals,
    required this.transportation,
    required this.activities,
    required this.insurance,
    required this.visa,
    required this.guide,
    required this.specificInclusions,
    required this.exclusions,
  });

  factory PackageInclusions.fromJson(Map<String, dynamic> json) => _$PackageInclusionsFromJson(json);
  Map<String, dynamic> toJson() => _$PackageInclusionsToJson(this);
}

@JsonSerializable()
class AvailabilitySlot {
  final DateTime startDate;
  final DateTime endDate;
  final int availableSlots;
  final double? priceAdjustment;

  const AvailabilitySlot({
    required this.startDate,
    required this.endDate,
    required this.availableSlots,
    this.priceAdjustment,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) => _$AvailabilitySlotFromJson(json);
  Map<String, dynamic> toJson() => _$AvailabilitySlotToJson(this);
}

@JsonSerializable()
class ItineraryDay {
  final int day;
  final String title;
  final String description;
  final List<String> activities;
  final String? accommodation;
  final String? meals;
  final String? transportation;

  const ItineraryDay({
    required this.day,
    required this.title,
    required this.description,
    required this.activities,
    this.accommodation,
    this.meals,
    this.transportation,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> json) => _$ItineraryDayFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryDayToJson(this);
}