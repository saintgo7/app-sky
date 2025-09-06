import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_service.g.dart';

enum PaymentMethod { creditCard, debitCard, bankTransfer, digitalWallet, cryptocurrency }
enum PaymentProvider { iamport, bootpay, stripe, paypal }

@RestApi()
abstract class PaymentService {
  factory PaymentService(Dio dio, {String? baseUrl}) = _PaymentService;

  // Payment Processing
  @POST('/payments/process')
  Future<PaymentResponse> processPayment(@Header('Authorization') String token, @Body() PaymentRequest request);

  @GET('/payments/{id}')
  Future<PaymentDetailsResponse> getPayment(@Header('Authorization') String token, @Path('id') String id);

  @GET('/payments/{id}/status')
  Future<PaymentStatusResponse> getPaymentStatus(@Header('Authorization') String token, @Path('id') String id);

  @POST('/payments/{id}/cancel')
  Future<PaymentCancellationResponse> cancelPayment(
    @Header('Authorization') String token,
    @Path('id') String id,
    @Body() CancelPaymentRequest request,
  );

  // Multi-Payment Methods
  @POST('/payments/methods/add')
  Future<PaymentMethodResponse> addPaymentMethod(
    @Header('Authorization') String token,
    @Body() AddPaymentMethodRequest request,
  );

  @GET('/payments/methods')
  Future<List<StoredPaymentMethod>> getPaymentMethods(@Header('Authorization') String token);

  @DELETE('/payments/methods/{id}')
  Future<void> removePaymentMethod(@Header('Authorization') String token, @Path('id') String id);

  @PUT('/payments/methods/{id}/default')
  Future<StoredPaymentMethod> setDefaultPaymentMethod(@Header('Authorization') String token, @Path('id') String id);

  // Installment Payments
  @POST('/payments/installment/calculate')
  Future<InstallmentCalculationResponse> calculateInstallment(@Body() InstallmentCalculationRequest request);

  @POST('/payments/installment/setup')
  Future<InstallmentSetupResponse> setupInstallmentPayment(
    @Header('Authorization') String token,
    @Body() InstallmentSetupRequest request,
  );

  @GET('/payments/installment/{id}')
  Future<InstallmentDetails> getInstallmentDetails(@Header('Authorization') String token, @Path('id') String id);

  @GET('/payments/installment/{id}/schedule')
  Future<List<InstallmentSchedule>> getInstallmentSchedule(@Header('Authorization') String token, @Path('id') String id);

  @POST('/payments/installment/{id}/pay')
  Future<InstallmentPaymentResponse> payInstallment(
    @Header('Authorization') String token,
    @Path('id') String installmentId,
    @Body() InstallmentPaymentRequest request,
  );

  // Refunds
  @POST('/payments/{id}/refund')
  Future<RefundResponse> processRefund(
    @Header('Authorization') String token,
    @Path('id') String paymentId,
    @Body() RefundRequest request,
  );

  @GET('/payments/{id}/refunds')
  Future<List<RefundDetails>> getRefunds(@Header('Authorization') String token, @Path('id') String paymentId);

  @GET('/refunds/{id}')
  Future<RefundDetails> getRefund(@Header('Authorization') String token, @Path('id') String refundId);

  // Payment Verification
  @POST('/payments/verify')
  Future<PaymentVerificationResponse> verifyPayment(@Body() PaymentVerificationRequest request);

  @POST('/payments/webhook/{provider}')
  Future<WebhookResponse> handleWebhook(@Path('provider') String provider, @Body() Map<String, dynamic> payload);

  // Payment Analytics
  @GET('/payments/analytics/summary')
  Future<PaymentAnalyticsSummary> getPaymentAnalytics(
    @Header('Authorization') String token,
    @Queries() PaymentAnalyticsQuery query,
  );

  @GET('/payments/analytics/transactions')
  Future<TransactionAnalyticsResponse> getTransactionAnalytics(
    @Header('Authorization') String token,
    @Queries() TransactionAnalyticsQuery query,
  );

  // Currency and Exchange
  @GET('/payments/currencies')
  Future<List<SupportedCurrency>> getSupportedCurrencies();

  @GET('/payments/exchange-rates')
  Future<ExchangeRatesResponse> getExchangeRates(@Queries() ExchangeRateQuery query);

