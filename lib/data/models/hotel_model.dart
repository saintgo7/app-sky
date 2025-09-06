import 'package:json_annotation/json_annotation.dart';

part 'hotel_model.g.dart';

@JsonSerializable()
class HotelModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final int starRating;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String? thumbnailImage;
  
  // Facilities and Amenities
  final List<String> facilities;
  final List<String> amenities;
  
  // Room Information
  final List<RoomType> roomTypes;
  
  // Policies
  final HotelPolicies policies;
  
  // Contact Information
  final String? phone;
  final String? email;
  final String? website;
  
  // Status
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HotelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.starRating,
    required this.rating,
    required this.reviewCount,
    required this.images,
    this.thumbnailImage,
    required this.facilities,
    required this.amenities,
    required this.roomTypes,
    required this.policies,
    this.phone,
    this.email,
    this.website,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) => _$HotelModelFromJson(json);
  Map<String, dynamic> toJson() => _$HotelModelToJson(this);
}

@JsonSerializable()
class RoomType {
  final String id;
  final String name;
  final String description;
  final int maxOccupancy;
  final double size;
  final String? sizeUnit;
  final List<String> amenities;
  final List<String> images;
  final RealTimePricing pricing;
  final List<RoomAvailability> availability;

  const RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.maxOccupancy,
    required this.size,
    this.sizeUnit,
    required this.amenities,
    required this.images,
    required this.pricing,
    required this.availability,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) => _$RoomTypeFromJson(json);
  Map<String, dynamic> toJson() => _$RoomTypeToJson(this);
}

@JsonSerializable()
class RealTimePricing {
  final double basePrice;
  final String currency;
  final List<PriceVariation> variations;
  final DateTime lastUpdated;

  const RealTimePricing({
    required this.basePrice,
    required this.currency,
    required this.variations,
    required this.lastUpdated,
  });

  factory RealTimePricing.fromJson(Map<String, dynamic> json) => _$RealTimePricingFromJson(json);
  Map<String, dynamic> toJson() => _$RealTimePricingToJson(this);
}

@JsonSerializable()
class PriceVariation {
  final DateTime date;
  final double price;
  final double? originalPrice;
  final String? reason; // 'high_demand', 'special_event', 'discount', etc.

  const PriceVariation({
    required this.date,
    required this.price,
    this.originalPrice,
    this.reason,
  });

  factory PriceVariation.fromJson(Map<String, dynamic> json) => _$PriceVariationFromJson(json);
  Map<String, dynamic> toJson() => _$PriceVariationToJson(this);
}

@JsonSerializable()
class RoomAvailability {
  final DateTime date;
  final int availableRooms;
  final int totalRooms;

  const RoomAvailability({
    required this.date,
    required this.availableRooms,
    required this.totalRooms,
  });

  factory RoomAvailability.fromJson(Map<String, dynamic> json) => _$RoomAvailabilityFromJson(json);
  Map<String, dynamic> toJson() => _$RoomAvailabilityToJson(this);
}

@JsonSerializable()
class HotelPolicies {
  final String? checkInTime;
  final String? checkOutTime;
  final CancellationPolicy cancellationPolicy;
  final List<String> acceptedPayments;
  final bool allowsPets;
  final bool allowsSmoking;
  final String? childPolicy;

  const HotelPolicies({
    this.checkInTime,
    this.checkOutTime,
    required this.cancellationPolicy,
    required this.acceptedPayments,
    required this.allowsPets,
    required this.allowsSmoking,
    this.childPolicy,
  });

  factory HotelPolicies.fromJson(Map<String, dynamic> json) => _$HotelPoliciesFromJson(json);
  Map<String, dynamic> toJson() => _$HotelPoliciesToJson(this);
}

@JsonSerializable()
class CancellationPolicy {
  final bool freeCancellation;
  final int? freeCancellationDays;
  final double? cancellationFee;
  final String description;

  const CancellationPolicy({
    required this.freeCancellation,
    this.freeCancellationDays,
    this.cancellationFee,
    required this.description,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) => _$CancellationPolicyFromJson(json);
  Map<String, dynamic> toJson() => _$CancellationPolicyToJson(this);
}