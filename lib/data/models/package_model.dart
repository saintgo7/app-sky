import 'package:json_annotation/json_annotation.dart';

part 'package_model.g.dart';

@JsonSerializable()
class PackageModel {
  final int id;
  final String name;
  final String description;
  final String destination;
  final double price;
  @JsonKey(name: 'duration_days')
  final int durationDays;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final List<String> highlights;
  final List<String> inclusions;
  final List<String> exclusions;
  @JsonKey(name: 'departure_dates')
  final List<DateTime> departureDates;
  @JsonKey(name: 'max_capacity')
  final int maxCapacity;
  @JsonKey(name: 'current_bookings')
  final int currentBookings;
  final double rating;
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  PackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.destination,
    required this.price,
    required this.durationDays,
    this.imageUrl,
    required this.highlights,
    required this.inclusions,
    required this.exclusions,
    required this.departureDates,
    required this.maxCapacity,
    required this.currentBookings,
    required this.rating,
    required this.reviewCount,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => 
      _$PackageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PackageModelToJson(this);

  bool get isAvailable => currentBookings < maxCapacity;
  
  double get availabilityPercentage => 
      (currentBookings / maxCapacity * 100).clamp(0, 100);
}