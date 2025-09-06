import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travelmate/data/api/payment_service.dart';

class MockDio extends Mock implements Dio {}
class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  group('PaymentService Tests', () {
    late PaymentService paymentService;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      paymentService = PaymentService(mockDio);
    });

    group('Payment Processing', () {
      test('should process payment successfully', () async {
        // Arrange
        final paymentRequest = PaymentRequest(
          orderId: 'order123',
          amount: 100000.0,
          currency: 'KRW',
          paymentMethod: PaymentMethod.creditCard,
          provider: PaymentProvider.iamport,
          paymentData: {
            'card_number': '**** **** **** 1234',
            'exp_month': '12',
            'exp_year': '25',
          },
          customerEmail: 'test@example.com',
        );

        final expectedResponse = PaymentResponse(
          paymentId: 'payment123',
          status: 'processing',
          provider: PaymentProvider.iamport,
          providerTransactionId: 'txn123',
          createdAt: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/process',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.processPayment('Bearer token', paymentRequest);

        // Assert
        expect(result.paymentId, equals('payment123'));
        expect(result.status, equals('processing'));
        expect(result.provider, equals(PaymentProvider.iamport));
        verify(() => mockDio.post<Map<String, dynamic>>(
          '/payments/process',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).called(1);
      });

      test('should handle payment processing failure', () async {
        // Arrange
        final paymentRequest = PaymentRequest(
          orderId: 'order123',
          amount: 100000.0,
          currency: 'KRW',
          paymentMethod: PaymentMethod.creditCard,
          provider: PaymentProvider.iamport,
          paymentData: {
            'card_number': '**** **** **** 1234',
          },
        );

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/process',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/payments/process'),
          response: Response(
            requestOptions: RequestOptions(path: '/payments/process'),
            statusCode: 400,
            data: {'error': 'Invalid card number'},
          ),
        ));

        // Act & Assert
        expect(
          () => paymentService.processPayment('Bearer token', paymentRequest),
          throwsA(isA<DioException>()),
        );
      });

      test('should get payment status correctly', () async {
        // Arrange
        final expectedResponse = PaymentStatusResponse(
          paymentId: 'payment123',
          status: 'completed',
          paidAmount: 100000.0,
          remainingAmount: 0.0,
          currency: 'KRW',
          lastUpdated: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.get<Map<String, dynamic>>(
          '/payments/payment123/status',
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.getPaymentStatus('Bearer token', 'payment123');

        // Assert
        expect(result.paymentId, equals('payment123'));
        expect(result.status, equals('completed'));
        expect(result.paidAmount, equals(100000.0));
        expect(result.remainingAmount, equals(0.0));
      });

      test('should cancel payment successfully', () async {
        // Arrange
        final cancelRequest = CancelPaymentRequest(
          reason: 'Customer requested',
          requestRefund: true,
        );

        final expectedResponse = PaymentCancellationResponse(
          paymentId: 'payment123',
          status: 'cancelled',
          reason: 'Customer requested',
          cancelledAt: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/payment123/cancel',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.cancelPayment(
          'Bearer token',
          'payment123',
          cancelRequest,
        );

        // Assert
        expect(result.paymentId, equals('payment123'));
        expect(result.status, equals('cancelled'));
        expect(result.reason, equals('Customer requested'));
      });
    });

    group('Payment Method Management', () {
      test('should add payment method successfully', () async {
        // Arrange
        final addMethodRequest = AddPaymentMethodRequest(
          type: PaymentMethod.creditCard,
          provider: PaymentProvider.iamport,
          methodData: {
            'card_number': '1234567890123456',
            'exp_month': '12',
            'exp_year': '25',
          },
          setAsDefault: true,
          nickname: 'My Primary Card',
        );

        final expectedResponse = PaymentMethodResponse(
          id: 'method123',
          type: PaymentMethod.creditCard,
          provider: PaymentProvider.iamport,
          maskedDetails: '**** **** **** 3456',
          nickname: 'My Primary Card',
          isDefault: true,
          createdAt: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/methods/add',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.addPaymentMethod('Bearer token', addMethodRequest);

        // Assert
        expect(result.id, equals('method123'));
        expect(result.type, equals(PaymentMethod.creditCard));
        expect(result.maskedDetails, equals('**** **** **** 3456'));
        expect(result.isDefault, isTrue);
      });

      test('should retrieve payment methods successfully', () async {
        // Arrange
        final expectedMethods = [
          StoredPaymentMethod(
            id: 'method1',
            type: PaymentMethod.creditCard,
            provider: PaymentProvider.iamport,
            maskedDetails: '**** **** **** 1234',
            isDefault: true,
            isExpired: false,
            createdAt: DateTime.now(),
            lastUsed: DateTime.now(),
          ),
          StoredPaymentMethod(
            id: 'method2',
            type: PaymentMethod.debitCard,
            provider: PaymentProvider.bootpay,
            maskedDetails: '**** **** **** 5678',
            isDefault: false,
            isExpired: false,
            createdAt: DateTime.now(),
            lastUsed: DateTime.now(),
          ),
        ];

        final mockResponse = MockResponse<List<dynamic>>();
        when(() => mockResponse.data).thenReturn(
          expectedMethods.map((m) => m.toJson()).toList(),
        );

        when(() => mockDio.get<List<dynamic>>(
          '/payments/methods',
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.getPaymentMethods('Bearer token');

        // Assert
        expect(result.length, equals(2));
        expect(result[0].id, equals('method1'));
        expect(result[0].isDefault, isTrue);
        expect(result[1].id, equals('method2'));
        expect(result[1].isDefault, isFalse);
      });

      test('should set default payment method successfully', () async {
        // Arrange
        final expectedMethod = StoredPaymentMethod(
          id: 'method123',
          type: PaymentMethod.creditCard,
          provider: PaymentProvider.iamport,
          maskedDetails: '**** **** **** 1234',
          isDefault: true,
          isExpired: false,
          createdAt: DateTime.now(),
          lastUsed: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedMethod.toJson());

        when(() => mockDio.put<Map<String, dynamic>>(
          '/payments/methods/method123/default',
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.setDefaultPaymentMethod(
          'Bearer token',
          'method123',
        );

        // Assert
        expect(result.id, equals('method123'));
        expect(result.isDefault, isTrue);
      });
    });

    group('Installment Payments', () {
      test('should calculate installment correctly', () async {
        // Arrange
        final calculationRequest = InstallmentCalculationRequest(
          totalAmount: 1200000.0,
          currency: 'KRW',
          installmentMonths: 6,
          interestRate: 0.05,
        );

        final expectedResponse = InstallmentCalculationResponse(
          totalAmount: 1200000.0,
          monthlyAmount: 210000.0,
          totalInterest: 60000.0,
          totalToPay: 1260000.0,
          currency: 'KRW',
          installmentMonths: 6,
          breakdown: List.generate(6, (i) => InstallmentBreakdown(
            month: i + 1,
            amount: 210000.0,
            principal: 200000.0,
            interest: 10000.0,
            remainingBalance: 1000000.0 - (i * 200000.0),
            dueDate: DateTime.now().add(Duration(days: (i + 1) * 30)),
          )),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/installment/calculate',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.calculateInstallment(calculationRequest);

        // Assert
        expect(result.totalAmount, equals(1200000.0));
        expect(result.monthlyAmount, equals(210000.0));
        expect(result.totalInterest, equals(60000.0));
        expect(result.installmentMonths, equals(6));
        expect(result.breakdown.length, equals(6));
      });

      test('should setup installment payment successfully', () async {
        // Arrange
        final setupRequest = InstallmentSetupRequest(
          orderId: 'order123',
          totalAmount: 1200000.0,
          currency: 'KRW',
          installmentMonths: 6,
          paymentMethodId: 'method123',
          firstPaymentDate: DateTime.now().add(Duration(days: 30)),
        );

        final expectedResponse = InstallmentSetupResponse(
          installmentId: 'installment123',
          orderId: 'order123',
          status: 'active',
          monthlyAmount: 200000.0,
          firstPaymentDate: DateTime.now().add(Duration(days: 30)),
          lastPaymentDate: DateTime.now().add(Duration(days: 180)),
          totalInstallments: 6,
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/installment/setup',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.setupInstallmentPayment(
          'Bearer token',
          setupRequest,
        );

        // Assert
        expect(result.installmentId, equals('installment123'));
        expect(result.status, equals('active'));
        expect(result.totalInstallments, equals(6));
      });

      test('should get installment schedule successfully', () async {
        // Arrange
        final expectedSchedule = List.generate(6, (i) => InstallmentSchedule(
          installmentNumber: i + 1,
          amount: 200000.0,
          dueDate: DateTime.now().add(Duration(days: (i + 1) * 30)),
          status: i < 2 ? 'paid' : 'pending',
          paidDate: i < 2 ? DateTime.now().subtract(Duration(days: (2 - i) * 30)) : null,
          paymentId: i < 2 ? 'payment${i + 1}' : null,
        ));

        final mockResponse = MockResponse<List<dynamic>>();
        when(() => mockResponse.data).thenReturn(
          expectedSchedule.map((s) => s.toJson()).toList(),
        );

        when(() => mockDio.get<List<dynamic>>(
          '/payments/installment/installment123/schedule',
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.getInstallmentSchedule(
          'Bearer token',
          'installment123',
        );

        // Assert
        expect(result.length, equals(6));
        expect(result[0].status, equals('paid'));
        expect(result[0].paidDate, isNotNull);
        expect(result[2].status, equals('pending'));
        expect(result[2].paidDate, isNull);
      });

      test('should pay installment successfully', () async {
        // Arrange
        final paymentRequest = InstallmentPaymentRequest(
          installmentNumber: 3,
          paymentMethodId: 'method123',
        );

        final expectedResponse = InstallmentPaymentResponse(
          paymentId: 'payment789',
          installmentNumber: 3,
          amount: 200000.0,
          status: 'completed',
          paidDate: DateTime.now(),
          remainingInstallments: 3,
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/installment/installment123/pay',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.payInstallment(
          'Bearer token',
          'installment123',
          paymentRequest,
        );

        // Assert
        expect(result.paymentId, equals('payment789'));
        expect(result.installmentNumber, equals(3));
        expect(result.status, equals('completed'));
        expect(result.remainingInstallments, equals(3));
      });
    });

    group('Refund Processing', () {
      test('should process full refund successfully', () async {
        // Arrange
        final refundRequest = RefundRequest(
          reason: 'Customer cancellation',
          description: 'Trip cancelled due to emergency',
        );

        final expectedResponse = RefundResponse(
          refundId: 'refund123',
          paymentId: 'payment123',
          amount: 100000.0,
          currency: 'KRW',
          status: 'processing',
          reason: 'Customer cancellation',
          initiatedAt: DateTime.now(),
          estimatedProcessingTime: '3-5 business days',
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/payment123/refund',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.processRefund(
          'Bearer token',
          'payment123',
          refundRequest,
        );

        // Assert
        expect(result.refundId, equals('refund123'));
        expect(result.status, equals('processing'));
        expect(result.reason, equals('Customer cancellation'));
        expect(result.estimatedProcessingTime, equals('3-5 business days'));
      });

      test('should process partial refund successfully', () async {
        // Arrange
        final refundRequest = RefundRequest(
          amount: 50000.0,
          reason: 'Partial service cancellation',
        );

        final expectedResponse = RefundResponse(
          refundId: 'refund124',
          paymentId: 'payment123',
          amount: 50000.0,
          currency: 'KRW',
          status: 'processing',
          reason: 'Partial service cancellation',
          initiatedAt: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/payment123/refund',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.processRefund(
          'Bearer token',
          'payment123',
          refundRequest,
        );

        // Assert
        expect(result.refundId, equals('refund124'));
        expect(result.amount, equals(50000.0));
        expect(result.reason, equals('Partial service cancellation'));
      });

      test('should get refund details successfully', () async {
        // Arrange
        final expectedRefund = RefundDetails(
          id: 'refund123',
          paymentId: 'payment123',
          amount: 100000.0,
          currency: 'KRW',
          status: 'completed',
          reason: 'Customer cancellation',
          initiatedAt: DateTime.now().subtract(Duration(days: 3)),
          processedAt: DateTime.now(),
          providerRefundId: 'provider_refund_456',
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedRefund.toJson());

        when(() => mockDio.get<Map<String, dynamic>>(
          '/refunds/refund123',
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.getRefund('Bearer token', 'refund123');

        // Assert
        expect(result.id, equals('refund123'));
        expect(result.status, equals('completed'));
        expect(result.processedAt, isNotNull);
        expect(result.providerRefundId, equals('provider_refund_456'));
      });
    });

    group('Split Payments', () {
      test('should setup split payment successfully', () async {
        // Arrange
        final setupRequest = SplitPaymentSetupRequest(
          orderId: 'order123',
          totalAmount: 600000.0,
          currency: 'KRW',
          participants: [
            SplitParticipant(
              userId: 'user1',
              name: 'John Doe',
              email: 'john@example.com',
              amount: 300000.0,
            ),
            SplitParticipant(
              userId: 'user2',
              name: 'Jane Smith',
              email: 'jane@example.com',
              amount: 300000.0,
            ),
          ],
          splitMethod: 'equal',
          deadline: DateTime.now().add(Duration(days: 7)),
        );

        final expectedResponse = SplitPaymentSetup(
          splitPaymentId: 'split123',
          orderId: 'order123',
          status: 'pending',
          createdAt: DateTime.now(),
          deadline: DateTime.now().add(Duration(days: 7)),
          participants: [
            SplitPaymentParticipant(
              userId: 'user1',
              name: 'John Doe',
              email: 'john@example.com',
              amount: 300000.0,
              status: 'pending',
            ),
            SplitPaymentParticipant(
              userId: 'user2',
              name: 'Jane Smith',
              email: 'jane@example.com',
              amount: 300000.0,
              status: 'pending',
            ),
          ],
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/split/setup',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.setupSplitPayment(
          'Bearer token',
          setupRequest,
        );

        // Assert
        expect(result.splitPaymentId, equals('split123'));
        expect(result.status, equals('pending'));
        expect(result.participants.length, equals(2));
        expect(result.participants[0].amount, equals(300000.0));
      });

      test('should pay split payment portion successfully', () async {
        // Arrange
        final paymentRequest = SplitPaymentRequest(
          participantUserId: 'user1',
          paymentMethodId: 'method123',
        );

        final expectedResponse = SplitPaymentResponse(
          paymentId: 'payment789',
          participantUserId: 'user1',
          amount: 300000.0,
          status: 'completed',
          paidAt: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/split/split123/pay',
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.paySplitPayment(
          'Bearer token',
          'split123',
          paymentRequest,
        );

        // Assert
        expect(result.paymentId, equals('payment789'));
        expect(result.participantUserId, equals('user1'));
        expect(result.amount, equals(300000.0));
        expect(result.status, equals('completed'));
      });

      test('should get split payment details successfully', () async {
        // Arrange
        final expectedDetails = SplitPaymentDetails(
          id: 'split123',
          orderId: 'order123',
          totalAmount: 600000.0,
          paidAmount: 300000.0,
          remainingAmount: 300000.0,
          currency: 'KRW',
          status: 'partial',
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          deadline: DateTime.now().add(Duration(days: 5)),
          participants: [
            SplitPaymentParticipant(
              userId: 'user1',
              name: 'John Doe',
              email: 'john@example.com',
              amount: 300000.0,
              status: 'paid',
              paidAt: DateTime.now().subtract(Duration(hours: 2)),
              paymentId: 'payment789',
            ),
            SplitPaymentParticipant(
              userId: 'user2',
              name: 'Jane Smith',
              email: 'jane@example.com',
              amount: 300000.0,
              status: 'pending',
            ),
          ],
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedDetails.toJson());

        when(() => mockDio.get<Map<String, dynamic>>(
          '/payments/split/split123',
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.getSplitPaymentDetails(
          'Bearer token',
          'split123',
        );

        // Assert
        expect(result.id, equals('split123'));
        expect(result.totalAmount, equals(600000.0));
        expect(result.paidAmount, equals(300000.0));
        expect(result.remainingAmount, equals(300000.0));
        expect(result.status, equals('partial'));
        expect(result.participants[0].status, equals('paid'));
        expect(result.participants[1].status, equals('pending'));
      });
    });

    group('Currency and Exchange', () {
      test('should get supported currencies successfully', () async {
        // Arrange
        final expectedCurrencies = [
          SupportedCurrency(
            code: 'KRW',
            name: 'Korean Won',
            symbol: '₩',
            decimalPlaces: 0,
            isEnabled: true,
          ),
          SupportedCurrency(
            code: 'USD',
            name: 'US Dollar',
            symbol: '\$',
            decimalPlaces: 2,
            isEnabled: true,
          ),
          SupportedCurrency(
            code: 'JPY',
            name: 'Japanese Yen',
            symbol: '¥',
            decimalPlaces: 0,
            isEnabled: true,
          ),
        ];

        final mockResponse = MockResponse<List<dynamic>>();
        when(() => mockResponse.data).thenReturn(
          expectedCurrencies.map((c) => c.toJson()).toList(),
        );

        when(() => mockDio.get<List<dynamic>>(
          '/payments/currencies',
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.getSupportedCurrencies();

        // Assert
        expect(result.length, equals(3));
        expect(result[0].code, equals('KRW'));
        expect(result[0].symbol, equals('₩'));
        expect(result[1].code, equals('USD'));
        expect(result[2].code, equals('JPY'));
      });

      test('should get exchange rates successfully', () async {
        // Arrange
        final query = ExchangeRateQuery(
          baseCurrency: 'KRW',
          targetCurrencies: ['USD', 'JPY'],
        );

        final expectedResponse = ExchangeRatesResponse(
          baseCurrency: 'KRW',
          rates: {
            'USD': 0.00075,
            'JPY': 0.11,
          },
          timestamp: DateTime.now(),
          validUntil: DateTime.now().add(Duration(hours: 1)),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.get<Map<String, dynamic>>(
          '/payments/exchange-rates',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.getExchangeRates(query);

        // Assert
        expect(result.baseCurrency, equals('KRW'));
        expect(result.rates['USD'], equals(0.00075));
        expect(result.rates['JPY'], equals(0.11));
      });

      test('should convert currency successfully', () async {
        // Arrange
        final conversionRequest = CurrencyConversionRequest(
          amount: 1000000.0,
          fromCurrency: 'KRW',
          toCurrency: 'USD',
        );

        final expectedResponse = CurrencyConversionResponse(
          originalAmount: 1000000.0,
          fromCurrency: 'KRW',
          convertedAmount: 750.0,
          toCurrency: 'USD',
          exchangeRate: 0.00075,
          timestamp: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/currency/convert',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.convertCurrency(conversionRequest);

        // Assert
        expect(result.originalAmount, equals(1000000.0));
        expect(result.fromCurrency, equals('KRW'));
        expect(result.convertedAmount, equals(750.0));
        expect(result.toCurrency, equals('USD'));
        expect(result.exchangeRate, equals(0.00075));
      });
    });

    group('Payment Verification', () {
      test('should verify payment successfully', () async {
        // Arrange
        final verificationRequest = PaymentVerificationRequest(
          paymentId: 'payment123',
          providerTransactionId: 'txn456',
          provider: PaymentProvider.iamport,
          verificationData: {
            'signature': 'abc123def456',
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          },
        );

        final expectedResponse = PaymentVerificationResponse(
          paymentId: 'payment123',
          isValid: true,
          status: 'verified',
          verifiedAmount: 100000.0,
          currency: 'KRW',
          verificationTime: DateTime.now(),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/verify',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.verifyPayment(verificationRequest);

        // Assert
        expect(result.paymentId, equals('payment123'));
        expect(result.isValid, isTrue);
        expect(result.status, equals('verified'));
        expect(result.verifiedAmount, equals(100000.0));
      });

      test('should handle webhook successfully', () async {
        // Arrange
        final webhookPayload = {
          'event_type': 'payment.completed',
          'payment_id': 'payment123',
          'amount': 100000.0,
          'currency': 'KRW',
        };

        final expectedResponse = WebhookResponse(
          processed: true,
          message: 'Webhook processed successfully',
          data: {'payment_status': 'updated'},
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedResponse.toJson());

        when(() => mockDio.post<Map<String, dynamic>>(
          '/payments/webhook/iamport',
          data: any(named: 'data'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.handleWebhook('iamport', webhookPayload);

        // Assert
        expect(result.processed, isTrue);
        expect(result.message, equals('Webhook processed successfully'));
        expect(result.data?['payment_status'], equals('updated'));
      });
    });

    group('Payment Analytics', () {
      test('should get payment analytics summary successfully', () async {
        // Arrange
        final query = PaymentAnalyticsQuery(
          startDate: DateTime.now().subtract(Duration(days: 30)),
          endDate: DateTime.now(),
          groupBy: 'day',
          providers: [PaymentProvider.iamport, PaymentProvider.bootpay],
        );

        final expectedSummary = PaymentAnalyticsSummary(
          totalRevenue: 10000000.0,
          currency: 'KRW',
          totalTransactions: 100,
          successfulTransactions: 95,
          failedTransactions: 5,
          successRate: 0.95,
          averageTransactionAmount: 100000.0,
          revenueByProvider: {
            'iamport': 6000000.0,
            'bootpay': 4000000.0,
          },
          revenueByMethod: {
            'creditCard': 8000000.0,
            'bankTransfer': 2000000.0,
          },
          trends: List.generate(7, (i) => PaymentTrend(
            date: DateTime.now().subtract(Duration(days: i)),
            revenue: 1000000.0,
            transactionCount: 10,
            averageAmount: 100000.0,
          )),
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(expectedSummary.toJson());

        when(() => mockDio.get<Map<String, dynamic>>(
          '/payments/analytics/summary',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await paymentService.getPaymentAnalytics('Bearer token', query);

        // Assert
        expect(result.totalRevenue, equals(10000000.0));
        expect(result.totalTransactions, equals(100));
        expect(result.successRate, equals(0.95));
        expect(result.revenueByProvider['iamport'], equals(6000000.0));
        expect(result.trends.length, equals(7));
      });
    });
  });

  group('Payment Models Tests', () {
    group('PaymentRequest', () {
      test('should serialize and deserialize correctly', () {
        final paymentRequest = PaymentRequest(
          orderId: 'order123',
          amount: 100000.0,
          currency: 'KRW',
          paymentMethod: PaymentMethod.creditCard,
          provider: PaymentProvider.iamport,
          paymentData: {
            'card_number': '1234567890123456',
            'exp_month': '12',
            'exp_year': '25',
          },
          customerEmail: 'test@example.com',
          savePaymentMethod: true,
        );

        final json = paymentRequest.toJson();
        final deserialized = PaymentRequest.fromJson(json);

        expect(deserialized.orderId, equals(paymentRequest.orderId));
        expect(deserialized.amount, equals(paymentRequest.amount));
        expect(deserialized.currency, equals(paymentRequest.currency));
        expect(deserialized.paymentMethod, equals(paymentRequest.paymentMethod));
        expect(deserialized.provider, equals(paymentRequest.provider));
        expect(deserialized.customerEmail, equals(paymentRequest.customerEmail));
        expect(deserialized.savePaymentMethod, equals(paymentRequest.savePaymentMethod));
      });
    });

    group('PaymentResponse', () {
      test('should handle all response fields correctly', () {
        final paymentResponse = PaymentResponse(
          paymentId: 'payment123',
          status: 'processing',
          redirectUrl: 'https://payment.provider.com/redirect/123',
          qrCode: 'data:image/png;base64,iVBORw0KGgoAAAANSUhE...',
          deepLink: 'payment://app/process/123',
          provider: PaymentProvider.iamport,
          providerTransactionId: 'txn456',
          createdAt: DateTime.now(),
          additionalData: {
            'gateway_response': 'success',
            'risk_score': 0.1,
          },
        );

        expect(paymentResponse.paymentId, equals('payment123'));
        expect(paymentResponse.status, equals('processing'));
        expect(paymentResponse.redirectUrl, isNotNull);
        expect(paymentResponse.qrCode, isNotNull);
        expect(paymentResponse.deepLink, isNotNull);
        expect(paymentResponse.additionalData?['risk_score'], equals(0.1));
      });
    });

    group('InstallmentCalculationResponse', () {
      test('should calculate installment breakdown correctly', () {
        final response = InstallmentCalculationResponse(
          totalAmount: 1200000.0,
          monthlyAmount: 210000.0,
          totalInterest: 60000.0,
          totalToPay: 1260000.0,
          currency: 'KRW',
          installmentMonths: 6,
          breakdown: [
            InstallmentBreakdown(
              month: 1,
              amount: 210000.0,
              principal: 200000.0,
              interest: 10000.0,
              remainingBalance: 1000000.0,
              dueDate: DateTime.now().add(Duration(days: 30)),
            ),
          ],
        );

        expect(response.totalAmount, equals(1200000.0));
        expect(response.totalToPay, equals(1260000.0));
        expect(response.totalInterest, equals(60000.0));
        expect(response.breakdown.first.principal, equals(200000.0));
        expect(response.breakdown.first.interest, equals(10000.0));
      });
    });

    group('SplitPaymentSetupRequest', () {
      test('should handle equal split correctly', () {
        final request = SplitPaymentSetupRequest(
          orderId: 'order123',
          totalAmount: 600000.0,
          currency: 'KRW',
          participants: [
            SplitParticipant(
              userId: 'user1',
              name: 'John',
              email: 'john@example.com',
              amount: 300000.0,
              percentage: 50.0,
            ),
            SplitParticipant(
              userId: 'user2',
              name: 'Jane',
              email: 'jane@example.com',
              amount: 300000.0,
              percentage: 50.0,
            ),
          ],
          splitMethod: 'equal',
        );

        expect(request.totalAmount, equals(600000.0));
        expect(request.participants.length, equals(2));
        expect(request.participants[0].amount, equals(300000.0));
        expect(request.participants[0].percentage, equals(50.0));
        expect(request.splitMethod, equals('equal'));
      });
    });

    group('RefundRequest', () {
      test('should handle full refund (null amount)', () {
        final request = RefundRequest(
          reason: 'Customer cancellation',
          description: 'Trip cancelled due to emergency',
        );

        expect(request.amount, isNull);
        expect(request.reason, equals('Customer cancellation'));
      });

      test('should handle partial refund', () {
        final request = RefundRequest(
          amount: 50000.0,
          reason: 'Partial service cancellation',
        );

        expect(request.amount, equals(50000.0));
        expect(request.reason, equals('Partial service cancellation'));
      });
    });
  });

  group('Payment Enums Tests', () {
    test('PaymentMethod enum should have correct values', () {
      expect(PaymentMethod.values.length, equals(5));
      expect(PaymentMethod.values, contains(PaymentMethod.creditCard));
      expect(PaymentMethod.values, contains(PaymentMethod.debitCard));
      expect(PaymentMethod.values, contains(PaymentMethod.bankTransfer));
      expect(PaymentMethod.values, contains(PaymentMethod.digitalWallet));
      expect(PaymentMethod.values, contains(PaymentMethod.cryptocurrency));
    });

    test('PaymentProvider enum should have correct values', () {
      expect(PaymentProvider.values.length, equals(4));
      expect(PaymentProvider.values, contains(PaymentProvider.iamport));
      expect(PaymentProvider.values, contains(PaymentProvider.bootpay));
      expect(PaymentProvider.values, contains(PaymentProvider.stripe));
      expect(PaymentProvider.values, contains(PaymentProvider.paypal));
    });
  });

  group('Error Handling Tests', () {
    late PaymentService paymentService;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      paymentService = PaymentService(mockDio);
    });

    test('should handle network errors gracefully', () async {
      // Arrange
      final paymentRequest = PaymentRequest(
        orderId: 'order123',
        amount: 100000.0,
        currency: 'KRW',
        paymentMethod: PaymentMethod.creditCard,
        provider: PaymentProvider.iamport,
        paymentData: {},
      );

      when(() => mockDio.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/payments/process'),
        type: DioExceptionType.connectionTimeout,
        message: 'Connection timeout',
      ));

      // Act & Assert
      expect(
        () => paymentService.processPayment('Bearer token', paymentRequest),
        throwsA(predicate((e) => 
          e is DioException && 
          e.type == DioExceptionType.connectionTimeout
        )),
      );
    });

    test('should handle authentication errors', () async {
      // Arrange
      when(() => mockDio.get<List<dynamic>>(
        '/payments/methods',
        options: any(named: 'options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/payments/methods'),
        response: Response(
          requestOptions: RequestOptions(path: '/payments/methods'),
          statusCode: 401,
          data: {'error': 'Unauthorized'},
        ),
      ));

      // Act & Assert
      expect(
        () => paymentService.getPaymentMethods('Bearer invalid_token'),
        throwsA(predicate((e) => 
          e is DioException && 
          e.response?.statusCode == 401
        )),
      );
    });

    test('should handle validation errors', () async {
      // Arrange
      final invalidPaymentRequest = PaymentRequest(
        orderId: '', // Invalid empty order ID
        amount: -100.0, // Invalid negative amount
        currency: 'KRW',
        paymentMethod: PaymentMethod.creditCard,
        provider: PaymentProvider.iamport,
        paymentData: {},
      );

      when(() => mockDio.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/payments/process'),
        response: Response(
          requestOptions: RequestOptions(path: '/payments/process'),
          statusCode: 400,
          data: {
            'error': 'Validation failed',
            'details': {
              'orderId': 'Order ID cannot be empty',
              'amount': 'Amount must be positive',
            },
          },
        ),
      ));

      // Act & Assert
      expect(
        () => paymentService.processPayment('Bearer token', invalidPaymentRequest),
        throwsA(predicate((e) => 
          e is DioException && 
          e.response?.statusCode == 400
        )),
      );
    });
  });
}