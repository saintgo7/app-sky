// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelPackageModel _$TravelPackageModelFromJson(Map<String, dynamic> json) =>
    TravelPackageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      destination: json['destination'] as String,
      countries:
          (json['countries'] as List<dynamic>).map((e) => e as String).toList(),
      cities:
          (json['cities'] as List<dynamic>).map((e) => e as String).toList(),
      packageType: $enumDecode(_$PackageTypeEnumMap, json['packageType']),
      durationDays: (json['durationDays'] as num).toInt(),
      durationNights: (json['durationNights'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailImage: json['thumbnailImage'] as String?,
      pricingInfo:
          PricingInfo.fromJson(json['pricingInfo'] as Map<String, dynamic>),
      priceOptions: (json['priceOptions'] as List<dynamic>)
          .map((e) => PriceOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      inclusions: PackageInclusions.fromJson(
          json['inclusions'] as Map<String, dynamic>),
      availability: (json['availability'] as List<dynamic>)
          .map((e) => AvailabilitySlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      minParticipants: (json['minParticipants'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      itinerary: (json['itinerary'] as List<dynamic>)
          .map((e) => ItineraryDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TravelPackageModelToJson(TravelPackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'destination': instance.destination,
      'countries': instance.countries,
      'cities': instance.cities,
      'packageType': _$PackageTypeEnumMap[instance.packageType]!,
      'durationDays': instance.durationDays,
      'durationNights': instance.durationNights,
      'images': instance.images,
      'thumbnailImage': instance.thumbnailImage,
      'pricingInfo': instance.pricingInfo,
      'priceOptions': instance.priceOptions,
      'inclusions': instance.inclusions,
      'availability': instance.availability,
      'maxParticipants': instance.maxParticipants,
      'minParticipants': instance.minParticipants,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'categories': instance.categories,
      'tags': instance.tags,
      'itinerary': instance.itinerary,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PackageTypeEnumMap = {
  PackageType.package: 'package',
  PackageType.freeTravel: 'freeTravel',
  PackageType.customized: 'customized',
};

PricingInfo _$PricingInfoFromJson(Map<String, dynamic> json) => PricingInfo(
      policy: $enumDecode(_$PricingPolicyEnumMap, json['policy']),
      basePrice: (json['basePrice'] as num).toDouble(),
      currency: json['currency'] as String,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      discountValidUntil: json['discountValidUntil'] == null
          ? null
          : DateTime.parse(json['discountValidUntil'] as String),
      dynamicPricing: json['dynamicPricing'] as bool,
    );

Map<String, dynamic> _$PricingInfoToJson(PricingInfo instance) =>
    <String, dynamic>{
      'policy': _$PricingPolicyEnumMap[instance.policy]!,
      'basePrice': instance.basePrice,
      'currency': instance.currency,
      'discountPercentage': instance.discountPercentage,
      'discountValidUntil': instance.discountValidUntil?.toIso8601String(),
      'dynamicPricing': instance.dynamicPricing,
    };

const _$PricingPolicyEnumMap = {
  PricingPolicy.fixed: 'fixed',
  PricingPolicy.dynamic: 'dynamic',
  PricingPolicy.negotiable: 'negotiable',
};

PriceOption _$PriceOptionFromJson(Map<String, dynamic> json) => PriceOption(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      inclusions: (json['inclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      exclusions: (json['exclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PriceOptionToJson(PriceOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'inclusions': instance.inclusions,
      'exclusions': instance.exclusions,
    };

PackageInclusions _$PackageInclusionsFromJson(Map<String, dynamic> json) =>
    PackageInclusions(
      flights: json['flights'] as bool,
      accommodation: json['accommodation'] as bool,
      meals: json['meals'] as bool,
      transportation: json['transportation'] as bool,
      activities: json['activities'] as bool,
      insurance: json['insurance'] as bool,
      visa: json['visa'] as bool,
      guide: json['guide'] as bool,
      specificInclusions: (json['specificInclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      exclusions: (json['exclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PackageInclusionsToJson(PackageInclusions instance) =>
    <String, dynamic>{
      'flights': instance.flights,
      'accommodation': instance.accommodation,
      'meals': instance.meals,
      'transportation': instance.transportation,
      'activities': instance.activities,
      'insurance': instance.insurance,
      'visa': instance.visa,
      'guide': instance.guide,
      'specificInclusions': instance.specificInclusions,
      'exclusions': instance.exclusions,
    };

AvailabilitySlot _$AvailabilitySlotFromJson(Map<String, dynamic> json) =>
    AvailabilitySlot(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      availableSlots: (json['availableSlots'] as num).toInt(),
      priceAdjustment: (json['priceAdjustment'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AvailabilitySlotToJson(AvailabilitySlot instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'availableSlots': instance.availableSlots,
      'priceAdjustment': instance.priceAdjustment,
    };

ItineraryDay _$ItineraryDayFromJson(Map<String, dynamic> json) => ItineraryDay(
      day: (json['day'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      accommodation: json['accommodation'] as String?,
      meals: json['meals'] as String?,
      transportation: json['transportation'] as String?,
    );

Map<String, dynamic> _$ItineraryDayToJson(ItineraryDay instance) =>
    <String, dynamic>{
      'day': instance.day,
      'title': instance.title,
      'description': instance.description,
      'activities': instance.activities,
      'accommodation': instance.accommodation,
      'meals': instance.meals,
      'transportation': instance.transportation,
    };
