import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/booking_model.dart';

part 'booking_service.g.dart';

@RestApi()
abstract class BookingService {
  factory BookingService(Dio dio, {String? baseUrl}) = _BookingService;

  // Real-time Booking
  @POST('/bookings')
  Future<BookingModel> createBooking(@Header('Authorization') String token, @Body() CreateBookingRequest request);

  @GET('/bookings/{id}')
  Future<BookingModel> getBooking(@Header('Authorization') String token, @Path('id') String id);

  @GET('/bookings')
  Future<BookingListResponse> getBookings(
    @Header('Authorization') String token,
    @Queries() GetBookingsQuery query,
  );

  @PUT('/bookings/{id}')
  Future<BookingModel> updateBooking(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() UpdateBookingRequest request,
  );

  @DELETE('/bookings/{id}')
  Future<void> cancelBooking(@Header('Authorization') String token, @Path('id') String id, @Body() CancelBookingRequest request);

  // Real-time Stock Check
  @POST('/bookings/check-availability')
  Future<AvailabilityResponse> checkAvailability(@Body() AvailabilityRequest request);

  @POST('/bookings/hold-reservation')
  Future<ReservationHoldResponse> holdReservation(@Header('Authorization') String token, @Body() HoldReservationRequest request);

  @DELETE('/bookings/hold-reservation/{holdId}')
  Future<void> releaseReservation(@Header('Authorization') String token, @Path('holdId') String holdId);

  // Payment Processing
  @POST('/bookings/{id}/payment')
  Future<PaymentResponse> processPayment(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() PaymentRequest request,
  );

  @GET('/bookings/{id}/payment-status')
  Future<PaymentStatusResponse> getPaymentStatus(@Header('Authorization') String token, @Path('id') String id);

  @POST('/bookings/{id}/refund')
  Future<RefundResponse> processRefund(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() RefundRequest request,
  );

  // Traveler Management
  @PUT('/bookings/{id}/travelers')
  Future<BookingModel> updateTravelers(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() UpdateTravelersRequest request,
  );

  @POST('/bookings/{id}/travelers/{travelerId}/documents')
  Future<void> uploadTravelerDocument(
    @Header('Authorization') String token,
    @Path('id') String bookingId,
    @Path('travelerId') String travelerId,
    @Body() UploadDocumentRequest request,
  );

  // Booking Modifications
  @POST('/bookings/{id}/modify')
  Future<ModificationResponse> requestModification(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() ModificationRequest request,
  );

  @GET('/bookings/{id}/modifications')
  Future<List<BookingModification>> getModifications(@Header('Authorization') String token, @Path('id') String id);

  // Group Bookings
  @POST('/bookings/group')
  Future<GroupBookingResponse> createGroupBooking(@Header('Authorization') String token, @Body() CreateGroupBookingRequest request);

  @POST('/bookings/{id}/group-participants')
  Future<void> addGroupParticipants(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() AddParticipantsRequest request,
  );

  // Booking Reports
  @GET('/bookings/reports/summary')
  Future<BookingSummaryReport> getBookingSummary(
    @Header('Authorization') String token,
    @Queries() BookingReportQuery query,
  );

  @GET('/bookings/invoice/{id}')
  Future<Response> downloadInvoice(@Header('Authorization') String token, @Path('id') String id);
}

// Request/Response Models
@JsonSerializable()
class CreateBookingRequest {
  final String packageId;
  final DateTime travelStartDate;
  final DateTime travelEndDate;
  final List<TravelerInfo> travelers;
  final BookingType bookingType;
  final String? groupId;
  final List<String>? additionalServiceIds;
  final String? specialRequests;
  final List<String>? dietaryRequirements;
  final String? accessibilityNeeds;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String? promocode;

  const CreateBookingRequest({
    required this.packageId,
    required this.travelStartDate,
    required this.travelEndDate,
    required this.travelers,
    this.bookingType = BookingType.individual,
    this.groupId,
    this.additionalServiceIds,
    this.specialRequests,
    this.dietaryRequirements,
    this.accessibilityNeeds,
    this.emergencyContact,
    this.emergencyPhone,
    this.promocode,
  });

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateBookingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateBookingRequestToJson(this);
}

@JsonSerializable()
class UpdateBookingRequest {
  final List<TravelerInfo>? travelers;
  final String? specialRequests;
  final List<String>? dietaryRequirements;
  final String? accessibilityNeeds;
  final String? emergencyContact;
  final String? emergencyPhone;

  const UpdateBookingRequest({
    this.travelers,
    this.specialRequests,
    this.dietaryRequirements,
    this.accessibilityNeeds,
    this.emergencyContact,
    this.emergencyPhone,
  });

  factory UpdateBookingRequest.fromJson(Map<String, dynamic> json) => _$UpdateBookingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateBookingRequestToJson(this);
}

@JsonSerializable()
class CancelBookingRequest {
  final String reason;
  final bool requestRefund;

