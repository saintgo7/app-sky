// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotelModel _$HotelModelFromJson(Map<String, dynamic> json) => HotelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      starRating: (json['starRating'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailImage: json['thumbnailImage'] as String?,
      facilities: (json['facilities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      roomTypes: (json['roomTypes'] as List<dynamic>)
          .map((e) => RoomType.fromJson(e as Map<String, dynamic>))
          .toList(),
      policies:
          HotelPolicies.fromJson(json['policies'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HotelModelToJson(HotelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'starRating': instance.starRating,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'images': instance.images,
      'thumbnailImage': instance.thumbnailImage,
      'facilities': instance.facilities,
      'amenities': instance.amenities,
      'roomTypes': instance.roomTypes,
      'policies': instance.policies,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

RoomType _$RoomTypeFromJson(Map<String, dynamic> json) => RoomType(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      maxOccupancy: (json['maxOccupancy'] as num).toInt(),
      size: (json['size'] as num).toDouble(),
      sizeUnit: json['sizeUnit'] as String?,
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      pricing:
          RealTimePricing.fromJson(json['pricing'] as Map<String, dynamic>),
      availability: (json['availability'] as List<dynamic>)
          .map((e) => RoomAvailability.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoomTypeToJson(RoomType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'maxOccupancy': instance.maxOccupancy,
      'size': instance.size,
      'sizeUnit': instance.sizeUnit,
      'amenities': instance.amenities,
      'images': instance.images,
      'pricing': instance.pricing,
      'availability': instance.availability,
    };

RealTimePricing _$RealTimePricingFromJson(Map<String, dynamic> json) =>
    RealTimePricing(
      basePrice: (json['basePrice'] as num).toDouble(),
      currency: json['currency'] as String,
      variations: (json['variations'] as List<dynamic>)
          .map((e) => PriceVariation.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$RealTimePricingToJson(RealTimePricing instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'currency': instance.currency,
      'variations': instance.variations,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

PriceVariation _$PriceVariationFromJson(Map<String, dynamic> json) =>
    PriceVariation(
      date: DateTime.parse(json['date'] as String),
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$PriceVariationToJson(PriceVariation instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'reason': instance.reason,
    };

RoomAvailability _$RoomAvailabilityFromJson(Map<String, dynamic> json) =>
    RoomAvailability(
      date: DateTime.parse(json['date'] as String),
      availableRooms: (json['availableRooms'] as num).toInt(),
      totalRooms: (json['totalRooms'] as num).toInt(),
    );

Map<String, dynamic> _$RoomAvailabilityToJson(RoomAvailability instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'availableRooms': instance.availableRooms,
      'totalRooms': instance.totalRooms,
    };

HotelPolicies _$HotelPoliciesFromJson(Map<String, dynamic> json) =>
    HotelPolicies(
      checkInTime: json['checkInTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
      cancellationPolicy: CancellationPolicy.fromJson(
          json['cancellationPolicy'] as Map<String, dynamic>),
      acceptedPayments: (json['acceptedPayments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allowsPets: json['allowsPets'] as bool,
      allowsSmoking: json['allowsSmoking'] as bool,
      childPolicy: json['childPolicy'] as String?,
    );

Map<String, dynamic> _$HotelPoliciesToJson(HotelPolicies instance) =>
    <String, dynamic>{
      'checkInTime': instance.checkInTime,
      'checkOutTime': instance.checkOutTime,
      'cancellationPolicy': instance.cancellationPolicy,
      'acceptedPayments': instance.acceptedPayments,
      'allowsPets': instance.allowsPets,
      'allowsSmoking': instance.allowsSmoking,
      'childPolicy': instance.childPolicy,
    };

CancellationPolicy _$CancellationPolicyFromJson(Map<String, dynamic> json) =>
    CancellationPolicy(
      freeCancellation: json['freeCancellation'] as bool,
      freeCancellationDays: (json['freeCancellationDays'] as num?)?.toInt(),
      cancellationFee: (json['cancellationFee'] as num?)?.toDouble(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$CancellationPolicyToJson(CancellationPolicy instance) =>
    <String, dynamic>{
      'freeCancellation': instance.freeCancellation,
      'freeCancellationDays': instance.freeCancellationDays,
      'cancellationFee': instance.cancellationFee,
      'description': instance.description,
    };
