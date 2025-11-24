import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/booking_models.dart';
import 'base_api_client.dart';

part 'booking_api_service.g.dart';

@RestApi()
abstract class BookingApiService {
  factory BookingApiService(Dio dio, {String baseUrl}) = _BookingApiService;

  static BookingApiService create() {
    return BookingApiService(BaseApiClient().dio);
  }

  // Bookings
  @GET('/bookings')
  Future<BookingListResponse> getBookings({
    @Header('Authorization') required String token,
    @Query('status') String? status,
    @Query('type') String? type,
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
  });

  @GET('/bookings/{id}')
  Future<BookingDetailResponse> getBookingDetails(
    @Header('Authorization') required String token,
    @Path('id') String id,
  );

  @POST('/bookings')
  Future<BookingResponse> createBooking(
    @Header('Authorization') required String token,
    @Body() CreateBookingRequest request,
  );

  @PUT('/bookings/{id}')
  Future<BookingResponse> updateBooking(
    @Header('Authorization') required String token,
    @Path('id') String id,
    @Body() UpdateBookingRequest request,
  );

  @DELETE('/bookings/{id}')
  Future<ApiResponse> cancelBooking(
    @Header('Authorization') required String token,
    @Path('id') String id,
    @Body() CancelBookingRequest request,
  );

  // Payment
  @POST('/bookings/{id}/payment')
  Future<PaymentResponse> initiatePayment(
    @Header('Authorization') required String token,
    @Path('id') String id,
    @Body() PaymentRequest request,
  );

  @GET('/bookings/{id}/payment/status')
  Future<PaymentStatusResponse> getPaymentStatus(
    @Header('Authorization') required String token,
    @Path('id') String id,
  );

  @POST('/payments/webhook')
  Future<ApiResponse> paymentWebhook(@Body() WebhookRequest request);

  // Travelers
  @GET('/bookings/{id}/travelers')
  Future<TravelerListResponse> getBookingTravelers(
    @Header('Authorization') required String token,
    @Path('id') String id,
  );

  @POST('/bookings/{id}/travelers')
  Future<TravelerResponse> addTraveler(
    @Header('Authorization') required String token,
    @Path('id') String id,
    @Body() AddTravelerRequest request,
  );

  @PUT('/bookings/{id}/travelers/{travelerId}')
  Future<TravelerResponse> updateTraveler(
    @Header('Authorization') required String token,
    @Path('id') String id,
    @Path('travelerId') String travelerId,
    @Body() UpdateTravelerRequest request,
  );

  @DELETE('/bookings/{id}/travelers/{travelerId}')
  Future<ApiResponse> removeTraveler(
    @Header('Authorization') required String token,
    @Path('id') String id,
    @Path('travelerId') String travelerId,
  );

  // Special Requests
  @POST('/bookings/{id}/special-requests')
  Future<ApiResponse> addSpecialRequest(
    @Header('Authorization') required String token,
    @Path('id') String id,
    @Body() SpecialRequestRequest request,
  );

  @GET('/bookings/{id}/special-requests')
  Future<SpecialRequestListResponse> getSpecialRequests(
    @Header('Authorization') required String token,
    @Path('id') String id,
  );

  // Cancellation Policy
  @GET('/bookings/{id}/cancellation-policy')
  Future<CancellationPolicyResponse> getCancellationPolicy(
    @Header('Authorization') required String token,
    @Path('id') String id,
  );

  // Booking History
  @GET('/bookings/history')
  Future<BookingHistoryResponse> getBookingHistory({
    @Header('Authorization') required String token,
    @Query('limit') int limit = 50,
    @Query('offset') int offset = 0,
  });
}

// Request Models
class CreateBookingRequest {
  final String type;
  final String itemId;
  final String itemType;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guestCount;
  final List<String> specialRequests;
  final ContactPersonRequest contactPerson;
  final List<TravelerRequest> travelers;
  final PaymentRequest payment;

  CreateBookingRequest({
    required this.type,
    required this.itemId,
    required this.itemType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guestCount,
    required this.specialRequests,
    required this.contactPerson,
    required this.travelers,
    required this.payment,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'item_id': itemId,
    'item_type': itemType,
    'check_in_date': checkInDate.toIso8601String(),
    'check_out_date': checkOutDate.toIso8601String(),
    'guest_count': guestCount,
    'special_requests': specialRequests,
    'contact_person': contactPerson.toJson(),
    'travelers': travelers.map((t) => t.toJson()).toList(),
    'payment': payment.toJson(),
  };
}

class UpdateBookingRequest {
  final List<String>? specialRequests;
  final ContactPersonRequest? contactPerson;
  final List<TravelerRequest>? travelers;

  UpdateBookingRequest({
    this.specialRequests,
    this.contactPerson,
    this.travelers,
  });

  Map<String, dynamic> toJson() => {
    if (specialRequests != null) 'special_requests': specialRequests,
    if (contactPerson != null) 'contact_person': contactPerson!.toJson(),
    if (travelers != null) 'travelers': travelers!.map((t) => t.toJson()).toList(),
  };
}

class CancelBookingRequest {
  final String reason;
  final String? notes;

  CancelBookingRequest({
    required this.reason,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'reason': reason,
    if (notes != null) 'notes': notes,
  };
}

class PaymentRequest {
  final String method;
  final String currency;
  final double amount;
  final Map<String, dynamic>? metadata;

  PaymentRequest({
    required this.method,
    required this.currency,
    required this.amount,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'method': method,
    'currency': currency,
    'amount': amount,
    if (metadata != null) 'metadata': metadata,
  };
}

class ContactPersonRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String country;

  ContactPersonRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'country': country,
  };
}

class TravelerRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final String nationality;
  final String passportNumber;
  final DateTime passportExpiry;
  final String? specialRequests;

  TravelerRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.nationality,
    required this.passportNumber,
    required this.passportExpiry,
    this.specialRequests,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'nationality': nationality,
    'passport_number': passportNumber,
    'passport_expiry': passportExpiry.toIso8601String(),
    if (specialRequests != null) 'special_requests': specialRequests,
  };
}

class AddTravelerRequest extends TravelerRequest {
  AddTravelerRequest({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.dateOfBirth,
    required super.nationality,
    required super.passportNumber,
    required super.passportExpiry,
    super.specialRequests,
  });
}

class UpdateTravelerRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? passportNumber;
  final DateTime? passportExpiry;
  final String? specialRequests;

  UpdateTravelerRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.nationality,
    this.passportNumber,
    this.passportExpiry,
    this.specialRequests,
  });

  Map<String, dynamic> toJson() => {
    if (firstName != null) 'first_name': firstName,
    if (lastName != null) 'last_name': lastName,
    if (email != null) 'email': email,
    if (phoneNumber != null) 'phone_number': phoneNumber,
    if (dateOfBirth != null) 'date_of_birth': dateOfBirth!.toIso8601String(),
    if (nationality != null) 'nationality': nationality,
    if (passportNumber != null) 'passport_number': passportNumber,
    if (passportExpiry != null) 'passport_expiry': passportExpiry!.toIso8601String(),
    if (specialRequests != null) 'special_requests': specialRequests,
  };
}

class SpecialRequestRequest {
  final String request;
  final String type;

  SpecialRequestRequest({
    required this.request,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'request': request,
    'type': type,
  };
}

class WebhookRequest {
  final String eventType;
  final Map<String, dynamic> data;
  final String signature;

  WebhookRequest({
    required this.eventType,
    required this.data,
    required this.signature,
  });

  Map<String, dynamic> toJson() => {
    'event_type': eventType,
    'data': data,
    'signature': signature,
  };
}