  const CancelBookingRequest({
    required this.reason,
    this.requestRefund = true,
  });

  factory CancelBookingRequest.fromJson(Map<String, dynamic> json) => _$CancelBookingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CancelBookingRequestToJson(this);
}

@JsonSerializable()
class GetBookingsQuery {
  final int? page;
  final int? limit;
  final BookingStatus? status;
  final BookingType? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? sortBy;
  final String? sortOrder;

  const GetBookingsQuery({
    this.page,
    this.limit,
    this.status,
    this.type,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() => _$GetBookingsQueryToJson(this);
}

@JsonSerializable()
class BookingListResponse {
  final List<BookingModel> bookings;
  final int totalCount;
  final int page;
  final int totalPages;

  const BookingListResponse({
    required this.bookings,
    required this.totalCount,
    required this.page,
    required this.totalPages,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) => _$BookingListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BookingListResponseToJson(this);
}

@JsonSerializable()
class AvailabilityRequest {
  final String packageId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfTravelers;
  final List<String>? additionalServiceIds;

  const AvailabilityRequest({
    required this.packageId,
    required this.startDate,
    required this.endDate,
    required this.numberOfTravelers,
    this.additionalServiceIds,
  });

  factory AvailabilityRequest.fromJson(Map<String, dynamic> json) => _$AvailabilityRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AvailabilityRequestToJson(this);
}

@JsonSerializable()
class AvailabilityResponse {
  final bool isAvailable;
  final int availableSlots;
  final double totalPrice;
  final String currency;
  final List<PriceBreakdown> priceBreakdown;
  final List<String> unavailableServices;
  final DateTime? nextAvailableDate;

  const AvailabilityResponse({
    required this.isAvailable,
    required this.availableSlots,
    required this.totalPrice,
    required this.currency,
    required this.priceBreakdown,
    required this.unavailableServices,
    this.nextAvailableDate,
  });

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) => _$AvailabilityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AvailabilityResponseToJson(this);
}

@JsonSerializable()
class HoldReservationRequest {
  final String packageId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfTravelers;
  final int holdMinutes;

  const HoldReservationRequest({
    required this.packageId,
    required this.startDate,
    required this.endDate,
    required this.numberOfTravelers,
    this.holdMinutes = 15,
  });

  factory HoldReservationRequest.fromJson(Map<String, dynamic> json) => _$HoldReservationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$HoldReservationRequestToJson(this);
}

@JsonSerializable()
class ReservationHoldResponse {
  final String holdId;
  final DateTime expiresAt;
  final double totalPrice;
  final String currency;

  const ReservationHoldResponse({
    required this.holdId,
    required this.expiresAt,
    required this.totalPrice,
    required this.currency,
  });

  factory ReservationHoldResponse.fromJson(Map<String, dynamic> json) => _$ReservationHoldResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationHoldResponseToJson(this);
}

@JsonSerializable()
class PaymentRequest {
  final String paymentMethod;
  final double amount;
  final String currency;
  final Map<String, dynamic> paymentData;
  final bool installmentPayment;
  final int? installmentMonths;

  const PaymentRequest({
    required this.paymentMethod,
    required this.amount,
    required this.currency,
    required this.paymentData,
    this.installmentPayment = false,
    this.installmentMonths,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

@JsonSerializable()
class PaymentResponse {
  final String transactionId;
  final PaymentStatus status;
  final String? redirectUrl;
  final String? errorMessage;
  final Map<String, dynamic>? additionalData;

  const PaymentResponse({
    required this.transactionId,
    required this.status,
    this.redirectUrl,
    this.errorMessage,
    this.additionalData,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => _$PaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}

@JsonSerializable()
class PaymentStatusResponse {
  final PaymentStatus status;
  final List<PaymentTransaction> transactions;
  final double totalPaid;
  final double remainingAmount;
  final String currency;

  const PaymentStatusResponse({
    required this.status,
    required this.transactions,
    required this.totalPaid,
    required this.remainingAmount,
    required this.currency,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) => _$PaymentStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentStatusResponseToJson(this);
}

@JsonSerializable()
class RefundRequest {
  final String reason;
  final double? amount;
  final bool fullRefund;

  const RefundRequest({
    required this.reason,
    this.amount,
    this.fullRefund = true,
  });

  factory RefundRequest.fromJson(Map<String, dynamic> json) => _$RefundRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RefundRequestToJson(this);
}

@JsonSerializable()
class RefundResponse {
  final String refundId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String? estimatedProcessingTime;

  const RefundResponse({
    required this.refundId,
    required this.amount,
    required this.currency,
    required this.status,
    this.estimatedProcessingTime,
  });

  factory RefundResponse.fromJson(Map<String, dynamic> json) => _$RefundResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefundResponseToJson(this);
}

@JsonSerializable()
class UpdateTravelersRequest {
  final List<TravelerInfo> travelers;

  const UpdateTravelersRequest({required this.travelers});

  factory UpdateTravelersRequest.fromJson(Map<String, dynamic> json) => _$UpdateTravelersRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateTravelersRequestToJson(this);
}

@JsonSerializable()
class UploadDocumentRequest {
  final String documentType;
  final String fileName;
  final String fileUrl;
  final String mimeType;

  const UploadDocumentRequest({
    required this.documentType,
    required this.fileName,
    required this.fileUrl,
    required this.mimeType,
  });

  factory UploadDocumentRequest.fromJson(Map<String, dynamic> json) => _$UploadDocumentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UploadDocumentRequestToJson(this);
}

@JsonSerializable()
class ModificationRequest {
  final String type; // 'date_change', 'traveler_change', 'service_addition', etc.
  final Map<String, dynamic> modifications;
  final String reason;

  const ModificationRequest({
    required this.type,
    required this.modifications,
    required this.reason,
  });

  factory ModificationRequest.fromJson(Map<String, dynamic> json) => _$ModificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ModificationRequestToJson(this);
}

@JsonSerializable()
class ModificationResponse {
  final String modificationId;
  final String status;
  final double? additionalCost;
  final String? approvalRequired;
  final String message;

  const ModificationResponse({
    required this.modificationId,
    required this.status,
    this.additionalCost,
    this.approvalRequired,
    required this.message,
  });

  factory ModificationResponse.fromJson(Map<String, dynamic> json) => _$ModificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ModificationResponseToJson(this);
}

@JsonSerializable()
class BookingModification {
  final String id;
  final String type;
  final String status;
  final Map<String, dynamic> originalData;
  final Map<String, dynamic> modifiedData;
  final double? additionalCost;
  final String? reason;
  final DateTime requestedAt;
  final DateTime? approvedAt;

  const BookingModification({
    required this.id,
    required this.type,
    required this.status,
    required this.originalData,
    required this.modifiedData,
    this.additionalCost,
    this.reason,
    required this.requestedAt,
    this.approvedAt,
  });

  factory BookingModification.fromJson(Map<String, dynamic> json) => _$BookingModificationFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModificationToJson(this);
}

@JsonSerializable()
class CreateGroupBookingRequest {
  final String groupId;
  final String packageId;
  final DateTime travelStartDate;
  final DateTime travelEndDate;
  final List<String> participantIds;
  final Map<String, dynamic>? groupSettings;

  const CreateGroupBookingRequest({
    required this.groupId,
    required this.packageId,
    required this.travelStartDate,
    required this.travelEndDate,
    required this.participantIds,
    this.groupSettings,
  });

  factory CreateGroupBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateGroupBookingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateGroupBookingRequestToJson(this);
}

@JsonSerializable()
class GroupBookingResponse {
  final String bookingId;
  final String groupId;
  final List<String> individualBookingIds;
  final double totalAmount;
  final String currency;

  const GroupBookingResponse({
    required this.bookingId,
    required this.groupId,
    required this.individualBookingIds,
    required this.totalAmount,
    required this.currency,
  });

  factory GroupBookingResponse.fromJson(Map<String, dynamic> json) => _$GroupBookingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GroupBookingResponseToJson(this);
}

@JsonSerializable()
class AddParticipantsRequest {
  final List<String> participantIds;

  const AddParticipantsRequest({required this.participantIds});

  factory AddParticipantsRequest.fromJson(Map<String, dynamic> json) => _$AddParticipantsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddParticipantsRequestToJson(this);
}

@JsonSerializable()
class BookingReportQuery {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? groupBy;
  final List<String>? metrics;

  const BookingReportQuery({
    this.startDate,
    this.endDate,
    this.groupBy,
    this.metrics,
  });

  Map<String, dynamic> toJson() => _$BookingReportQueryToJson(this);
}

@JsonSerializable()
class BookingSummaryReport {
  final int totalBookings;
  final double totalRevenue;
  final String currency;
  final Map<String, int> bookingsByStatus;
  final Map<String, double> revenueByMonth;
  final List<TopDestination> topDestinations;

  const BookingSummaryReport({
    required this.totalBookings,
    required this.totalRevenue,
    required this.currency,
    required this.bookingsByStatus,
    required this.revenueByMonth,
    required this.topDestinations,
  });

  factory BookingSummaryReport.fromJson(Map<String, dynamic> json) => _$BookingSummaryReportFromJson(json);
  Map<String, dynamic> toJson() => _$BookingSummaryReportToJson(this);
}

@JsonSerializable()
class TopDestination {
  final String destination;
  final int bookingCount;
  final double revenue;

  const TopDestination({
    required this.destination,
    required this.bookingCount,
    required this.revenue,
  });

  factory TopDestination.fromJson(Map<String, dynamic> json) => _$TopDestinationFromJson(json);
  Map<String, dynamic> toJson() => _$TopDestinationToJson(this);
}