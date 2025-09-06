import 'package:json_annotation/json_annotation.dart';

part 'flight_model.g.dart';

enum FlightType { domestic, international }
enum SeatClass { economy, business, first }
enum FlightStatus { scheduled, delayed, cancelled, boarding, departed, arrived }

@JsonSerializable()
class FlightModel {
  final String id;
  final String flightNumber;
  final String airline;
  final String airlineCode;
  final FlightType flightType;
  
  // Route Information
  final Airport departureAirport;
  final Airport arrivalAirport;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String duration;
  final int? stops;
  final List<Airport>? stopoverAirports;
  
  // Aircraft Information
  final String aircraftType;
  final String? aircraftModel;
  
  // Pricing and Availability
  final List<SeatClassPricing> seatPricing;
  final List<SeatAvailability> seatAvailability;
  
  // Baggage Information
  final BaggagePolicy baggagePolicy;
  
  // Flight Status
  final FlightStatus status;
  final String? statusMessage;
  final DateTime? actualDepartureTime;
  final DateTime? actualArrivalTime;
  
  // Additional Information
  final List<String> amenities;
  final bool mealService;
  final bool wifiAvailable;
  final bool entertainmentSystem;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  const FlightModel({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.airlineCode,
    required this.flightType,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    this.stops,
    this.stopoverAirports,
    required this.aircraftType,
    this.aircraftModel,
    required this.seatPricing,
    required this.seatAvailability,
    required this.baggagePolicy,
    required this.status,
    this.statusMessage,
    this.actualDepartureTime,
    this.actualArrivalTime,
    required this.amenities,
    required this.mealService,
    required this.wifiAvailable,
    required this.entertainmentSystem,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) => _$FlightModelFromJson(json);
  Map<String, dynamic> toJson() => _$FlightModelToJson(this);
}

@JsonSerializable()
class Airport {
  final String code; // IATA code (e.g., ICN, LAX)
  final String name;
  final String city;
  final String country;
  final String timezone;
  final double? latitude;
  final double? longitude;

  const Airport({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
    required this.timezone,
    this.latitude,
    this.longitude,
  });

  factory Airport.fromJson(Map<String, dynamic> json) => _$AirportFromJson(json);
  Map<String, dynamic> toJson() => _$AirportToJson(this);
}

@JsonSerializable()
class SeatClassPricing {
  final SeatClass seatClass;
  final double price;
  final double? originalPrice;
  final String currency;
  final bool refundable;
  final bool changeable;
  final String? fareType;
  final List<String> inclusions;
  final List<String> restrictions;
  final DateTime lastUpdated;

  const SeatClassPricing({
    required this.seatClass,
    required this.price,
    this.originalPrice,
    required this.currency,
    required this.refundable,
    required this.changeable,
    this.fareType,
    required this.inclusions,
    required this.restrictions,
    required this.lastUpdated,
  });

  factory SeatClassPricing.fromJson(Map<String, dynamic> json) => _$SeatClassPricingFromJson(json);
  Map<String, dynamic> toJson() => _$SeatClassPricingToJson(this);
}

@JsonSerializable()
class SeatAvailability {
  final SeatClass seatClass;
  final int availableSeats;
  final int totalSeats;
  final DateTime lastUpdated;

  const SeatAvailability({
    required this.seatClass,
    required this.availableSeats,
    required this.totalSeats,
    required this.lastUpdated,
  });

  factory SeatAvailability.fromJson(Map<String, dynamic> json) => _$SeatAvailabilityFromJson(json);
  Map<String, dynamic> toJson() => _$SeatAvailabilityToJson(this);
}

@JsonSerializable()
class BaggagePolicy {
  final BaggageAllowance carryOn;
  final BaggageAllowance checkedBaggage;
  final List<BaggageRule> rules;

  const BaggagePolicy({
    required this.carryOn,
    required this.checkedBaggage,
    required this.rules,
  });

  factory BaggagePolicy.fromJson(Map<String, dynamic> json) => _$BaggagePolicyFromJson(json);
  Map<String, dynamic> toJson() => _$BaggagePolicyToJson(this);
}

@JsonSerializable()
class BaggageAllowance {
  final int maxWeight;
  final String weightUnit;
  final String? maxDimensions;
  final int maxPieces;
  final double? excessFee;

  const BaggageAllowance({
    required this.maxWeight,
    required this.weightUnit,
    this.maxDimensions,
    required this.maxPieces,
    this.excessFee,
  });

  factory BaggageAllowance.fromJson(Map<String, dynamic> json) => _$BaggageAllowanceFromJson(json);
  Map<String, dynamic> toJson() => _$BaggageAllowanceToJson(this);
}

@JsonSerializable()
class BaggageRule {
  final SeatClass appliesTo;
  final String description;
  final double? additionalFee;

  const BaggageRule({
    required this.appliesTo,
    required this.description,
    this.additionalFee,
  });

  factory BaggageRule.fromJson(Map<String, dynamic> json) => _$BaggageRuleFromJson(json);
  Map<String, dynamic> toJson() => _$BaggageRuleToJson(this);
}