  @POST('/payments/currency/convert')
  Future<CurrencyConversionResponse> convertCurrency(@Body() CurrencyConversionRequest request);

  // Split Payments
  @POST('/payments/split/setup')
  Future<SplitPaymentSetup> setupSplitPayment(
    @Header('Authorization') String token,
    @Body() SplitPaymentSetupRequest request,
  );

  @GET('/payments/split/{id}')
  Future<SplitPaymentDetails> getSplitPaymentDetails(@Header('Authorization') String token, @Path('id') String id);

  @POST('/payments/split/{id}/pay')
  Future<SplitPaymentResponse> paySplitPayment(
    @Header('Authorization') String token,
    @Path('id') String splitPaymentId,
    @Body() SplitPaymentRequest request,
  );

  // Recurring Payments
  @POST('/payments/recurring/setup')
  Future<RecurringPaymentSetup> setupRecurringPayment(
    @Header('Authorization') String token,
    @Body() RecurringPaymentSetupRequest request,
  );

  @GET('/payments/recurring')
  Future<List<RecurringPaymentDetails>> getRecurringPayments(@Header('Authorization') String token);

  @PUT('/payments/recurring/{id}/pause')
  Future<RecurringPaymentDetails> pauseRecurringPayment(@Header('Authorization') String token, @Path('id') String id);

  @PUT('/payments/recurring/{id}/resume')
  Future<RecurringPaymentDetails> resumeRecurringPayment(@Header('Authorization') String token, @Path('id') String id);

  @DELETE('/payments/recurring/{id}')
  Future<void> cancelRecurringPayment(@Header('Authorization') String token, @Path('id') String id);
}

// Core Request Models
@JsonSerializable()
class PaymentRequest {
  final String orderId;
  final double amount;
  final String currency;
  final PaymentMethod paymentMethod;
  final PaymentProvider provider;
  final Map<String, dynamic> paymentData;
  final String? description;
  final String? customerEmail;
  final String? customerPhone;
  final BillingAddress? billingAddress;
  final bool savePaymentMethod;
  final String? successUrl;
  final String? failureUrl;
  final String? cancelUrl;
  final Map<String, dynamic>? metadata;

