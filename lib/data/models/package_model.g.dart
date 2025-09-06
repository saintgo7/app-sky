// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageModel _$PackageModelFromJson(Map<String, dynamic> json) => PackageModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      destination: json['destination'] as String,
      price: (json['price'] as num).toDouble(),
      durationDays: (json['duration_days'] as num).toInt(),
      imageUrl: json['image_url'] as String?,
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      inclusions: (json['inclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      exclusions: (json['exclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      departureDates: (json['departure_dates'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      maxCapacity: (json['max_capacity'] as num).toInt(),
      currentBookings: (json['current_bookings'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
      isFeatured: json['is_featured'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PackageModelToJson(PackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'destination': instance.destination,
      'price': instance.price,
      'duration_days': instance.durationDays,
      'image_url': instance.imageUrl,
      'highlights': instance.highlights,
      'inclusions': instance.inclusions,
      'exclusions': instance.exclusions,
      'departure_dates':
          instance.departureDates.map((e) => e.toIso8601String()).toList(),
      'max_capacity': instance.maxCapacity,
      'current_bookings': instance.currentBookings,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'is_featured': instance.isFeatured,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
