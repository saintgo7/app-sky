// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      paymentData: json['paymentData'] as Map<String, dynamic>,
      description: json['description'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerPhone: json['customerPhone'] as String?,
      billingAddress: json['billingAddress'] == null
          ? null
          : BillingAddress.fromJson(
              json['billingAddress'] as Map<String, dynamic>),
      savePaymentMethod: json['savePaymentMethod'] as bool? ?? false,
      successUrl: json['successUrl'] as String?,
      failureUrl: json['failureUrl'] as String?,
      cancelUrl: json['cancelUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'paymentData': instance.paymentData,
      'description': instance.description,
      'customerEmail': instance.customerEmail,
      'customerPhone': instance.customerPhone,
      'billingAddress': instance.billingAddress,
      'savePaymentMethod': instance.savePaymentMethod,
      'successUrl': instance.successUrl,
      'failureUrl': instance.failureUrl,
      'cancelUrl': instance.cancelUrl,
      'metadata': instance.metadata,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.creditCard: 'creditCard',
  PaymentMethod.debitCard: 'debitCard',
  PaymentMethod.bankTransfer: 'bankTransfer',
  PaymentMethod.digitalWallet: 'digitalWallet',
  PaymentMethod.cryptocurrency: 'cryptocurrency',
};

const _$PaymentProviderEnumMap = {
  PaymentProvider.iamport: 'iamport',
  PaymentProvider.bootpay: 'bootpay',
  PaymentProvider.stripe: 'stripe',
  PaymentProvider.paypal: 'paypal',
};

BillingAddress _$BillingAddressFromJson(Map<String, dynamic> json) =>
    BillingAddress(
      name: json['name'] as String,
      address1: json['address1'] as String,
      address2: json['address2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$BillingAddressToJson(BillingAddress instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address1': instance.address1,
      'address2': instance.address2,
      'city': instance.city,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'country': instance.country,
    };

CancelPaymentRequest _$CancelPaymentRequestFromJson(
        Map<String, dynamic> json) =>
    CancelPaymentRequest(
      reason: json['reason'] as String,
      requestRefund: json['requestRefund'] as bool? ?? false,
    );

Map<String, dynamic> _$CancelPaymentRequestToJson(
        CancelPaymentRequest instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'requestRefund': instance.requestRefund,
    };

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      paymentId: json['paymentId'] as String,
      status: json['status'] as String,
      redirectUrl: json['redirectUrl'] as String?,
      qrCode: json['qrCode'] as String?,
      deepLink: json['deepLink'] as String?,
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      providerTransactionId: json['providerTransactionId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      errorCode: json['errorCode'] as String?,
      errorMessage: json['errorMessage'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'status': instance.status,
      'redirectUrl': instance.redirectUrl,
      'qrCode': instance.qrCode,
      'deepLink': instance.deepLink,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'providerTransactionId': instance.providerTransactionId,
      'createdAt': instance.createdAt.toIso8601String(),
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'additionalData': instance.additionalData,
    };

PaymentDetailsResponse _$PaymentDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentDetailsResponse(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      providerTransactionId: json['providerTransactionId'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      failureReason: json['failureReason'] as String?,
      billingAddress: json['billingAddress'] == null
          ? null
          : BillingAddress.fromJson(
              json['billingAddress'] as Map<String, dynamic>),
      events: (json['events'] as List<dynamic>)
          .map((e) => PaymentEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentDetailsResponseToJson(
        PaymentDetailsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'providerTransactionId': instance.providerTransactionId,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'failureReason': instance.failureReason,
      'billingAddress': instance.billingAddress,
      'events': instance.events,
    };

PaymentStatusResponse _$PaymentStatusResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentStatusResponse(
      paymentId: json['paymentId'] as String,
      status: json['status'] as String,
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$PaymentStatusResponseToJson(
        PaymentStatusResponse instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'status': instance.status,
      'paidAmount': instance.paidAmount,
      'remainingAmount': instance.remainingAmount,
      'currency': instance.currency,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

PaymentCancellationResponse _$PaymentCancellationResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentCancellationResponse(
      paymentId: json['paymentId'] as String,
      status: json['status'] as String,
      reason: json['reason'] as String,
      cancelledAt: DateTime.parse(json['cancelledAt'] as String),
      refund: json['refund'] == null
          ? null
          : RefundDetails.fromJson(json['refund'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentCancellationResponseToJson(
        PaymentCancellationResponse instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'status': instance.status,
      'reason': instance.reason,
      'cancelledAt': instance.cancelledAt.toIso8601String(),
      'refund': instance.refund,
    };

PaymentEvent _$PaymentEventFromJson(Map<String, dynamic> json) => PaymentEvent(
      id: json['id'] as String,
      eventType: json['eventType'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentEventToJson(PaymentEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventType': instance.eventType,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'data': instance.data,
    };

AddPaymentMethodRequest _$AddPaymentMethodRequestFromJson(
        Map<String, dynamic> json) =>
    AddPaymentMethodRequest(
      type: $enumDecode(_$PaymentMethodEnumMap, json['type']),
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      methodData: json['methodData'] as Map<String, dynamic>,
      setAsDefault: json['setAsDefault'] as bool? ?? false,
      nickname: json['nickname'] as String?,
    );

Map<String, dynamic> _$AddPaymentMethodRequestToJson(
        AddPaymentMethodRequest instance) =>
    <String, dynamic>{
      'type': _$PaymentMethodEnumMap[instance.type]!,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'methodData': instance.methodData,
      'setAsDefault': instance.setAsDefault,
      'nickname': instance.nickname,
    };

PaymentMethodResponse _$PaymentMethodResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentMethodResponse(
      id: json['id'] as String,
      type: $enumDecode(_$PaymentMethodEnumMap, json['type']),
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      maskedDetails: json['maskedDetails'] as String,
      nickname: json['nickname'] as String?,
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PaymentMethodResponseToJson(
        PaymentMethodResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PaymentMethodEnumMap[instance.type]!,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'maskedDetails': instance.maskedDetails,
      'nickname': instance.nickname,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
    };

StoredPaymentMethod _$StoredPaymentMethodFromJson(Map<String, dynamic> json) =>
    StoredPaymentMethod(
      id: json['id'] as String,
      type: $enumDecode(_$PaymentMethodEnumMap, json['type']),
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      maskedDetails: json['maskedDetails'] as String,
      nickname: json['nickname'] as String?,
      isDefault: json['isDefault'] as bool,
      isExpired: json['isExpired'] as bool,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsed: DateTime.parse(json['lastUsed'] as String),
    );

Map<String, dynamic> _$StoredPaymentMethodToJson(
        StoredPaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PaymentMethodEnumMap[instance.type]!,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'maskedDetails': instance.maskedDetails,
      'nickname': instance.nickname,
      'isDefault': instance.isDefault,
      'isExpired': instance.isExpired,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUsed': instance.lastUsed.toIso8601String(),
    };

InstallmentCalculationRequest _$InstallmentCalculationRequestFromJson(
        Map<String, dynamic> json) =>
    InstallmentCalculationRequest(
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      installmentMonths: (json['installmentMonths'] as num).toInt(),
      interestRate: (json['interestRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$InstallmentCalculationRequestToJson(
        InstallmentCalculationRequest instance) =>
    <String, dynamic>{
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'installmentMonths': instance.installmentMonths,
      'interestRate': instance.interestRate,
    };

InstallmentCalculationResponse _$InstallmentCalculationResponseFromJson(
        Map<String, dynamic> json) =>
    InstallmentCalculationResponse(
      totalAmount: (json['totalAmount'] as num).toDouble(),
      monthlyAmount: (json['monthlyAmount'] as num).toDouble(),
      totalInterest: (json['totalInterest'] as num).toDouble(),
      totalToPay: (json['totalToPay'] as num).toDouble(),
      currency: json['currency'] as String,
      installmentMonths: (json['installmentMonths'] as num).toInt(),
      breakdown: (json['breakdown'] as List<dynamic>)
          .map((e) => InstallmentBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InstallmentCalculationResponseToJson(
        InstallmentCalculationResponse instance) =>
    <String, dynamic>{
      'totalAmount': instance.totalAmount,
      'monthlyAmount': instance.monthlyAmount,
      'totalInterest': instance.totalInterest,
      'totalToPay': instance.totalToPay,
      'currency': instance.currency,
      'installmentMonths': instance.installmentMonths,
      'breakdown': instance.breakdown,
    };

InstallmentBreakdown _$InstallmentBreakdownFromJson(
        Map<String, dynamic> json) =>
    InstallmentBreakdown(
      month: (json['month'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      principal: (json['principal'] as num).toDouble(),
      interest: (json['interest'] as num).toDouble(),
      remainingBalance: (json['remainingBalance'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
    );

Map<String, dynamic> _$InstallmentBreakdownToJson(
        InstallmentBreakdown instance) =>
    <String, dynamic>{
      'month': instance.month,
      'amount': instance.amount,
      'principal': instance.principal,
      'interest': instance.interest,
      'remainingBalance': instance.remainingBalance,
      'dueDate': instance.dueDate.toIso8601String(),
    };

InstallmentSetupRequest _$InstallmentSetupRequestFromJson(
        Map<String, dynamic> json) =>
    InstallmentSetupRequest(
      orderId: json['orderId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      installmentMonths: (json['installmentMonths'] as num).toInt(),
      paymentMethodId: json['paymentMethodId'] as String,
      firstPaymentDate: DateTime.parse(json['firstPaymentDate'] as String),
    );

Map<String, dynamic> _$InstallmentSetupRequestToJson(
        InstallmentSetupRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'installmentMonths': instance.installmentMonths,
      'paymentMethodId': instance.paymentMethodId,
      'firstPaymentDate': instance.firstPaymentDate.toIso8601String(),
    };

InstallmentSetupResponse _$InstallmentSetupResponseFromJson(
        Map<String, dynamic> json) =>
    InstallmentSetupResponse(
      installmentId: json['installmentId'] as String,
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      monthlyAmount: (json['monthlyAmount'] as num).toDouble(),
      firstPaymentDate: DateTime.parse(json['firstPaymentDate'] as String),
      lastPaymentDate: DateTime.parse(json['lastPaymentDate'] as String),
      totalInstallments: (json['totalInstallments'] as num).toInt(),
    );

Map<String, dynamic> _$InstallmentSetupResponseToJson(
        InstallmentSetupResponse instance) =>
    <String, dynamic>{
      'installmentId': instance.installmentId,
      'orderId': instance.orderId,
      'status': instance.status,
      'monthlyAmount': instance.monthlyAmount,
      'firstPaymentDate': instance.firstPaymentDate.toIso8601String(),
      'lastPaymentDate': instance.lastPaymentDate.toIso8601String(),
      'totalInstallments': instance.totalInstallments,
    };

InstallmentDetails _$InstallmentDetailsFromJson(Map<String, dynamic> json) =>
    InstallmentDetails(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      totalInstallments: (json['totalInstallments'] as num).toInt(),
      completedInstallments: (json['completedInstallments'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$InstallmentDetailsToJson(InstallmentDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'paidAmount': instance.paidAmount,
      'remainingAmount': instance.remainingAmount,
      'currency': instance.currency,
      'totalInstallments': instance.totalInstallments,
      'completedInstallments': instance.completedInstallments,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

InstallmentSchedule _$InstallmentScheduleFromJson(Map<String, dynamic> json) =>
    InstallmentSchedule(
      installmentNumber: (json['installmentNumber'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String,
      paidDate: json['paidDate'] == null
          ? null
          : DateTime.parse(json['paidDate'] as String),
      paymentId: json['paymentId'] as String?,
    );

Map<String, dynamic> _$InstallmentScheduleToJson(
        InstallmentSchedule instance) =>
    <String, dynamic>{
      'installmentNumber': instance.installmentNumber,
      'amount': instance.amount,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': instance.status,
      'paidDate': instance.paidDate?.toIso8601String(),
      'paymentId': instance.paymentId,
    };

InstallmentPaymentRequest _$InstallmentPaymentRequestFromJson(
        Map<String, dynamic> json) =>
    InstallmentPaymentRequest(
      installmentNumber: (json['installmentNumber'] as num).toInt(),
      paymentMethodId: json['paymentMethodId'] as String?,
    );

Map<String, dynamic> _$InstallmentPaymentRequestToJson(
        InstallmentPaymentRequest instance) =>
    <String, dynamic>{
      'installmentNumber': instance.installmentNumber,
      'paymentMethodId': instance.paymentMethodId,
    };

InstallmentPaymentResponse _$InstallmentPaymentResponseFromJson(
        Map<String, dynamic> json) =>
    InstallmentPaymentResponse(
      paymentId: json['paymentId'] as String,
      installmentNumber: (json['installmentNumber'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      paidDate: DateTime.parse(json['paidDate'] as String),
      remainingInstallments: (json['remainingInstallments'] as num).toInt(),
    );

Map<String, dynamic> _$InstallmentPaymentResponseToJson(
        InstallmentPaymentResponse instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'installmentNumber': instance.installmentNumber,
      'amount': instance.amount,
      'status': instance.status,
      'paidDate': instance.paidDate.toIso8601String(),
      'remainingInstallments': instance.remainingInstallments,
    };

RefundRequest _$RefundRequestFromJson(Map<String, dynamic> json) =>
    RefundRequest(
      amount: (json['amount'] as num?)?.toDouble(),
      reason: json['reason'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RefundRequestToJson(RefundRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'reason': instance.reason,
      'description': instance.description,
    };

RefundResponse _$RefundResponseFromJson(Map<String, dynamic> json) =>
    RefundResponse(
      refundId: json['refundId'] as String,
      paymentId: json['paymentId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      reason: json['reason'] as String,
      initiatedAt: DateTime.parse(json['initiatedAt'] as String),
      estimatedProcessingTime: json['estimatedProcessingTime'] as String?,
    );

Map<String, dynamic> _$RefundResponseToJson(RefundResponse instance) =>
    <String, dynamic>{
      'refundId': instance.refundId,
      'paymentId': instance.paymentId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'reason': instance.reason,
      'initiatedAt': instance.initiatedAt.toIso8601String(),
      'estimatedProcessingTime': instance.estimatedProcessingTime,
    };

RefundDetails _$RefundDetailsFromJson(Map<String, dynamic> json) =>
    RefundDetails(
      id: json['id'] as String,
      paymentId: json['paymentId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String?,
      initiatedAt: DateTime.parse(json['initiatedAt'] as String),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      providerRefundId: json['providerRefundId'] as String?,
    );

Map<String, dynamic> _$RefundDetailsToJson(RefundDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paymentId': instance.paymentId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'reason': instance.reason,
      'description': instance.description,
      'initiatedAt': instance.initiatedAt.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
      'providerRefundId': instance.providerRefundId,
    };

PaymentVerificationRequest _$PaymentVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    PaymentVerificationRequest(
      paymentId: json['paymentId'] as String,
      providerTransactionId: json['providerTransactionId'] as String,
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      verificationData: json['verificationData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentVerificationRequestToJson(
        PaymentVerificationRequest instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'providerTransactionId': instance.providerTransactionId,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'verificationData': instance.verificationData,
    };

PaymentVerificationResponse _$PaymentVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentVerificationResponse(
      paymentId: json['paymentId'] as String,
      isValid: json['isValid'] as bool,
      status: json['status'] as String,
      verifiedAmount: (json['verifiedAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      verificationTime: DateTime.parse(json['verificationTime'] as String),
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentVerificationResponseToJson(
        PaymentVerificationResponse instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'isValid': instance.isValid,
      'status': instance.status,
      'verifiedAmount': instance.verifiedAmount,
      'currency': instance.currency,
      'verificationTime': instance.verificationTime.toIso8601String(),
      'additionalData': instance.additionalData,
    };

WebhookResponse _$WebhookResponseFromJson(Map<String, dynamic> json) =>
    WebhookResponse(
      processed: json['processed'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$WebhookResponseToJson(WebhookResponse instance) =>
    <String, dynamic>{
      'processed': instance.processed,
      'message': instance.message,
      'data': instance.data,
    };

PaymentAnalyticsQuery _$PaymentAnalyticsQueryFromJson(
        Map<String, dynamic> json) =>
    PaymentAnalyticsQuery(
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      groupBy: json['groupBy'] as String?,
      providers: (json['providers'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PaymentProviderEnumMap, e))
          .toList(),
      methods: (json['methods'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PaymentMethodEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$PaymentAnalyticsQueryToJson(
        PaymentAnalyticsQuery instance) =>
    <String, dynamic>{
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'groupBy': instance.groupBy,
      'providers':
          instance.providers?.map((e) => _$PaymentProviderEnumMap[e]!).toList(),
      'methods':
          instance.methods?.map((e) => _$PaymentMethodEnumMap[e]!).toList(),
    };

PaymentAnalyticsSummary _$PaymentAnalyticsSummaryFromJson(
        Map<String, dynamic> json) =>
    PaymentAnalyticsSummary(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      currency: json['currency'] as String,
      totalTransactions: (json['totalTransactions'] as num).toInt(),
      successfulTransactions: (json['successfulTransactions'] as num).toInt(),
      failedTransactions: (json['failedTransactions'] as num).toInt(),
      successRate: (json['successRate'] as num).toDouble(),
      averageTransactionAmount:
          (json['averageTransactionAmount'] as num).toDouble(),
      revenueByProvider:
          (json['revenueByProvider'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      revenueByMethod: (json['revenueByMethod'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      trends: (json['trends'] as List<dynamic>)
          .map((e) => PaymentTrend.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentAnalyticsSummaryToJson(
        PaymentAnalyticsSummary instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'currency': instance.currency,
      'totalTransactions': instance.totalTransactions,
      'successfulTransactions': instance.successfulTransactions,
      'failedTransactions': instance.failedTransactions,
      'successRate': instance.successRate,
      'averageTransactionAmount': instance.averageTransactionAmount,
      'revenueByProvider': instance.revenueByProvider,
      'revenueByMethod': instance.revenueByMethod,
      'trends': instance.trends,
    };

PaymentTrend _$PaymentTrendFromJson(Map<String, dynamic> json) => PaymentTrend(
      date: DateTime.parse(json['date'] as String),
      revenue: (json['revenue'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      averageAmount: (json['averageAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$PaymentTrendToJson(PaymentTrend instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'revenue': instance.revenue,
      'transactionCount': instance.transactionCount,
      'averageAmount': instance.averageAmount,
    };

TransactionAnalyticsQuery _$TransactionAnalyticsQueryFromJson(
        Map<String, dynamic> json) =>
    TransactionAnalyticsQuery(
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      status: json['status'] as String?,
      provider: $enumDecodeNullable(_$PaymentProviderEnumMap, json['provider']),
      method: $enumDecodeNullable(_$PaymentMethodEnumMap, json['method']),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionAnalyticsQueryToJson(
        TransactionAnalyticsQuery instance) =>
    <String, dynamic>{
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'status': instance.status,
      'provider': _$PaymentProviderEnumMap[instance.provider],
      'method': _$PaymentMethodEnumMap[instance.method],
      'page': instance.page,
      'limit': instance.limit,
    };

TransactionAnalyticsResponse _$TransactionAnalyticsResponseFromJson(
        Map<String, dynamic> json) =>
    TransactionAnalyticsResponse(
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => TransactionSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      page: (json['page'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionAnalyticsResponseToJson(
        TransactionAnalyticsResponse instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
      'totalCount': instance.totalCount,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'page': instance.page,
      'totalPages': instance.totalPages,
    };

TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) =>
    TransactionSummary(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TransactionSummaryToJson(TransactionSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

SupportedCurrency _$SupportedCurrencyFromJson(Map<String, dynamic> json) =>
    SupportedCurrency(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      decimalPlaces: (json['decimalPlaces'] as num).toInt(),
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$SupportedCurrencyToJson(SupportedCurrency instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'decimalPlaces': instance.decimalPlaces,
      'isEnabled': instance.isEnabled,
    };

ExchangeRateQuery _$ExchangeRateQueryFromJson(Map<String, dynamic> json) =>
    ExchangeRateQuery(
      baseCurrency: json['baseCurrency'] as String,
      targetCurrencies: (json['targetCurrencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ExchangeRateQueryToJson(ExchangeRateQuery instance) =>
    <String, dynamic>{
      'baseCurrency': instance.baseCurrency,
      'targetCurrencies': instance.targetCurrencies,
      'date': instance.date?.toIso8601String(),
    };

ExchangeRatesResponse _$ExchangeRatesResponseFromJson(
        Map<String, dynamic> json) =>
    ExchangeRatesResponse(
      baseCurrency: json['baseCurrency'] as String,
      rates: (json['rates'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
    );

Map<String, dynamic> _$ExchangeRatesResponseToJson(
        ExchangeRatesResponse instance) =>
    <String, dynamic>{
      'baseCurrency': instance.baseCurrency,
      'rates': instance.rates,
      'timestamp': instance.timestamp.toIso8601String(),
      'validUntil': instance.validUntil.toIso8601String(),
    };

CurrencyConversionRequest _$CurrencyConversionRequestFromJson(
        Map<String, dynamic> json) =>
    CurrencyConversionRequest(
      amount: (json['amount'] as num).toDouble(),
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
    );

Map<String, dynamic> _$CurrencyConversionRequestToJson(
        CurrencyConversionRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'fromCurrency': instance.fromCurrency,
      'toCurrency': instance.toCurrency,
    };

CurrencyConversionResponse _$CurrencyConversionResponseFromJson(
        Map<String, dynamic> json) =>
    CurrencyConversionResponse(
      originalAmount: (json['originalAmount'] as num).toDouble(),
      fromCurrency: json['fromCurrency'] as String,
      convertedAmount: (json['convertedAmount'] as num).toDouble(),
      toCurrency: json['toCurrency'] as String,
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$CurrencyConversionResponseToJson(
        CurrencyConversionResponse instance) =>
    <String, dynamic>{
      'originalAmount': instance.originalAmount,
      'fromCurrency': instance.fromCurrency,
      'convertedAmount': instance.convertedAmount,
      'toCurrency': instance.toCurrency,
      'exchangeRate': instance.exchangeRate,
      'timestamp': instance.timestamp.toIso8601String(),
    };

SplitPaymentSetupRequest _$SplitPaymentSetupRequestFromJson(
        Map<String, dynamic> json) =>
    SplitPaymentSetupRequest(
      orderId: json['orderId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => SplitParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      splitMethod: json['splitMethod'] as String,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
    );

Map<String, dynamic> _$SplitPaymentSetupRequestToJson(
        SplitPaymentSetupRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'participants': instance.participants,
      'splitMethod': instance.splitMethod,
      'deadline': instance.deadline?.toIso8601String(),
    };

SplitParticipant _$SplitParticipantFromJson(Map<String, dynamic> json) =>
    SplitParticipant(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SplitParticipantToJson(SplitParticipant instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'amount': instance.amount,
      'percentage': instance.percentage,
    };

SplitPaymentSetup _$SplitPaymentSetupFromJson(Map<String, dynamic> json) =>
    SplitPaymentSetup(
      splitPaymentId: json['splitPaymentId'] as String,
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      participants: (json['participants'] as List<dynamic>)
          .map((e) =>
              SplitPaymentParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SplitPaymentSetupToJson(SplitPaymentSetup instance) =>
    <String, dynamic>{
      'splitPaymentId': instance.splitPaymentId,
      'orderId': instance.orderId,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'deadline': instance.deadline?.toIso8601String(),
      'participants': instance.participants,
    };

SplitPaymentParticipant _$SplitPaymentParticipantFromJson(
        Map<String, dynamic> json) =>
    SplitPaymentParticipant(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      paymentId: json['paymentId'] as String?,
    );

Map<String, dynamic> _$SplitPaymentParticipantToJson(
        SplitPaymentParticipant instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'amount': instance.amount,
      'status': instance.status,
      'paidAt': instance.paidAt?.toIso8601String(),
      'paymentId': instance.paymentId,
    };

SplitPaymentDetails _$SplitPaymentDetailsFromJson(Map<String, dynamic> json) =>
    SplitPaymentDetails(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      participants: (json['participants'] as List<dynamic>)
          .map((e) =>
              SplitPaymentParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SplitPaymentDetailsToJson(
        SplitPaymentDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'paidAmount': instance.paidAmount,
      'remainingAmount': instance.remainingAmount,
      'currency': instance.currency,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'deadline': instance.deadline?.toIso8601String(),
      'participants': instance.participants,
    };

SplitPaymentRequest _$SplitPaymentRequestFromJson(Map<String, dynamic> json) =>
    SplitPaymentRequest(
      participantUserId: json['participantUserId'] as String,
      paymentMethodId: json['paymentMethodId'] as String?,
    );

Map<String, dynamic> _$SplitPaymentRequestToJson(
        SplitPaymentRequest instance) =>
    <String, dynamic>{
      'participantUserId': instance.participantUserId,
      'paymentMethodId': instance.paymentMethodId,
    };

SplitPaymentResponse _$SplitPaymentResponseFromJson(
        Map<String, dynamic> json) =>
    SplitPaymentResponse(
      paymentId: json['paymentId'] as String,
      participantUserId: json['participantUserId'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$SplitPaymentResponseToJson(
        SplitPaymentResponse instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'participantUserId': instance.participantUserId,
      'amount': instance.amount,
      'status': instance.status,
      'paidAt': instance.paidAt.toIso8601String(),
    };

RecurringPaymentSetupRequest _$RecurringPaymentSetupRequestFromJson(
        Map<String, dynamic> json) =>
    RecurringPaymentSetupRequest(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      frequency: json['frequency'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      maxOccurrences: (json['maxOccurrences'] as num?)?.toInt(),
      paymentMethodId: json['paymentMethodId'] as String,
    );

Map<String, dynamic> _$RecurringPaymentSetupRequestToJson(
        RecurringPaymentSetupRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'currency': instance.currency,
      'frequency': instance.frequency,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'maxOccurrences': instance.maxOccurrences,
      'paymentMethodId': instance.paymentMethodId,
    };

RecurringPaymentSetup _$RecurringPaymentSetupFromJson(
        Map<String, dynamic> json) =>
    RecurringPaymentSetup(
      recurringPaymentId: json['recurringPaymentId'] as String,
      status: json['status'] as String,
      nextPaymentDate: DateTime.parse(json['nextPaymentDate'] as String),
      totalOccurrences: (json['totalOccurrences'] as num).toInt(),
    );

Map<String, dynamic> _$RecurringPaymentSetupToJson(
        RecurringPaymentSetup instance) =>
    <String, dynamic>{
      'recurringPaymentId': instance.recurringPaymentId,
      'status': instance.status,
      'nextPaymentDate': instance.nextPaymentDate.toIso8601String(),
      'totalOccurrences': instance.totalOccurrences,
    };

RecurringPaymentDetails _$RecurringPaymentDetailsFromJson(
        Map<String, dynamic> json) =>
    RecurringPaymentDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      frequency: json['frequency'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      nextPaymentDate: json['nextPaymentDate'] == null
          ? null
          : DateTime.parse(json['nextPaymentDate'] as String),
      completedPayments: (json['completedPayments'] as num).toInt(),
      maxOccurrences: (json['maxOccurrences'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RecurringPaymentDetailsToJson(
        RecurringPaymentDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'currency': instance.currency,
      'frequency': instance.frequency,
      'status': instance.status,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'nextPaymentDate': instance.nextPaymentDate?.toIso8601String(),
      'completedPayments': instance.completedPayments,
      'maxOccurrences': instance.maxOccurrences,
      'createdAt': instance.createdAt.toIso8601String(),
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _PaymentService implements PaymentService {
  _PaymentService(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<PaymentResponse> processPayment(
    String token,
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
          '/payments/process',
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
  Future<PaymentDetailsResponse> getPayment(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PaymentDetailsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PaymentDetailsResponse _value;
    try {
      _value = PaymentDetailsResponse.fromJson(_result.data!);
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
          '/payments/${id}/status',
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
  Future<PaymentCancellationResponse> cancelPayment(
    String token,
    String id,
    CancelPaymentRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<PaymentCancellationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/${id}/cancel',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PaymentCancellationResponse _value;
    try {
      _value = PaymentCancellationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PaymentMethodResponse> addPaymentMethod(
    String token,
    AddPaymentMethodRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<PaymentMethodResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/methods/add',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PaymentMethodResponse _value;
    try {
      _value = PaymentMethodResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<StoredPaymentMethod>> getPaymentMethods(String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<StoredPaymentMethod>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/methods',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<StoredPaymentMethod> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              StoredPaymentMethod.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> removePaymentMethod(
    String token,
    String id,
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
          '/payments/methods/${id}',
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
  Future<StoredPaymentMethod> setDefaultPaymentMethod(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<StoredPaymentMethod>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/methods/${id}/default',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late StoredPaymentMethod _value;
    try {
      _value = StoredPaymentMethod.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InstallmentCalculationResponse> calculateInstallment(
      InstallmentCalculationRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<InstallmentCalculationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/installment/calculate',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late InstallmentCalculationResponse _value;
    try {
      _value = InstallmentCalculationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InstallmentSetupResponse> setupInstallmentPayment(
    String token,
    InstallmentSetupRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<InstallmentSetupResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/installment/setup',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late InstallmentSetupResponse _value;
    try {
      _value = InstallmentSetupResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InstallmentDetails> getInstallmentDetails(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<InstallmentDetails>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/installment/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late InstallmentDetails _value;
    try {
      _value = InstallmentDetails.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<InstallmentSchedule>> getInstallmentSchedule(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<InstallmentSchedule>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/installment/${id}/schedule',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<InstallmentSchedule> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              InstallmentSchedule.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InstallmentPaymentResponse> payInstallment(
    String token,
    String installmentId,
    InstallmentPaymentRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<InstallmentPaymentResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/installment/${installmentId}/pay',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late InstallmentPaymentResponse _value;
    try {
      _value = InstallmentPaymentResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RefundResponse> processRefund(
    String token,
    String paymentId,
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
          '/payments/${paymentId}/refund',
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
  Future<List<RefundDetails>> getRefunds(
    String token,
    String paymentId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<RefundDetails>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/${paymentId}/refunds',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<RefundDetails> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => RefundDetails.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RefundDetails> getRefund(
    String token,
    String refundId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<RefundDetails>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/refunds/${refundId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RefundDetails _value;
    try {
      _value = RefundDetails.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PaymentVerificationResponse> verifyPayment(
      PaymentVerificationRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<PaymentVerificationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/verify',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PaymentVerificationResponse _value;
    try {
      _value = PaymentVerificationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<WebhookResponse> handleWebhook(
    String provider,
    Map<String, dynamic> payload,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(payload);
    final _options = _setStreamType<WebhookResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/webhook/${provider}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late WebhookResponse _value;
    try {
      _value = WebhookResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<PaymentAnalyticsSummary> getPaymentAnalytics(
    String token,
    PaymentAnalyticsQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PaymentAnalyticsSummary>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/analytics/summary',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PaymentAnalyticsSummary _value;
    try {
      _value = PaymentAnalyticsSummary.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TransactionAnalyticsResponse> getTransactionAnalytics(
    String token,
    TransactionAnalyticsQuery query,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TransactionAnalyticsResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/analytics/transactions',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TransactionAnalyticsResponse _value;
    try {
      _value = TransactionAnalyticsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<SupportedCurrency>> getSupportedCurrencies() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<SupportedCurrency>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/currencies',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<SupportedCurrency> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              SupportedCurrency.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ExchangeRatesResponse> getExchangeRates(
      ExchangeRateQuery query) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(query.toJson());
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ExchangeRatesResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/exchange-rates',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ExchangeRatesResponse _value;
    try {
      _value = ExchangeRatesResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CurrencyConversionResponse> convertCurrency(
      CurrencyConversionRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<CurrencyConversionResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/currency/convert',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CurrencyConversionResponse _value;
    try {
      _value = CurrencyConversionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SplitPaymentSetup> setupSplitPayment(
    String token,
    SplitPaymentSetupRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<SplitPaymentSetup>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/split/setup',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SplitPaymentSetup _value;
    try {
      _value = SplitPaymentSetup.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SplitPaymentDetails> getSplitPaymentDetails(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<SplitPaymentDetails>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/split/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SplitPaymentDetails _value;
    try {
      _value = SplitPaymentDetails.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SplitPaymentResponse> paySplitPayment(
    String token,
    String splitPaymentId,
    SplitPaymentRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<SplitPaymentResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/split/${splitPaymentId}/pay',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SplitPaymentResponse _value;
    try {
      _value = SplitPaymentResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RecurringPaymentSetup> setupRecurringPayment(
    String token,
    RecurringPaymentSetupRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<RecurringPaymentSetup>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/recurring/setup',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RecurringPaymentSetup _value;
    try {
      _value = RecurringPaymentSetup.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<RecurringPaymentDetails>> getRecurringPayments(
      String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<RecurringPaymentDetails>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/recurring',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<RecurringPaymentDetails> _value;
    try {
      _value = _result.data!
          .map((dynamic i) =>
              RecurringPaymentDetails.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RecurringPaymentDetails> pauseRecurringPayment(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<RecurringPaymentDetails>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/recurring/${id}/pause',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RecurringPaymentDetails _value;
    try {
      _value = RecurringPaymentDetails.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RecurringPaymentDetails> resumeRecurringPayment(
    String token,
    String id,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<RecurringPaymentDetails>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/payments/recurring/${id}/resume',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RecurringPaymentDetails _value;
    try {
      _value = RecurringPaymentDetails.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> cancelRecurringPayment(
    String token,
    String id,
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
          '/payments/recurring/${id}',
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