  const PaymentRequest({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.provider,
    required this.paymentData,
    this.description,
    this.customerEmail,
    this.customerPhone,
    this.billingAddress,
    this.savePaymentMethod = false,
    this.successUrl,
    this.failureUrl,
    this.cancelUrl,
    this.metadata,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

@JsonSerializable()
class BillingAddress {
  final String name;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const BillingAddress({
    required this.name,
    required this.address1,
    this.address2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) => _$BillingAddressFromJson(json);
  Map<String, dynamic> toJson() => _$BillingAddressToJson(this);
}

@JsonSerializable()
class CancelPaymentRequest {
  final String reason;
  final bool requestRefund;

  const CancelPaymentRequest({
    required this.reason,
    this.requestRefund = false,
  });

  factory CancelPaymentRequest.fromJson(Map<String, dynamic> json) => _$CancelPaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CancelPaymentRequestToJson(this);
}

// Response Models
@JsonSerializable()
class PaymentResponse {
  final String paymentId;
  final String status;
  final String? redirectUrl;
  final String? qrCode;
  final String? deepLink;
  final PaymentProvider provider;
  final String providerTransactionId;
  final DateTime createdAt;
  final String? errorCode;
  final String? errorMessage;
  final Map<String, dynamic>? additionalData;

  const PaymentResponse({
    required this.paymentId,
    required this.status,
    this.redirectUrl,
    this.qrCode,
    this.deepLink,
    required this.provider,
    required this.providerTransactionId,
    required this.createdAt,
    this.errorCode,
    this.errorMessage,
    this.additionalData,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => _$PaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}

@JsonSerializable()
class PaymentDetailsResponse {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final String status;
  final PaymentMethod paymentMethod;
  final PaymentProvider provider;
  final String providerTransactionId;
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;
  final BillingAddress? billingAddress;
  final List<PaymentEvent> events;

  const PaymentDetailsResponse({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.provider,
    required this.providerTransactionId,
    this.description,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
    this.billingAddress,
    required this.events,
  });

  factory PaymentDetailsResponse.fromJson(Map<String, dynamic> json) => _$PaymentDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentDetailsResponseToJson(this);
}

@JsonSerializable()
class PaymentStatusResponse {
  final String paymentId;
  final String status;
  final double paidAmount;
  final double remainingAmount;
  final String currency;
  final DateTime lastUpdated;

  const PaymentStatusResponse({
    required this.paymentId,
    required this.status,
    required this.paidAmount,
    required this.remainingAmount,
    required this.currency,
    required this.lastUpdated,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) => _$PaymentStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentStatusResponseToJson(this);
}

@JsonSerializable()
class PaymentCancellationResponse {
  final String paymentId;
  final String status;
  final String reason;
  final DateTime cancelledAt;
  final RefundDetails? refund;

  const PaymentCancellationResponse({
    required this.paymentId,
    required this.status,
    required this.reason,
    required this.cancelledAt,
    this.refund,
  });

  factory PaymentCancellationResponse.fromJson(Map<String, dynamic> json) => _$PaymentCancellationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentCancellationResponseToJson(this);
}

@JsonSerializable()
class PaymentEvent {
  final String id;
  final String eventType;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  const PaymentEvent({
    required this.id,
    required this.eventType,
    required this.description,
    required this.timestamp,
    this.data,
  });

  factory PaymentEvent.fromJson(Map<String, dynamic> json) => _$PaymentEventFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentEventToJson(this);
}

// Payment Method Management
@JsonSerializable()
class AddPaymentMethodRequest {
  final PaymentMethod type;
  final PaymentProvider provider;
  final Map<String, dynamic> methodData;
  final bool setAsDefault;
  final String? nickname;

  const AddPaymentMethodRequest({
    required this.type,
    required this.provider,
    required this.methodData,
    this.setAsDefault = false,
    this.nickname,
  });

  factory AddPaymentMethodRequest.fromJson(Map<String, dynamic> json) => _$AddPaymentMethodRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddPaymentMethodRequestToJson(this);
}

@JsonSerializable()
class PaymentMethodResponse {
  final String id;
  final PaymentMethod type;
  final PaymentProvider provider;
  final String maskedDetails;
  final String? nickname;
  final bool isDefault;
  final DateTime createdAt;

  const PaymentMethodResponse({
    required this.id,
    required this.type,
    required this.provider,
    required this.maskedDetails,
    this.nickname,
    required this.isDefault,
    required this.createdAt,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) => _$PaymentMethodResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodResponseToJson(this);
}

@JsonSerializable()
class StoredPaymentMethod {
  final String id;
  final PaymentMethod type;
  final PaymentProvider provider;
  final String maskedDetails;
  final String? nickname;
  final bool isDefault;
  final bool isExpired;
  final DateTime? expiryDate;
  final DateTime createdAt;
  final DateTime lastUsed;

  const StoredPaymentMethod({
    required this.id,
    required this.type,
    required this.provider,
    required this.maskedDetails,
    this.nickname,
    required this.isDefault,
    required this.isExpired,
    this.expiryDate,
    required this.createdAt,
    required this.lastUsed,
  });

  factory StoredPaymentMethod.fromJson(Map<String, dynamic> json) => _$StoredPaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$StoredPaymentMethodToJson(this);
}

// Installment Payment Models
@JsonSerializable()
class InstallmentCalculationRequest {
  final double totalAmount;
  final String currency;
  final int installmentMonths;
  final double? interestRate;

  const InstallmentCalculationRequest({
    required this.totalAmount,
    required this.currency,
    required this.installmentMonths,
    this.interestRate,
  });

  factory InstallmentCalculationRequest.fromJson(Map<String, dynamic> json) => _$InstallmentCalculationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentCalculationRequestToJson(this);
}

@JsonSerializable()
class InstallmentCalculationResponse {
  final double totalAmount;
  final double monthlyAmount;
  final double totalInterest;
  final double totalToPay;
  final String currency;
  final int installmentMonths;
  final List<InstallmentBreakdown> breakdown;

  const InstallmentCalculationResponse({
    required this.totalAmount,
    required this.monthlyAmount,
    required this.totalInterest,
    required this.totalToPay,
    required this.currency,
    required this.installmentMonths,
    required this.breakdown,
  });

  factory InstallmentCalculationResponse.fromJson(Map<String, dynamic> json) => _$InstallmentCalculationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentCalculationResponseToJson(this);
}

@JsonSerializable()
class InstallmentBreakdown {
  final int month;
  final double amount;
  final double principal;
  final double interest;
  final double remainingBalance;
  final DateTime dueDate;

  const InstallmentBreakdown({
    required this.month,
    required this.amount,
    required this.principal,
    required this.interest,
    required this.remainingBalance,
    required this.dueDate,
  });

  factory InstallmentBreakdown.fromJson(Map<String, dynamic> json) => _$InstallmentBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentBreakdownToJson(this);
}

@JsonSerializable()
class InstallmentSetupRequest {
  final String orderId;
  final double totalAmount;
  final String currency;
  final int installmentMonths;
  final String paymentMethodId;
  final DateTime firstPaymentDate;

  const InstallmentSetupRequest({
    required this.orderId,
    required this.totalAmount,
    required this.currency,
    required this.installmentMonths,
    required this.paymentMethodId,
    required this.firstPaymentDate,
  });

  factory InstallmentSetupRequest.fromJson(Map<String, dynamic> json) => _$InstallmentSetupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentSetupRequestToJson(this);
}

@JsonSerializable()
class InstallmentSetupResponse {
  final String installmentId;
  final String orderId;
  final String status;
  final double monthlyAmount;
  final DateTime firstPaymentDate;
  final DateTime lastPaymentDate;
  final int totalInstallments;

  const InstallmentSetupResponse({
    required this.installmentId,
    required this.orderId,
    required this.status,
    required this.monthlyAmount,
    required this.firstPaymentDate,
    required this.lastPaymentDate,
    required this.totalInstallments,
  });

  factory InstallmentSetupResponse.fromJson(Map<String, dynamic> json) => _$InstallmentSetupResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentSetupResponseToJson(this);
}

@JsonSerializable()
class InstallmentDetails {
  final String id;
  final String orderId;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String currency;
  final int totalInstallments;
  final int completedInstallments;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const InstallmentDetails({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.currency,
    required this.totalInstallments,
    required this.completedInstallments,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory InstallmentDetails.fromJson(Map<String, dynamic> json) => _$InstallmentDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentDetailsToJson(this);
}

@JsonSerializable()
class InstallmentSchedule {
  final int installmentNumber;
  final double amount;
  final DateTime dueDate;
  final String status;
  final DateTime? paidDate;
  final String? paymentId;

  const InstallmentSchedule({
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.paidDate,
    this.paymentId,
  });

  factory InstallmentSchedule.fromJson(Map<String, dynamic> json) => _$InstallmentScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentScheduleToJson(this);
}

@JsonSerializable()
class InstallmentPaymentRequest {
  final int installmentNumber;
  final String? paymentMethodId;

  const InstallmentPaymentRequest({
    required this.installmentNumber,
    this.paymentMethodId,
  });

  factory InstallmentPaymentRequest.fromJson(Map<String, dynamic> json) => _$InstallmentPaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentPaymentRequestToJson(this);
}

@JsonSerializable()
class InstallmentPaymentResponse {
  final String paymentId;
  final int installmentNumber;
  final double amount;
  final String status;
  final DateTime paidDate;
  final int remainingInstallments;

  const InstallmentPaymentResponse({
    required this.paymentId,
    required this.installmentNumber,
    required this.amount,
    required this.status,
    required this.paidDate,
    required this.remainingInstallments,
  });

  factory InstallmentPaymentResponse.fromJson(Map<String, dynamic> json) => _$InstallmentPaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentPaymentResponseToJson(this);
}

// Refund Models
@JsonSerializable()
class RefundRequest {
  final double? amount; // null for full refund
  final String reason;
  final String? description;

  const RefundRequest({
    this.amount,
    required this.reason,
    this.description,
  });

  factory RefundRequest.fromJson(Map<String, dynamic> json) => _$RefundRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RefundRequestToJson(this);
}

@JsonSerializable()
class RefundResponse {
  final String refundId;
  final String paymentId;
  final double amount;
  final String currency;
  final String status;
  final String reason;
  final DateTime initiatedAt;
  final String? estimatedProcessingTime;

  const RefundResponse({
    required this.refundId,
    required this.paymentId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.reason,
    required this.initiatedAt,
    this.estimatedProcessingTime,
  });

  factory RefundResponse.fromJson(Map<String, dynamic> json) => _$RefundResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefundResponseToJson(this);
}

@JsonSerializable()
class RefundDetails {
  final String id;
  final String paymentId;
  final double amount;
  final String currency;
  final String status;
  final String reason;
  final String? description;
  final DateTime initiatedAt;
  final DateTime? processedAt;
  final String? providerRefundId;

  const RefundDetails({
    required this.id,
    required this.paymentId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.reason,
    this.description,
    required this.initiatedAt,
    this.processedAt,
    this.providerRefundId,
  });

  factory RefundDetails.fromJson(Map<String, dynamic> json) => _$RefundDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$RefundDetailsToJson(this);
}

// Additional Models for remaining functionality would continue following the same pattern...

@JsonSerializable()
class PaymentVerificationRequest {
  final String paymentId;
  final String providerTransactionId;
  final PaymentProvider provider;
  final Map<String, dynamic>? verificationData;

  const PaymentVerificationRequest({
    required this.paymentId,
    required this.providerTransactionId,
    required this.provider,
    this.verificationData,
  });

  factory PaymentVerificationRequest.fromJson(Map<String, dynamic> json) => _$PaymentVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentVerificationRequestToJson(this);
}

@JsonSerializable()
class PaymentVerificationResponse {
  final String paymentId;
  final bool isValid;
  final String status;
  final double verifiedAmount;
  final String currency;
  final DateTime verificationTime;
  final Map<String, dynamic>? additionalData;

  const PaymentVerificationResponse({
    required this.paymentId,
    required this.isValid,
    required this.status,
    required this.verifiedAmount,
    required this.currency,
    required this.verificationTime,
    this.additionalData,
  });

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) => _$PaymentVerificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentVerificationResponseToJson(this);
}

@JsonSerializable()
class WebhookResponse {
  final bool processed;
  final String message;
  final Map<String, dynamic>? data;

  const WebhookResponse({
    required this.processed,
    required this.message,
    this.data,
  });

  factory WebhookResponse.fromJson(Map<String, dynamic> json) => _$WebhookResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WebhookResponseToJson(this);
}

// Analytics Models
@JsonSerializable()
class PaymentAnalyticsQuery {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? groupBy; // 'day', 'week', 'month'
  final List<PaymentProvider>? providers;
  final List<PaymentMethod>? methods;

  const PaymentAnalyticsQuery({
    this.startDate,
    this.endDate,
    this.groupBy,
    this.providers,
    this.methods,
  });

  Map<String, dynamic> toJson() => _$PaymentAnalyticsQueryToJson(this);
}

@JsonSerializable()
class PaymentAnalyticsSummary {
  final double totalRevenue;
  final String currency;
  final int totalTransactions;
  final int successfulTransactions;
  final int failedTransactions;
  final double successRate;
  final double averageTransactionAmount;
  final Map<String, double> revenueByProvider;
  final Map<String, double> revenueByMethod;
  final List<PaymentTrend> trends;

  const PaymentAnalyticsSummary({
    required this.totalRevenue,
    required this.currency,
    required this.totalTransactions,
    required this.successfulTransactions,
    required this.failedTransactions,
    required this.successRate,
    required this.averageTransactionAmount,
    required this.revenueByProvider,
    required this.revenueByMethod,
    required this.trends,
  });

  factory PaymentAnalyticsSummary.fromJson(Map<String, dynamic> json) => _$PaymentAnalyticsSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentAnalyticsSummaryToJson(this);
}

@JsonSerializable()
class PaymentTrend {
  final DateTime date;
  final double revenue;
  final int transactionCount;
  final double averageAmount;

  const PaymentTrend({
    required this.date,
    required this.revenue,
    required this.transactionCount,
    required this.averageAmount,
  });

  factory PaymentTrend.fromJson(Map<String, dynamic> json) => _$PaymentTrendFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentTrendToJson(this);
}

@JsonSerializable()
class TransactionAnalyticsQuery {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final PaymentProvider? provider;
  final PaymentMethod? method;
  final int? page;
  final int? limit;

  const TransactionAnalyticsQuery({
    this.startDate,
    this.endDate,
    this.status,
    this.provider,
    this.method,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() => _$TransactionAnalyticsQueryToJson(this);
}

@JsonSerializable()
class TransactionAnalyticsResponse {
  final List<TransactionSummary> transactions;
  final int totalCount;
  final double totalAmount;
  final String currency;
  final int page;
  final int totalPages;

  const TransactionAnalyticsResponse({
    required this.transactions,
    required this.totalCount,
    required this.totalAmount,
    required this.currency,
    required this.page,
    required this.totalPages,
  });

  factory TransactionAnalyticsResponse.fromJson(Map<String, dynamic> json) => _$TransactionAnalyticsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionAnalyticsResponseToJson(this);
}

@JsonSerializable()
class TransactionSummary {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final String status;
  final PaymentMethod method;
  final PaymentProvider provider;
  final DateTime createdAt;

  const TransactionSummary({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    required this.provider,
    required this.createdAt,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) => _$TransactionSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionSummaryToJson(this);
}

// Currency and Exchange Models
@JsonSerializable()
class SupportedCurrency {
  final String code;
  final String name;
  final String symbol;
  final int decimalPlaces;
  final bool isEnabled;

  const SupportedCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.decimalPlaces,
    required this.isEnabled,
  });

  factory SupportedCurrency.fromJson(Map<String, dynamic> json) => _$SupportedCurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$SupportedCurrencyToJson(this);
}

@JsonSerializable()
class ExchangeRateQuery {
  final String baseCurrency;
  final List<String>? targetCurrencies;
  final DateTime? date;

  const ExchangeRateQuery({
    required this.baseCurrency,
    this.targetCurrencies,
    this.date,
  });

  Map<String, dynamic> toJson() => _$ExchangeRateQueryToJson(this);
}

@JsonSerializable()
class ExchangeRatesResponse {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime timestamp;
  final DateTime validUntil;

  const ExchangeRatesResponse({
    required this.baseCurrency,
    required this.rates,
    required this.timestamp,
    required this.validUntil,
  });

  factory ExchangeRatesResponse.fromJson(Map<String, dynamic> json) => _$ExchangeRatesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRatesResponseToJson(this);
}

@JsonSerializable()
class CurrencyConversionRequest {
  final double amount;
  final String fromCurrency;
  final String toCurrency;

  const CurrencyConversionRequest({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
  });

  factory CurrencyConversionRequest.fromJson(Map<String, dynamic> json) => _$CurrencyConversionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyConversionRequestToJson(this);
}

@JsonSerializable()
class CurrencyConversionResponse {
  final double originalAmount;
  final String fromCurrency;
  final double convertedAmount;
  final String toCurrency;
  final double exchangeRate;
  final DateTime timestamp;

  const CurrencyConversionResponse({
    required this.originalAmount,
    required this.fromCurrency,
    required this.convertedAmount,
    required this.toCurrency,
    required this.exchangeRate,
    required this.timestamp,
  });

  factory CurrencyConversionResponse.fromJson(Map<String, dynamic> json) => _$CurrencyConversionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyConversionResponseToJson(this);
}

// Split Payment Models
@JsonSerializable()
class SplitPaymentSetupRequest {
  final String orderId;
  final double totalAmount;
  final String currency;
  final List<SplitParticipant> participants;
  final String splitMethod; // 'equal', 'percentage', 'amount'
  final DateTime? deadline;

  const SplitPaymentSetupRequest({
    required this.orderId,
    required this.totalAmount,
    required this.currency,
    required this.participants,
    required this.splitMethod,
    this.deadline,
  });

  factory SplitPaymentSetupRequest.fromJson(Map<String, dynamic> json) => _$SplitPaymentSetupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SplitPaymentSetupRequestToJson(this);
}

@JsonSerializable()
class SplitParticipant {
  final String userId;
  final String name;
  final String email;
  final double amount;
  final double? percentage;

  const SplitParticipant({
    required this.userId,
    required this.name,
    required this.email,
    required this.amount,
    this.percentage,
  });

  factory SplitParticipant.fromJson(Map<String, dynamic> json) => _$SplitParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$SplitParticipantToJson(this);
}

@JsonSerializable()
class SplitPaymentSetup {
  final String splitPaymentId;
  final String orderId;
  final String status;
  final DateTime createdAt;
  final DateTime? deadline;
  final List<SplitPaymentParticipant> participants;

  const SplitPaymentSetup({
    required this.splitPaymentId,
    required this.orderId,
    required this.status,
    required this.createdAt,
    this.deadline,
    required this.participants,
  });

  factory SplitPaymentSetup.fromJson(Map<String, dynamic> json) => _$SplitPaymentSetupFromJson(json);
  Map<String, dynamic> toJson() => _$SplitPaymentSetupToJson(this);
}

@JsonSerializable()
class SplitPaymentParticipant {
  final String userId;
  final String name;
  final String email;
  final double amount;
  final String status;
  final DateTime? paidAt;
  final String? paymentId;

  const SplitPaymentParticipant({
    required this.userId,
    required this.name,
    required this.email,
    required this.amount,
    required this.status,
    this.paidAt,
    this.paymentId,
  });

  factory SplitPaymentParticipant.fromJson(Map<String, dynamic> json) => _$SplitPaymentParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$SplitPaymentParticipantToJson(this);
}

@JsonSerializable()
class SplitPaymentDetails {
  final String id;
  final String orderId;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? deadline;
  final List<SplitPaymentParticipant> participants;

  const SplitPaymentDetails({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.deadline,
    required this.participants,
  });

  factory SplitPaymentDetails.fromJson(Map<String, dynamic> json) => _$SplitPaymentDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$SplitPaymentDetailsToJson(this);
}

@JsonSerializable()
class SplitPaymentRequest {
  final String participantUserId;
  final String? paymentMethodId;

  const SplitPaymentRequest({
    required this.participantUserId,
    this.paymentMethodId,
  });

  factory SplitPaymentRequest.fromJson(Map<String, dynamic> json) => _$SplitPaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SplitPaymentRequestToJson(this);
}

@JsonSerializable()
class SplitPaymentResponse {
  final String paymentId;
  final String participantUserId;
  final double amount;
  final String status;
  final DateTime paidAt;

  const SplitPaymentResponse({
    required this.paymentId,
    required this.participantUserId,
    required this.amount,
    required this.status,
    required this.paidAt,
  });

  factory SplitPaymentResponse.fromJson(Map<String, dynamic> json) => _$SplitPaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SplitPaymentResponseToJson(this);
}

// Recurring Payment Models
@JsonSerializable()
class RecurringPaymentSetupRequest {
  final String name;
  final double amount;
  final String currency;
  final String frequency; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime startDate;
  final DateTime? endDate;
  final int? maxOccurrences;
  final String paymentMethodId;

  const RecurringPaymentSetupRequest({
    required this.name,
    required this.amount,
    required this.currency,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.maxOccurrences,
    required this.paymentMethodId,
  });

  factory RecurringPaymentSetupRequest.fromJson(Map<String, dynamic> json) => _$RecurringPaymentSetupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RecurringPaymentSetupRequestToJson(this);
}

@JsonSerializable()
class RecurringPaymentSetup {
  final String recurringPaymentId;
  final String status;
  final DateTime nextPaymentDate;
  final int totalOccurrences;

  const RecurringPaymentSetup({
    required this.recurringPaymentId,
    required this.status,
    required this.nextPaymentDate,
    required this.totalOccurrences,
  });

  factory RecurringPaymentSetup.fromJson(Map<String, dynamic> json) => _$RecurringPaymentSetupFromJson(json);
  Map<String, dynamic> toJson() => _$RecurringPaymentSetupToJson(this);
}

@JsonSerializable()
class RecurringPaymentDetails {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final String frequency;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? nextPaymentDate;
  final int completedPayments;
  final int? maxOccurrences;
  final DateTime createdAt;

  const RecurringPaymentDetails({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.frequency,
    required this.status,
    required this.startDate,
    this.endDate,
    this.nextPaymentDate,
    required this.completedPayments,
    this.maxOccurrences,
    required this.createdAt,
  });

  factory RecurringPaymentDetails.fromJson(Map<String, dynamic> json) => _$RecurringPaymentDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$RecurringPaymentDetailsToJson(this);
}