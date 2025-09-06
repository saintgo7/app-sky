// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      bookingType: $enumDecode(_$BookingTypeEnumMap, json['bookingType']),
      groupId: json['groupId'] as String?,
      packageId: json['packageId'] as String,
      packageTitle: json['packageTitle'] as String,
      travelStartDate: DateTime.parse(json['travelStartDate'] as String),
      travelEndDate: DateTime.parse(json['travelEndDate'] as String),
      numberOfTravelers: (json['numberOfTravelers'] as num).toInt(),
      travelers: (json['travelers'] as List<dynamic>)
          .map((e) => TravelerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      pricing: BookingPricing.fromJson(json['pricing'] as Map<String, dynamic>),
      paymentInfo:
          PaymentInfo.fromJson(json['paymentInfo'] as Map<String, dynamic>),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      statusMessage: json['statusMessage'] as String?,
      additionalServices: (json['additionalServices'] as List<dynamic>?)
          ?.map((e) => AdditionalService.fromJson(e as Map<String, dynamic>))
          .toList(),
      flightBookings: (json['flightBookings'] as List<dynamic>?)
          ?.map((e) => FlightBooking.fromJson(e as Map<String, dynamic>))
          .toList(),
      hotelBookings: (json['hotelBookings'] as List<dynamic>?)
          ?.map((e) => HotelBooking.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialRequests: json['specialRequests'] as String?,
      dietaryRequirements: (json['dietaryRequirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accessibilityNeeds: json['accessibilityNeeds'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'bookingType': _$BookingTypeEnumMap[instance.bookingType]!,
      'groupId': instance.groupId,
      'packageId': instance.packageId,
      'packageTitle': instance.packageTitle,
      'travelStartDate': instance.travelStartDate.toIso8601String(),
      'travelEndDate': instance.travelEndDate.toIso8601String(),
      'numberOfTravelers': instance.numberOfTravelers,
      'travelers': instance.travelers,
      'pricing': instance.pricing,
      'paymentInfo': instance.paymentInfo,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'statusMessage': instance.statusMessage,
      'additionalServices': instance.additionalServices,
      'flightBookings': instance.flightBookings,
      'hotelBookings': instance.hotelBookings,
      'specialRequests': instance.specialRequests,
      'dietaryRequirements': instance.dietaryRequirements,
      'accessibilityNeeds': instance.accessibilityNeeds,
      'emergencyContact': instance.emergencyContact,
      'emergencyPhone': instance.emergencyPhone,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
    };

const _$BookingTypeEnumMap = {
  BookingType.individual: 'individual',
  BookingType.group: 'group',
  BookingType.corporate: 'corporate',
};

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.paid: 'paid',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.completed: 'completed',
  BookingStatus.refunded: 'refunded',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.partialRefund: 'partialRefund',
};

TravelerInfo _$TravelerInfoFromJson(Map<String, dynamic> json) => TravelerInfo(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      nationality: json['nationality'] as String,
      passportNumber: json['passportNumber'] as String,
      passportExpiry: DateTime.parse(json['passportExpiry'] as String),
      visaStatus: json['visaStatus'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isMainContact: json['isMainContact'] as bool,
      relationship: json['relationship'] as String?,
    );

Map<String, dynamic> _$TravelerInfoToJson(TravelerInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'nationality': instance.nationality,
      'passportNumber': instance.passportNumber,
      'passportExpiry': instance.passportExpiry.toIso8601String(),
      'visaStatus': instance.visaStatus,
      'phone': instance.phone,
      'email': instance.email,
      'isMainContact': instance.isMainContact,
      'relationship': instance.relationship,
    };

BookingPricing _$BookingPricingFromJson(Map<String, dynamic> json) =>
    BookingPricing(
      basePrice: (json['basePrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      breakdown: (json['breakdown'] as List<dynamic>)
          .map((e) => PriceBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      discountCode: json['discountCode'] as String?,
      taxAmount: (json['taxAmount'] as num).toDouble(),
      servicesFee: (json['servicesFee'] as num).toDouble(),
    );

Map<String, dynamic> _$BookingPricingToJson(BookingPricing instance) =>
    <String, dynamic>{
      'basePrice': instance.basePrice,
      'totalPrice': instance.totalPrice,
      'currency': instance.currency,
      'breakdown': instance.breakdown,
      'discountAmount': instance.discountAmount,
      'discountCode': instance.discountCode,
      'taxAmount': instance.taxAmount,
      'servicesFee': instance.servicesFee,
    };

PriceBreakdown _$PriceBreakdownFromJson(Map<String, dynamic> json) =>
    PriceBreakdown(
      itemType: json['itemType'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$PriceBreakdownToJson(PriceBreakdown instance) =>
    <String, dynamic>{
      'itemType': instance.itemType,
      'description': instance.description,
      'amount': instance.amount,
      'quantity': instance.quantity,
    };

PaymentInfo _$PaymentInfoFromJson(Map<String, dynamic> json) => PaymentInfo(
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => PaymentTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      preferredPaymentMethod: json['preferredPaymentMethod'] as String?,
      installmentPayment: json['installmentPayment'] as bool,
      installmentMonths: (json['installmentMonths'] as num?)?.toInt(),
      installmentAmount: (json['installmentAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PaymentInfoToJson(PaymentInfo instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
      'preferredPaymentMethod': instance.preferredPaymentMethod,
      'installmentPayment': instance.installmentPayment,
      'installmentMonths': instance.installmentMonths,
      'installmentAmount': instance.installmentAmount,
    };

PaymentTransaction _$PaymentTransactionFromJson(Map<String, dynamic> json) =>
    PaymentTransaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      transactionReference: json['transactionReference'] as String?,
      failureReason: json['failureReason'] as String?,
    );

Map<String, dynamic> _$PaymentTransactionToJson(PaymentTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'currency': instance.currency,
      'paymentMethod': instance.paymentMethod,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'transactionReference': instance.transactionReference,
      'failureReason': instance.failureReason,
    };

AdditionalService _$AdditionalServiceFromJson(Map<String, dynamic> json) =>
    AdditionalService(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      isOptional: json['isOptional'] as bool,
    );

Map<String, dynamic> _$AdditionalServiceToJson(AdditionalService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'quantity': instance.quantity,
      'isOptional': instance.isOptional,
    };

FlightBooking _$FlightBookingFromJson(Map<String, dynamic> json) =>
    FlightBooking(
      flightId: json['flightId'] as String,
      flightNumber: json['flightNumber'] as String,
      pnr: json['pnr'] as String,
      seatClass: $enumDecode(_$SeatClassEnumMap, json['seatClass']),
      seatAssignments: (json['seatAssignments'] as List<dynamic>)
          .map((e) => SeatAssignment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FlightBookingToJson(FlightBooking instance) =>
    <String, dynamic>{
      'flightId': instance.flightId,
      'flightNumber': instance.flightNumber,
      'pnr': instance.pnr,
      'seatClass': _$SeatClassEnumMap[instance.seatClass]!,
      'seatAssignments': instance.seatAssignments,
    };

const _$SeatClassEnumMap = {
  SeatClass.economy: 'economy',
  SeatClass.business: 'business',
  SeatClass.first: 'first',
};

SeatAssignment _$SeatAssignmentFromJson(Map<String, dynamic> json) =>
    SeatAssignment(
      travelerId: json['travelerId'] as String,
      seatNumber: json['seatNumber'] as String,
    );

Map<String, dynamic> _$SeatAssignmentToJson(SeatAssignment instance) =>
    <String, dynamic>{
      'travelerId': instance.travelerId,
      'seatNumber': instance.seatNumber,
    };

HotelBooking _$HotelBookingFromJson(Map<String, dynamic> json) => HotelBooking(
      hotelId: json['hotelId'] as String,
      hotelName: json['hotelName'] as String,
      confirmationNumber: json['confirmationNumber'] as String,
      roomTypeId: json['roomTypeId'] as String,
      numberOfRooms: (json['numberOfRooms'] as num).toInt(),
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      checkOutDate: DateTime.parse(json['checkOutDate'] as String),
      roomAssignments: (json['roomAssignments'] as List<dynamic>)
          .map((e) => RoomAssignment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HotelBookingToJson(HotelBooking instance) =>
    <String, dynamic>{
      'hotelId': instance.hotelId,
      'hotelName': instance.hotelName,
      'confirmationNumber': instance.confirmationNumber,
      'roomTypeId': instance.roomTypeId,
      'numberOfRooms': instance.numberOfRooms,
      'checkInDate': instance.checkInDate.toIso8601String(),
      'checkOutDate': instance.checkOutDate.toIso8601String(),
      'roomAssignments': instance.roomAssignments,
    };

RoomAssignment _$RoomAssignmentFromJson(Map<String, dynamic> json) =>
    RoomAssignment(
      roomNumber: json['roomNumber'] as String,
      travelerIds: (json['travelerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RoomAssignmentToJson(RoomAssignment instance) =>
    <String, dynamic>{
      'roomNumber': instance.roomNumber,
      'travelerIds': instance.travelerIds,
    };
