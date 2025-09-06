// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlightModel _$FlightModelFromJson(Map<String, dynamic> json) => FlightModel(
      id: json['id'] as String,
      flightNumber: json['flightNumber'] as String,
      airline: json['airline'] as String,
      airlineCode: json['airlineCode'] as String,
      flightType: $enumDecode(_$FlightTypeEnumMap, json['flightType']),
      departureAirport:
          Airport.fromJson(json['departureAirport'] as Map<String, dynamic>),
      arrivalAirport:
          Airport.fromJson(json['arrivalAirport'] as Map<String, dynamic>),
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      duration: json['duration'] as String,
      stops: (json['stops'] as num?)?.toInt(),
      stopoverAirports: (json['stopoverAirports'] as List<dynamic>?)
          ?.map((e) => Airport.fromJson(e as Map<String, dynamic>))
          .toList(),
      aircraftType: json['aircraftType'] as String,
      aircraftModel: json['aircraftModel'] as String?,
      seatPricing: (json['seatPricing'] as List<dynamic>)
          .map((e) => SeatClassPricing.fromJson(e as Map<String, dynamic>))
          .toList(),
      seatAvailability: (json['seatAvailability'] as List<dynamic>)
          .map((e) => SeatAvailability.fromJson(e as Map<String, dynamic>))
          .toList(),
      baggagePolicy:
          BaggagePolicy.fromJson(json['baggagePolicy'] as Map<String, dynamic>),
      status: $enumDecode(_$FlightStatusEnumMap, json['status']),
      statusMessage: json['statusMessage'] as String?,
      actualDepartureTime: json['actualDepartureTime'] == null
          ? null
          : DateTime.parse(json['actualDepartureTime'] as String),
      actualArrivalTime: json['actualArrivalTime'] == null
          ? null
          : DateTime.parse(json['actualArrivalTime'] as String),
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      mealService: json['mealService'] as bool,
      wifiAvailable: json['wifiAvailable'] as bool,
      entertainmentSystem: json['entertainmentSystem'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FlightModelToJson(FlightModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'flightNumber': instance.flightNumber,
      'airline': instance.airline,
      'airlineCode': instance.airlineCode,
      'flightType': _$FlightTypeEnumMap[instance.flightType]!,
      'departureAirport': instance.departureAirport,
      'arrivalAirport': instance.arrivalAirport,
      'departureTime': instance.departureTime.toIso8601String(),
      'arrivalTime': instance.arrivalTime.toIso8601String(),
      'duration': instance.duration,
      'stops': instance.stops,
      'stopoverAirports': instance.stopoverAirports,
      'aircraftType': instance.aircraftType,
      'aircraftModel': instance.aircraftModel,
      'seatPricing': instance.seatPricing,
      'seatAvailability': instance.seatAvailability,
      'baggagePolicy': instance.baggagePolicy,
      'status': _$FlightStatusEnumMap[instance.status]!,
      'statusMessage': instance.statusMessage,
      'actualDepartureTime': instance.actualDepartureTime?.toIso8601String(),
      'actualArrivalTime': instance.actualArrivalTime?.toIso8601String(),
      'amenities': instance.amenities,
      'mealService': instance.mealService,
      'wifiAvailable': instance.wifiAvailable,
      'entertainmentSystem': instance.entertainmentSystem,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$FlightTypeEnumMap = {
  FlightType.domestic: 'domestic',
  FlightType.international: 'international',
};

const _$FlightStatusEnumMap = {
  FlightStatus.scheduled: 'scheduled',
  FlightStatus.delayed: 'delayed',
  FlightStatus.cancelled: 'cancelled',
  FlightStatus.boarding: 'boarding',
  FlightStatus.departed: 'departed',
  FlightStatus.arrived: 'arrived',
};

Airport _$AirportFromJson(Map<String, dynamic> json) => Airport(
      code: json['code'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      timezone: json['timezone'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AirportToJson(Airport instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'city': instance.city,
      'country': instance.country,
      'timezone': instance.timezone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

SeatClassPricing _$SeatClassPricingFromJson(Map<String, dynamic> json) =>
    SeatClassPricing(
      seatClass: $enumDecode(_$SeatClassEnumMap, json['seatClass']),
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String,
      refundable: json['refundable'] as bool,
      changeable: json['changeable'] as bool,
      fareType: json['fareType'] as String?,
      inclusions: (json['inclusions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      restrictions: (json['restrictions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$SeatClassPricingToJson(SeatClassPricing instance) =>
    <String, dynamic>{
      'seatClass': _$SeatClassEnumMap[instance.seatClass]!,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'currency': instance.currency,
      'refundable': instance.refundable,
      'changeable': instance.changeable,
      'fareType': instance.fareType,
      'inclusions': instance.inclusions,
      'restrictions': instance.restrictions,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$SeatClassEnumMap = {
  SeatClass.economy: 'economy',
  SeatClass.business: 'business',
  SeatClass.first: 'first',
};

SeatAvailability _$SeatAvailabilityFromJson(Map<String, dynamic> json) =>
    SeatAvailability(
      seatClass: $enumDecode(_$SeatClassEnumMap, json['seatClass']),
      availableSeats: (json['availableSeats'] as num).toInt(),
      totalSeats: (json['totalSeats'] as num).toInt(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$SeatAvailabilityToJson(SeatAvailability instance) =>
    <String, dynamic>{
      'seatClass': _$SeatClassEnumMap[instance.seatClass]!,
      'availableSeats': instance.availableSeats,
      'totalSeats': instance.totalSeats,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

BaggagePolicy _$BaggagePolicyFromJson(Map<String, dynamic> json) =>
    BaggagePolicy(
      carryOn:
          BaggageAllowance.fromJson(json['carryOn'] as Map<String, dynamic>),
      checkedBaggage: BaggageAllowance.fromJson(
          json['checkedBaggage'] as Map<String, dynamic>),
      rules: (json['rules'] as List<dynamic>)
          .map((e) => BaggageRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BaggagePolicyToJson(BaggagePolicy instance) =>
    <String, dynamic>{
      'carryOn': instance.carryOn,
      'checkedBaggage': instance.checkedBaggage,
      'rules': instance.rules,
    };

BaggageAllowance _$BaggageAllowanceFromJson(Map<String, dynamic> json) =>
    BaggageAllowance(
      maxWeight: (json['maxWeight'] as num).toInt(),
      weightUnit: json['weightUnit'] as String,
      maxDimensions: json['maxDimensions'] as String?,
      maxPieces: (json['maxPieces'] as num).toInt(),
      excessFee: (json['excessFee'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BaggageAllowanceToJson(BaggageAllowance instance) =>
    <String, dynamic>{
      'maxWeight': instance.maxWeight,
      'weightUnit': instance.weightUnit,
      'maxDimensions': instance.maxDimensions,
      'maxPieces': instance.maxPieces,
      'excessFee': instance.excessFee,
    };

BaggageRule _$BaggageRuleFromJson(Map<String, dynamic> json) => BaggageRule(
      appliesTo: $enumDecode(_$SeatClassEnumMap, json['appliesTo']),
      description: json['description'] as String,
      additionalFee: (json['additionalFee'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BaggageRuleToJson(BaggageRule instance) =>
    <String, dynamic>{
      'appliesTo': _$SeatClassEnumMap[instance.appliesTo]!,
      'description': instance.description,
      'additionalFee': instance.additionalFee,
    };
