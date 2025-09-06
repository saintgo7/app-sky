import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

enum BookingStatus { pending, confirmed, paid, cancelled, completed, refunded }
enum PaymentStatus { pending, processing, paid, failed, refunded, partialRefund }
enum BookingType { individual, group, corporate }

@JsonSerializable()
class BookingModel {
  final String id;
  final String userId;
  final BookingType bookingType;
  final String? groupId;
  
  // Booking Details
  final String packageId;
  final String packageTitle;
  final DateTime travelStartDate;
  final DateTime travelEndDate;
  final int numberOfTravelers;
  final List<TravelerInfo> travelers;
  
  // Pricing
  final BookingPricing pricing;
  final PaymentInfo paymentInfo;
  
  // Status
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? statusMessage;
  
  // Additional Services
  final List<AdditionalService>? additionalServices;
  final List<FlightBooking>? flightBookings;
  final List<HotelBooking>? hotelBookings;
  
  // Special Requests
  final String? specialRequests;
  final List<String>? dietaryRequirements;
  final String? accessibilityNeeds;
  
  // Communication
  final String? emergencyContact;
  final String? emergencyPhone;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.bookingType,
    this.groupId,
    required this.packageId,
    required this.packageTitle,
    required this.travelStartDate,
    required this.travelEndDate,
    required this.numberOfTravelers,
    required this.travelers,
    required this.pricing,
    required this.paymentInfo,
    required this.status,
    required this.paymentStatus,
    this.statusMessage,
    this.additionalServices,
    this.flightBookings,
    this.hotelBookings,
    this.specialRequests,
    this.dietaryRequirements,
    this.accessibilityNeeds,
    this.emergencyContact,
    this.emergencyPhone,
    required this.createdAt,
    required this.updatedAt,
    this.confirmedAt,
    this.cancelledAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}

@JsonSerializable()
class TravelerInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final DateTime dateOfBirth;
  final String gender;
  final String nationality;
  final String passportNumber;
  final DateTime passportExpiry;
  final String? visaStatus;
  final String? phone;
  final String? email;
  final bool isMainContact;
  final String? relationship; // For group bookings

  const TravelerInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.passportNumber,
    required this.passportExpiry,
    this.visaStatus,
    this.phone,
    this.email,
    required this.isMainContact,
    this.relationship,
  });

  factory TravelerInfo.fromJson(Map<String, dynamic> json) => _$TravelerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TravelerInfoToJson(this);
}

@JsonSerializable()
class BookingPricing {
  final double basePrice;
  final double totalPrice;
  final String currency;
  final List<PriceBreakdown> breakdown;
  final double? discountAmount;
  final String? discountCode;
  final double taxAmount;
  final double servicesFee;

  const BookingPricing({
    required this.basePrice,
    required this.totalPrice,
    required this.currency,
    required this.breakdown,
    this.discountAmount,
    this.discountCode,
    required this.taxAmount,
    required this.servicesFee,
  });

  factory BookingPricing.fromJson(Map<String, dynamic> json) => _$BookingPricingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingPricingToJson(this);
}

@JsonSerializable()
class PriceBreakdown {
  final String itemType;
  final String description;
  final double amount;
  final int quantity;

  const PriceBreakdown({
    required this.itemType,
    required this.description,
    required this.amount,
    required this.quantity,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) => _$PriceBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$PriceBreakdownToJson(this);
}

@JsonSerializable()
class PaymentInfo {
  final List<PaymentTransaction> transactions;
  final String? preferredPaymentMethod;
  final bool installmentPayment;
  final int? installmentMonths;
  final double? installmentAmount;

  const PaymentInfo({
    required this.transactions,
    this.preferredPaymentMethod,
    required this.installmentPayment,
    this.installmentMonths,
    this.installmentAmount,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => _$PaymentInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentInfoToJson(this);
}

@JsonSerializable()
class PaymentTransaction {
  final String id;
  final double amount;
  final String currency;
  final String paymentMethod;
  final PaymentStatus status;
  final DateTime transactionDate;
  final String? transactionReference;
  final String? failureReason;

  const PaymentTransaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    required this.transactionDate,
    this.transactionReference,
    this.failureReason,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) => _$PaymentTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentTransactionToJson(this);
}

@JsonSerializable()
class AdditionalService {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final bool isOptional;

  const AdditionalService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.isOptional,
  });

  factory AdditionalService.fromJson(Map<String, dynamic> json) => _$AdditionalServiceFromJson(json);
  Map<String, dynamic> toJson() => _$AdditionalServiceToJson(this);
}

@JsonSerializable()
class FlightBooking {
  final String flightId;
  final String flightNumber;
  final String pnr; // Passenger Name Record
  final SeatClass seatClass;
  final List<SeatAssignment> seatAssignments;

  const FlightBooking({
    required this.flightId,
    required this.flightNumber,
    required this.pnr,
    required this.seatClass,
    required this.seatAssignments,
  });

  factory FlightBooking.fromJson(Map<String, dynamic> json) => _$FlightBookingFromJson(json);
  Map<String, dynamic> toJson() => _$FlightBookingToJson(this);
}

@JsonSerializable()
class SeatAssignment {
  final String travelerId;
  final String seatNumber;

  const SeatAssignment({
    required this.travelerId,
    required this.seatNumber,
  });

  factory SeatAssignment.fromJson(Map<String, dynamic> json) => _$SeatAssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$SeatAssignmentToJson(this);
}

@JsonSerializable()
class HotelBooking {
  final String hotelId;
  final String hotelName;
  final String confirmationNumber;
  final String roomTypeId;
  final int numberOfRooms;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final List<RoomAssignment> roomAssignments;

  const HotelBooking({
    required this.hotelId,
    required this.hotelName,
    required this.confirmationNumber,
    required this.roomTypeId,
    required this.numberOfRooms,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomAssignments,
  });

  factory HotelBooking.fromJson(Map<String, dynamic> json) => _$HotelBookingFromJson(json);
  Map<String, dynamic> toJson() => _$HotelBookingToJson(this);
}

@JsonSerializable()
class RoomAssignment {
  final String roomNumber;
  final List<String> travelerIds;

  const RoomAssignment({
    required this.roomNumber,
    required this.travelerIds,
  });

  factory RoomAssignment.fromJson(Map<String, dynamic> json) => _$RoomAssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$RoomAssignmentToJson(this);
}

// Import SeatClass from flight_model.dart
enum SeatClass { economy, business, first }