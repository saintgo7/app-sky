import 'package:flutter_test/flutter_test.dart';
import 'package:travelmate/data/models/booking_model.dart';

void main() {
  group('BookingModel Tests', () {
    late BookingModel testBooking;
    late DateTime testDateTime;
    late List<TravelerInfo> testTravelers;
    late BookingPricing testPricing;
    late PaymentInfo testPaymentInfo;

    setUp(() {
      testDateTime = DateTime(2024, 6, 15);
      
      testTravelers = [
        TravelerInfo(
          id: 'traveler1',
          firstName: 'John',
          lastName: 'Doe',
          dateOfBirth: DateTime(1990, 1, 1),
          gender: 'Male',
          nationality: 'US',
          passportNumber: 'ABC123456',
          passportExpiry: DateTime(2030, 1, 1),
          isMainContact: true,
          email: 'john@example.com',
          phone: '+1234567890',
        ),
      ];

      testPricing = BookingPricing(
        basePrice: 1000.0,
        totalPrice: 1150.0,
        currency: 'USD',
        breakdown: [
          PriceBreakdown(
            itemType: 'package',
            description: 'Travel Package',
            amount: 1000.0,
            quantity: 1,
          ),
        ],
        taxAmount: 100.0,
        servicesFee: 50.0,
      );

      testPaymentInfo = PaymentInfo(
        transactions: [
          PaymentTransaction(
            id: 'txn1',
            amount: 1150.0,
            currency: 'USD',
            paymentMethod: 'Credit Card',
            status: PaymentStatus.paid,
            transactionDate: testDateTime,
            transactionReference: 'REF123',
          ),
        ],
        installmentPayment: false,
      );

      testBooking = BookingModel(
        id: 'booking123',
        userId: 'user123',
        bookingType: BookingType.individual,
        packageId: 'package456',
        packageTitle: 'Seoul Adventure Package',
        travelStartDate: testDateTime.add(Duration(days: 30)),
        travelEndDate: testDateTime.add(Duration(days: 37)),
        numberOfTravelers: 1,
        travelers: testTravelers,
        pricing: testPricing,
        paymentInfo: testPaymentInfo,
        status: BookingStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );
    });

    test('should create BookingModel with required fields', () {
      expect(testBooking.id, 'booking123');
      expect(testBooking.userId, 'user123');
      expect(testBooking.bookingType, BookingType.individual);
      expect(testBooking.packageTitle, 'Seoul Adventure Package');
      expect(testBooking.numberOfTravelers, 1);
      expect(testBooking.status, BookingStatus.confirmed);
      expect(testBooking.paymentStatus, PaymentStatus.paid);
    });

    test('should serialize and deserialize to/from JSON correctly', () {
      final json = testBooking.toJson();
      final deserializedBooking = BookingModel.fromJson(json);
      
      expect(deserializedBooking.id, testBooking.id);
      expect(deserializedBooking.userId, testBooking.userId);
      expect(deserializedBooking.packageTitle, testBooking.packageTitle);
      expect(deserializedBooking.status, testBooking.status);
      expect(deserializedBooking.paymentStatus, testBooking.paymentStatus);
      expect(deserializedBooking.numberOfTravelers, testBooking.numberOfTravelers);
    });

    test('should handle group booking correctly', () {
      final groupBooking = BookingModel(
        id: 'group123',
        userId: 'user123',
        bookingType: BookingType.group,
        groupId: 'group456',
        packageId: 'package789',
        packageTitle: 'Group Tour Package',
        travelStartDate: testDateTime.add(Duration(days: 60)),
        travelEndDate: testDateTime.add(Duration(days: 70)),
        numberOfTravelers: 5,
        travelers: List.generate(5, (i) => TravelerInfo(
          id: 'traveler$i',
          firstName: 'Person$i',
          lastName: 'Test',
          dateOfBirth: DateTime(1990 + i, 1, 1),
          gender: 'Male',
          nationality: 'US',
          passportNumber: 'ABC${123456 + i}',
          passportExpiry: DateTime(2030, 1, 1),
          isMainContact: i == 0,
        )),
        pricing: testPricing.copyWith(totalPrice: 5000.0),
        paymentInfo: testPaymentInfo,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.pending,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      expect(groupBooking.bookingType, BookingType.group);
      expect(groupBooking.groupId, 'group456');
      expect(groupBooking.numberOfTravelers, 5);
      expect(groupBooking.travelers.length, 5);
    });

    test('should handle additional services', () {
      final services = [
        AdditionalService(
          id: 'service1',
          name: 'Airport Transfer',
          description: 'Round-trip airport transfer',
          price: 50.0,
          quantity: 1,
          isOptional: true,
        ),
        AdditionalService(
          id: 'service2',
          name: 'Travel Insurance',
          description: 'Comprehensive travel insurance',
          price: 100.0,
          quantity: 1,
          isOptional: false,
        ),
      ];

      final bookingWithServices = BookingModel(
        id: 'booking_services',
        userId: 'user123',
        bookingType: BookingType.individual,
        packageId: 'package456',
        packageTitle: 'Package with Services',
        travelStartDate: testDateTime.add(Duration(days: 30)),
        travelEndDate: testDateTime.add(Duration(days: 37)),
        numberOfTravelers: 1,
        travelers: testTravelers,
        pricing: testPricing,
        paymentInfo: testPaymentInfo,
        status: BookingStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        additionalServices: services,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      expect(bookingWithServices.additionalServices?.length, 2);
      expect(bookingWithServices.additionalServices?[0].name, 'Airport Transfer');
      expect(bookingWithServices.additionalServices?[1].isOptional, isFalse);
    });
  });

  group('TravelerInfo Tests', () {
    test('should handle passport validation fields', () {
      final traveler = TravelerInfo(
        id: 'traveler1',
        firstName: 'Jane',
        lastName: 'Smith',
        middleName: 'Marie',
        dateOfBirth: DateTime(1985, 3, 15),
        gender: 'Female',
        nationality: 'CA',
        passportNumber: 'CA987654321',
        passportExpiry: DateTime(2028, 12, 31),
        visaStatus: 'Required',
        phone: '+1987654321',
        email: 'jane.smith@example.com',
        isMainContact: false,
        relationship: 'Spouse',
      );

      expect(traveler.middleName, 'Marie');
      expect(traveler.visaStatus, 'Required');
      expect(traveler.relationship, 'Spouse');
      expect(traveler.isMainContact, isFalse);
    });

    test('should serialize and deserialize correctly', () {
      final traveler = TravelerInfo(
        id: 'traveler1',
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'Male',
        nationality: 'US',
        passportNumber: 'ABC123456',
        passportExpiry: DateTime(2030, 1, 1),
        isMainContact: true,
      );

      final json = traveler.toJson();
      final deserialized = TravelerInfo.fromJson(json);

      expect(deserialized.id, traveler.id);
      expect(deserialized.firstName, traveler.firstName);
      expect(deserialized.passportNumber, traveler.passportNumber);
      expect(deserialized.isMainContact, traveler.isMainContact);
    });
  });

  group('BookingPricing Tests', () {
    test('should calculate pricing correctly', () {
      final pricing = BookingPricing(
        basePrice: 1000.0,
        totalPrice: 1200.0,
        currency: 'USD',
        breakdown: [
          PriceBreakdown(itemType: 'accommodation', description: 'Hotel', amount: 800.0, quantity: 7),
          PriceBreakdown(itemType: 'flight', description: 'Round-trip flights', amount: 200.0, quantity: 1),
        ],
        discountAmount: 50.0,
        discountCode: 'SAVE50',
        taxAmount: 150.0,
        servicesFee: 100.0,
      );

      expect(pricing.basePrice, 1000.0);
      expect(pricing.totalPrice, 1200.0);
      expect(pricing.discountAmount, 50.0);
      expect(pricing.discountCode, 'SAVE50');
      expect(pricing.breakdown.length, 2);
    });
  });

  group('PaymentTransaction Tests', () {
    test('should handle different payment statuses', () {
      final failedTransaction = PaymentTransaction(
        id: 'failed_txn',
        amount: 100.0,
        currency: 'USD',
        paymentMethod: 'Credit Card',
        status: PaymentStatus.failed,
        transactionDate: DateTime.now(),
        failureReason: 'Insufficient funds',
      );

      expect(failedTransaction.status, PaymentStatus.failed);
      expect(failedTransaction.failureReason, 'Insufficient funds');
    });
  });

  group('BookingStatus Tests', () {
    test('should have correct enum values', () {
      expect(BookingStatus.values.length, 6);
      expect(BookingStatus.values, [
        BookingStatus.pending,
        BookingStatus.confirmed,
        BookingStatus.paid,
        BookingStatus.cancelled,
        BookingStatus.completed,
        BookingStatus.refunded,
      ]);
    });
  });

  group('PaymentStatus Tests', () {
    test('should have correct enum values', () {
      expect(PaymentStatus.values.length, 6);
      expect(PaymentStatus.values, [
        PaymentStatus.pending,
        PaymentStatus.processing,
        PaymentStatus.paid,
        PaymentStatus.failed,
        PaymentStatus.refunded,
        PaymentStatus.partialRefund,
      ]);
    });
  });
}

extension BookingPricingExtension on BookingPricing {
  BookingPricing copyWith({double? totalPrice}) {
    return BookingPricing(
      basePrice: basePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency,
      breakdown: breakdown,
      discountAmount: discountAmount,
      discountCode: discountCode,
      taxAmount: taxAmount,
      servicesFee: servicesFee,
    );
  }
}