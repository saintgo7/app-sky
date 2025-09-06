// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBookingRequest _$CreateBookingRequestFromJson(
        Map<String, dynamic> json) =>
    CreateBookingRequest(
      packageId: json['packageId'] as String,
      travelStartDate: DateTime.parse(json['travelStartDate'] as String),
      travelEndDate: DateTime.parse(json['travelEndDate'] as String),
      travelers: (json['travelers'] as List<dynamic>)
          .map((e) => TravelerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookingType:
          $enumDecodeNullable(_$BookingTypeEnumMap, json['bookingType']) ??
              BookingType.individual,
      groupId: json['groupId'] as String?,
      additionalServiceIds: (json['additionalServiceIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specialRequests: json['specialRequests'] as String?,
      dietaryRequirements: (json['dietaryRequirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accessibilityNeeds: json['accessibilityNeeds'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
      promocode: json['promocode'] as String?,
    );

Map<String, dynamic> _$CreateBookingRequestToJson(
        CreateBookingRequest instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'travelStartDate': instance.travelStartDate.toIso8601String(),
      'travelEndDate': instance.travelEndDate.toIso8601String(),
      'travelers': instance.travelers,
      'bookingType': _$BookingTypeEnumMap[instance.bookingType]!,
      'groupId': instance.groupId,
      'additionalServiceIds': instance.additionalServiceIds,
      'specialRequests': instance.specialRequests,
      'dietaryRequirements': instance.dietaryRequirements,
      'accessibilityNeeds': instance.accessibilityNeeds,
      'emergencyContact': instance.emergencyContact,
      'emergencyPhone': instance.emergencyPhone,
      'promocode': instance.promocode,
    };

const _$BookingTypeEnumMap = {
  BookingType.individual: 'individual',
  BookingType.group: 'group',
  BookingType.corporate: 'corporate',
};

UpdateBookingRequest _$UpdateBookingRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateBookingRequest(
      travelers: (json['travelers'] as List<dynamic>?)
          ?.map((e) => TravelerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialRequests: json['specialRequests'] as String?,
      dietaryRequirements: (json['dietaryRequirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accessibilityNeeds: json['accessibilityNeeds'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
    );

Map<String, dynamic> _$UpdateBookingRequestToJson(
        UpdateBookingRequest instance) =>
    <String, dynamic>{
      'travelers': instance.travelers,
      'specialRequests': instance.specialRequests,
      'dietaryRequirements': instance.dietaryRequirements,
      'accessibilityNeeds': instance.accessibilityNeeds,
      'emergencyContact': instance.emergencyContact,
      'emergencyPhone': instance.emergencyPhone,
    };

CancelBookingRequest _$CancelBookingRequestFromJson(
        Map<String, dynamic> json) =>
    CancelBookingRequest(
      reason: json['reason'] as String,
      requestRefund: json['requestRefund'] as bool? ?? true,
    );

Map<String, dynamic> _$CancelBookingRequestToJson(
        CancelBookingRequest instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'requestRefund': instance.requestRefund,
    };

GetBookingsQuery _$GetBookingsQueryFromJson(Map<String, dynamic> json) =>
    GetBookingsQuery(
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$BookingStatusEnumMap, json['status']),
      type: $enumDecodeNullable(_$BookingTypeEnumMap, json['type']),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
    );

Map<String, dynamic> _$GetBookingsQueryToJson(GetBookingsQuery instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'status': _$BookingStatusEnumMap[instance.status],
      'type': _$BookingTypeEnumMap[instance.type],
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.paid: 'paid',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.completed: 'completed',
  BookingStatus.refunded: 'refunded',
};

BookingListResponse _$BookingListResponseFromJson(Map<String, dynamic> json) =>
    BookingListResponse(
      bookings: (json['bookings'] as List<dynamic>)
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$BookingListResponseToJson(
        BookingListResponse instance) =>
    <String, dynamic>{
      'bookings': instance.bookings,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'totalPages': instance.totalPages,
    };

AvailabilityRequest _$AvailabilityRequestFromJson(Map<String, dynamic> json) =>
    AvailabilityRequest(
      packageId: json['packageId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      numberOfTravelers: (json['numberOfTravelers'] as num).toInt(),
      additionalServiceIds: (json['additionalServiceIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AvailabilityRequestToJson(
        AvailabilityRequest instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'numberOfTravelers': instance.numberOfTravelers,
      'additionalServiceIds': instance.additionalServiceIds,
    };

AvailabilityResponse _$AvailabilityResponseFromJson(
        Map<String, dynamic> json) =>
    AvailabilityResponse(
      isAvailable: json['isAvailable'] as bool,
      availableSlots: (json['availableSlots'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      priceBreakdown: (json['priceBreakdown'] as List<dynamic>)
          .map((e) => PriceBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
      unavailableServices: (json['unavailableServices'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nextAvailableDate: json['nextAvailableDate'] == null
          ? null
          : DateTime.parse(json['nextAvailableDate'] as String),
    );

Map<String, dynamic> _$AvailabilityResponseToJson(
        AvailabilityResponse instance) =>
    <String, dynamic>{
      'isAvailable': instance.isAvailable,
      'availableSlots': instance.availableSlots,
      'totalPrice': instance.totalPrice,
      'currency': instance.currency,
      'priceBreakdown': instance.priceBreakdown,
      'unavailableServices': instance.unavailableServices,
      'nextAvailableDate': instance.nextAvailableDate?.toIso8601String(),
    };

HoldReservationRequest _$HoldReservationRequestFromJson(
        Map<String, dynamic> json) =>
    HoldReservationRequest(
      packageId: json['packageId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      numberOfTravelers: (json['numberOfTravelers'] as num).toInt(),
      holdMinutes: (json['holdMinutes'] as num?)?.toInt() ?? 15,
    );

Map<String, dynamic> _$HoldReservationRequestToJson(
        HoldReservationRequest instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'numberOfTravelers': instance.numberOfTravelers,
      'holdMinutes': instance.holdMinutes,
    };

ReservationHoldResponse _$ReservationHoldResponseFromJson(
        Map<String, dynamic> json) =>
    ReservationHoldResponse(
      holdId: json['holdId'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$ReservationHoldResponseToJson(
        ReservationHoldResponse instance) =>
    <String, dynamic>{
      'holdId': instance.holdId,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'currency': instance.currency,
    };

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      paymentMethod: json['paymentMethod'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentData: json['paymentData'] as Map<String, dynamic>,
      installmentPayment: json['installmentPayment'] as bool? ?? false,
      installmentMonths: (json['installmentMonths'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'paymentMethod': instance.paymentMethod,
      'amount': instance.amount,
      'currency': instance.currency,
      'paymentData': instance.paymentData,
      'installmentPayment': instance.installmentPayment,
      'installmentMonths': instance.installmentMonths,
    };

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      transactionId: json['transactionId'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      redirectUrl: json['redirectUrl'] as String?,
      errorMessage: json['errorMessage'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'redirectUrl': instance.redirectUrl,
      'errorMessage': instance.errorMessage,
      'additionalData': instance.additionalData,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.partialRefund: 'partialRefund',
};

PaymentStatusResponse _$PaymentStatusResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentStatusResponse(
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => PaymentTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPaid: (json['totalPaid'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PaymentStatusResponseToJson(
        PaymentStatusResponse instance) =>
    <String, dynamic>{
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'transactions': instance.transactions,
      'totalPaid': instance.totalPaid,
      'remainingAmount': instance.remainingAmount,
      'currency': instance.currency,
    };

RefundRequest _$RefundRequestFromJson(Map<String, dynamic> json) =>
    RefundRequest(
      reason: json['reason'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      fullRefund: json['fullRefund'] as bool? ?? true,
    );

Map<String, dynamic> _$RefundRequestToJson(RefundRequest instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'amount': instance.amount,
      'fullRefund': instance.fullRefund,
    };

RefundResponse _$RefundResponseFromJson(Map<String, dynamic> json) =>
    RefundResponse(
      refundId: json['refundId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      estimatedProcessingTime: json['estimatedProcessingTime'] as String?,
    );

Map<String, dynamic> _$RefundResponseToJson(RefundResponse instance) =>
    <String, dynamic>{
      'refundId': instance.refundId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'estimatedProcessingTime': instance.estimatedProcessingTime,
    };

UpdateTravelersRequest _$UpdateTravelersRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateTravelersRequest(
      travelers: (json['travelers'] as List<dynamic>)
          .map((e) => TravelerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdateTravelersRequestToJson(
        UpdateTravelersRequest instance) =>
    <String, dynamic>{
      'travelers': instance.travelers,
    };

UploadDocumentRequest _$UploadDocumentRequestFromJson(
        Map<String, dynamic> json) =>
    UploadDocumentRequest(
      documentType: json['documentType'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      mimeType: json['mimeType'] as String,
    );

Map<String, dynamic> _$UploadDocumentRequestToJson(
        UploadDocumentRequest instance) =>
    <String, dynamic>{
      'documentType': instance.documentType,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'mimeType': instance.mimeType,
    };

ModificationRequest _$ModificationRequestFromJson(Map<String, dynamic> json) =>
    ModificationRequest(
      type: json['type'] as String,
      modifications: json['modifications'] as Map<String, dynamic>,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$ModificationRequestToJson(
        ModificationRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'modifications': instance.modifications,
      'reason': instance.reason,
    };

ModificationResponse _$ModificationResponseFromJson(
        Map<String, dynamic> json) =>
    ModificationResponse(
      modificationId: json['modificationId'] as String,
      status: json['status'] as String,
      additionalCost: (json['additionalCost'] as num?)?.toDouble(),
      approvalRequired: json['approvalRequired'] as String?,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ModificationResponseToJson(
        ModificationResponse instance) =>
    <String, dynamic>{
      'modificationId': instance.modificationId,
      'status': instance.status,
      'additionalCost': instance.additionalCost,
      'approvalRequired': instance.approvalRequired,
      'message': instance.message,
    };

BookingModification _$BookingModificationFromJson(Map<String, dynamic> json) =>
    BookingModification(
      id: json['id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      originalData: json['originalData'] as Map<String, dynamic>,
      modifiedData: json['modifiedData'] as Map<String, dynamic>,
      additionalCost: (json['additionalCost'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
    );

Map<String, dynamic> _$BookingModificationToJson(
        BookingModification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'status': instance.status,
      'originalData': instance.originalData,
      'modifiedData': instance.modifiedData,
      'additionalCost': instance.additionalCost,
      'reason': instance.reason,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'approvedAt': instance.approvedAt?.toIso8601String(),
    };

CreateGroupBookingRequest _$CreateGroupBookingRequestFromJson(
        Map<String, dynamic> json) =>
    CreateGroupBookingRequest(
      groupId: json['groupId'] as String,
      packageId: json['packageId'] as String,
      travelStartDate: DateTime.parse(json['travelStartDate'] as String),
      travelEndDate: DateTime.parse(json['travelEndDate'] as String),
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      groupSettings: json['groupSettings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CreateGroupBookingRequestToJson(
        CreateGroupBookingRequest instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'packageId': instance.packageId,
      'travelStartDate': instance.travelStartDate.toIso8601String(),
      'travelEndDate': instance.travelEndDate.toIso8601String(),
      'participantIds': instance.participantIds,
      'groupSettings': instance.groupSettings,
    };

GroupBookingResponse _$GroupBookingResponseFromJson(
        Map<String, dynamic> json) =>
    GroupBookingResponse(
      bookingId: json['bookingId'] as String,
      groupId: json['groupId'] as String,
      individualBookingIds: (json['individualBookingIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$GroupBookingResponseToJson(
        GroupBookingResponse instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'groupId': instance.groupId,
      'individualBookingIds': instance.individualBookingIds,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
    };

AddParticipantsRequest _$AddParticipantsRequestFromJson(
        Map<String, dynamic> json) =>
    AddParticipantsRequest(
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AddParticipantsRequestToJson(
        AddParticipantsRequest instance) =>
    <String, dynamic>{
      'participantIds': instance.participantIds,
    };

BookingReportQuery _$BookingReportQueryFromJson(Map<String, dynamic> json) =>
    BookingReportQuery(
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      groupBy: json['groupBy'] as String?,
      metrics:
          (json['metrics'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BookingReportQueryToJson(BookingReportQuery instance) =>
    <String, dynamic>{
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'groupBy': instance.groupBy,
      'metrics': instance.metrics,
    };

BookingSummaryReport _$BookingSummaryReportFromJson(
        Map<String, dynamic> json) =>
    BookingSummaryReport(
      totalBookings: (json['totalBookings'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      currency: json['currency'] as String,
      bookingsByStatus: Map<String, int>.from(json['bookingsByStatus'] as Map),
      revenueByMonth: (json['revenueByMonth'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      topDestinations: (json['topDestinations'] as List<dynamic>)
          .map((e) => TopDestination.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookingSummaryReportToJson(
        BookingSummaryReport instance) =>
    <String, dynamic>{
      'totalBookings': instance.totalBookings,
      'totalRevenue': instance.totalRevenue,
      'currency': instance.currency,
      'bookingsByStatus': instance.bookingsByStatus,
      'revenueByMonth': instance.revenueByMonth,
      'topDestinations': instance.topDestinations,
    };

TopDestination _$TopDestinationFromJson(Map<String, dynamic> json) =>
    TopDestination(
      destination: json['destination'] as String,
      bookingCount: (json['bookingCount'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$TopDestinationToJson(TopDestination instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'bookingCount': instance.bookingCount,
      'revenue': instance.revenue,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _BookingService implements BookingService {
  _BookingService(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<BookingModel> createBooking(
    String token,
    CreateBookingRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BookingModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BookingModel _value;
    try {
      _value = BookingModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BookingModel> getBooking(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BookingModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BookingModel _value;
    try {
      _value = BookingModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BookingListResponse> getBookings(
    String token,
    GetBookingsQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BookingListResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BookingListResponse _value;
    try {
      _value = BookingListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BookingModel> updateBooking(
    String token,
    String id,
    UpdateBookingRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BookingModel>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BookingModel _value;
    try {
      _value = BookingModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> cancelBooking(
    String token,
    String id,
    CancelBookingRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<void>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<AvailabilityResponse> checkAvailability(
      AvailabilityRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<AvailabilityResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/check-availability',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AvailabilityResponse _value;
    try {
      _value = AvailabilityResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ReservationHoldResponse> holdReservation(
    String token,
    HoldReservationRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<ReservationHoldResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/hold-reservation',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ReservationHoldResponse _value;
    try {
      _value = ReservationHoldResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> releaseReservation(
    String token,
    String holdId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/hold-reservation/${holdId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<PaymentResponse> processPayment(
    String token,
    String id,
    PaymentRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<PaymentResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}/payment',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PaymentResponse _value;
    try {
      _value = PaymentResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PaymentStatusResponse> getPaymentStatus(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PaymentStatusResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}/payment-status',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PaymentStatusResponse _value;
    try {
      _value = PaymentStatusResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RefundResponse> processRefund(
    String token,
    String id,
    RefundRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<RefundResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}/refund',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RefundResponse _value;
    try {
      _value = RefundResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BookingModel> updateTravelers(
    String token,
    String id,
    UpdateTravelersRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BookingModel>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}/travelers',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BookingModel _value;
    try {
      _value = BookingModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> uploadTravelerDocument(
    String token,
    String bookingId,
    String travelerId,
    UploadDocumentRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${bookingId}/travelers/${travelerId}/documents',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<ModificationResponse> requestModification(
    String token,
    String id,
    ModificationRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<ModificationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}/modify',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ModificationResponse _value;
    try {
      _value = ModificationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<BookingModification>> getModifications(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<BookingModification>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}/modifications',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<BookingModification> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              BookingModification.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GroupBookingResponse> createGroupBooking(
    String token,
    CreateGroupBookingRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<GroupBookingResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/group',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GroupBookingResponse _value;
    try {
      _value = GroupBookingResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> addGroupParticipants(
    String token,
    String id,
    AddParticipantsRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/${id}/group-participants',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    await _dio.fetch<void>(_options);
  }

  @override
  Future<BookingSummaryReport> getBookingSummary(
    String token,
    BookingReportQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BookingSummaryReport>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/reports/summary',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BookingSummaryReport _value;
    try {
      _value = BookingSummaryReport.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Response<dynamic>> downloadInvoice(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/bookings/invoice/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Response<dynamic> _value;
    try {
      _value = Response<dynamic>.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
