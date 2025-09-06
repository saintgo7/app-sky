import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:travelmate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Real-time Updates Integration Tests', () {
    late io.Socket mockSocket;

    setUp(() async {
      // Initialize mock socket for testing
      mockSocket = io.io('http://test.socket.server');
    });

    tearDown(() async {
      mockSocket.disconnect();
    });

    testWidgets('Real-time booking status updates', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login and create booking
      await _performLogin(tester, 'realtime@example.com', 'password123');
      await _createTestBooking(tester);

      // Navigate to My Trips
      await tester.tap(find.text('My Trips'));
      await tester.pumpAndSettle();

      // Initial booking status
      expect(find.text('Processing'), findsOneWidget);

      // Simulate real-time status update
      await _simulateStatusUpdate(tester, 'booking_confirmed', {
        'booking_id': 'test_booking_123',
        'status': 'confirmed',
        'confirmation_number': 'TM123456789'
      });

      // Verify status update in UI
      await tester.pumpAndSettle();
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('TM123456789'), findsOneWidget);
    });

    testWidgets('Real-time payment notifications', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'payment@example.com', 'password123');

      // Navigate to payments section
      await tester.tap(find.text('Payments'));
      await tester.pumpAndSettle();

      // Simulate payment processing notification
      await _simulatePaymentNotification(tester, {
        'type': 'payment_processing',
        'payment_id': 'pay_123',
        'amount': 1000000.0,
        'currency': 'KRW',
        'status': 'processing'
      });

      await tester.pumpAndSettle();
      expect(find.text('Payment processing...'), findsOneWidget);

      // Simulate payment success
      await _simulatePaymentNotification(tester, {
        'type': 'payment_success',
        'payment_id': 'pay_123',
        'amount': 1000000.0,
        'currency': 'KRW',
        'status': 'completed'
      });

      await tester.pumpAndSettle();
      expect(find.text('Payment completed'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Real-time group booking notifications', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'group.member@example.com', 'password123');

      // Navigate to group section
      await tester.tap(find.text('Groups'));
      await tester.pumpAndSettle();

      // Simulate group invitation
      await _simulateGroupNotification(tester, {
        'type': 'group_invitation',
        'group_id': 'group_123',
        'group_name': 'Tokyo Adventure 2024',
        'organizer': 'John Doe',
        'invited_by': 'jane.doe@example.com'
      });

      await tester.pumpAndSettle();
      expect(find.text('Group Invitation'), findsOneWidget);
      expect(find.text('Tokyo Adventure 2024'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);

      // Accept invitation
      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      // Simulate payment request for group member
      await _simulateGroupNotification(tester, {
        'type': 'payment_request',
        'group_id': 'group_123',
        'amount': 250000.0,
        'currency': 'KRW',
        'due_date': DateTime.now().add(Duration(days: 3)).toIso8601String()
      });

      await tester.pumpAndSettle();
      expect(find.text('Payment Required'), findsOneWidget);
      expect(find.text('₩250,000'), findsOneWidget);
    });

    testWidgets('Real-time flight status updates', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'flight@example.com', 'password123');

      // Create booking with flight
      await _createBookingWithFlight(tester);

      // Navigate to My Trips
      await tester.tap(find.text('My Trips'));
      await tester.pumpAndSettle();

      // Tap on booking to view details
      await tester.tap(find.text('Seoul Flight Package'));
      await tester.pumpAndSettle();

      // Initial flight status
      expect(find.text('On Time'), findsOneWidget);

      // Simulate flight delay notification
      await _simulateFlightStatusUpdate(tester, {
        'flight_number': 'KE001',
        'status': 'delayed',
        'delay_minutes': 45,
        'reason': 'Weather conditions',
        'new_departure': '14:30',
        'new_arrival': '16:15'
      });

      await tester.pumpAndSettle();
      expect(find.text('Delayed'), findsOneWidget);
      expect(find.text('45 min'), findsOneWidget);
      expect(find.text('Weather conditions'), findsOneWidget);

      // Verify notification appears
      expect(find.text('Flight Delay Alert'), findsOneWidget);
    });

    testWidgets('Real-time hotel booking confirmations', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'hotel@example.com', 'password123');

      // Create hotel booking
      await _createHotelBooking(tester);

      // Simulate hotel confirmation
      await _simulateHotelUpdate(tester, {
        'booking_id': 'hotel_booking_123',
        'hotel_name': 'Seoul Grand Hotel',
        'status': 'confirmed',
        'room_number': '1205',
        'check_in': '15:00',
        'check_out': '11:00',
        'confirmation_code': 'SGH123456'
      });

      await tester.pumpAndSettle();
      expect(find.text('Hotel Confirmed'), findsOneWidget);
      expect(find.text('Room 1205'), findsOneWidget);
      expect(find.text('SGH123456'), findsOneWidget);
    });

    testWidgets('Real-time chat and support notifications', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'chat@example.com', 'password123');

      // Open support chat
      await tester.tap(find.byIcon(Icons.chat));
      await tester.pumpAndSettle();

      // Send message
      await tester.enterText(find.byKey(Key('chat_input')), 'I need help with my booking');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Simulate agent response
      await _simulateChatMessage(tester, {
        'from': 'agent',
        'message': 'Hello! I\'d be happy to help you with your booking. Could you please provide your confirmation number?',
        'timestamp': DateTime.now().toIso8601String(),
        'agent_name': 'Sarah Kim'
      });

      await tester.pumpAndSettle();
      expect(find.text('Sarah Kim'), findsOneWidget);
      expect(find.textContaining('confirmation number'), findsOneWidget);

      // Test typing indicator
      await _simulateTypingIndicator(tester, {
        'agent_name': 'Sarah Kim',
        'is_typing': true
      });

      await tester.pumpAndSettle();
      expect(find.text('Sarah Kim is typing...'), findsOneWidget);
    });

    testWidgets('Real-time weather and travel alerts', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'weather@example.com', 'password123');

      // Create booking for weather-sensitive destination
      await _createBookingForDestination(tester, 'Busan Beach Resort');

      // Simulate weather alert
      await _simulateWeatherAlert(tester, {
        'destination': 'Busan',
        'alert_type': 'typhoon_warning',
        'severity': 'moderate',
        'message': 'Typhoon approaching. Beach activities may be affected.',
        'valid_until': DateTime.now().add(Duration(days: 2)).toIso8601String(),
        'recommendations': ['Stay indoors during peak hours', 'Check with hotel for safety procedures']
      });

      await tester.pumpAndSettle();
      expect(find.text('Weather Alert'), findsOneWidget);
      expect(find.text('Typhoon Warning'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);

      // Tap to view full alert
      await tester.tap(find.text('Weather Alert'));
      await tester.pumpAndSettle();

      expect(find.text('Beach activities may be affected'), findsOneWidget);
      expect(find.text('Stay indoors during peak hours'), findsOneWidget);
    });

    testWidgets('Real-time price drop notifications', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'pricewatch@example.com', 'password123');

      // Set up price alert
      await _setupPriceAlert(tester, 'Tokyo Winter Package', 1800000.0);

      // Simulate price drop
      await _simulatePriceDropAlert(tester, {
        'package_id': 'tokyo_winter_123',
        'package_name': 'Tokyo Winter Package',
        'original_price': 2000000.0,
        'new_price': 1750000.0,
        'discount_percentage': 12.5,
        'valid_until': DateTime.now().add(Duration(hours: 24)).toIso8601String()
      });

      await tester.pumpAndSettle();
      expect(find.text('Price Drop Alert'), findsOneWidget);
      expect(find.text('12.5% OFF'), findsOneWidget);
      expect(find.text('₩1,750,000'), findsOneWidget);

      // Quick booking from notification
      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      // Should navigate to booking with discounted price
      expect(find.text('Tokyo Winter Package'), findsOneWidget);
      expect(find.textContaining('Special Price'), findsOneWidget);
    });

    testWidgets('Real-time system maintenance notifications', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'maintenance@example.com', 'password123');

      // Simulate maintenance notification
      await _simulateMaintenanceAlert(tester, {
        'type': 'scheduled_maintenance',
        'title': 'Scheduled Maintenance',
        'message': 'Payment system will be unavailable from 2:00 AM to 4:00 AM KST for maintenance.',
        'start_time': '2024-12-25T02:00:00+09:00',
        'end_time': '2024-12-25T04:00:00+09:00',
        'affected_services': ['payments', 'bookings']
      });

      await tester.pumpAndSettle();
      expect(find.text('System Maintenance'), findsOneWidget);
      expect(find.textContaining('2:00 AM to 4:00 AM'), findsOneWidget);
      expect(find.byIcon(Icons.build), findsOneWidget);
    });

    testWidgets('Real-time connection recovery', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'connection@example.com', 'password123');

      // Simulate connection loss
      await _simulateConnectionLoss(tester);
      await tester.pumpAndSettle();

      expect(find.text('Connection Lost'), findsOneWidget);
      expect(find.text('Reconnecting...'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);

      // Simulate connection recovery
      await _simulateConnectionRecovery(tester);
      await tester.pumpAndSettle();

      expect(find.text('Connected'), findsOneWidget);
      expect(find.byIcon(Icons.wifi), findsOneWidget);

      // Verify missed notifications are received
      await _simulateMissedNotifications(tester, [
        {
          'type': 'booking_update',
          'message': 'Your booking has been confirmed',
          'timestamp': DateTime.now().subtract(Duration(minutes: 5)).toIso8601String()
        },
        {
          'type': 'payment_success',
          'message': 'Payment completed successfully',
          'timestamp': DateTime.now().subtract(Duration(minutes: 3)).toIso8601String()
        }
      ]);

      await tester.pumpAndSettle();
      expect(find.text('2 missed notifications'), findsOneWidget);
    });

    testWidgets('Real-time multi-language notifications', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login with Korean locale preference
      await _performLoginWithLocale(tester, 'multilang@example.com', 'password123', 'ko');

      // Simulate notification in Korean
      await _simulateLocalizedNotification(tester, {
        'type': 'booking_confirmed',
        'locale': 'ko',
        'title': '예약 확인',
        'message': '서울 어드벤처 패키지 예약이 확인되었습니다.',
        'booking_id': 'korean_booking_123'
      });

      await tester.pumpAndSettle();
      expect(find.text('예약 확인'), findsOneWidget);
      expect(find.text('서울 어드벤처 패키지 예약이 확인되었습니다.'), findsOneWidget);

      // Switch to English
      await _switchLanguage(tester, 'en');

      // Simulate notification in English
      await _simulateLocalizedNotification(tester, {
        'type': 'booking_confirmed',
        'locale': 'en',
        'title': 'Booking Confirmed',
        'message': 'Your Seoul Adventure Package booking has been confirmed.',
        'booking_id': 'english_booking_123'
      });

      await tester.pumpAndSettle();
      expect(find.text('Booking Confirmed'), findsOneWidget);
      expect(find.textContaining('Seoul Adventure Package'), findsOneWidget);
    });
  });

  group('Real-time Performance Tests', () {
    testWidgets('Handle high-frequency notifications', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'performance@example.com', 'password123');

      final stopwatch = Stopwatch()..start();

      // Simulate 100 rapid notifications
      for (int i = 0; i < 100; i++) {
        await _simulateRapidNotification(tester, {
          'id': 'notification_$i',
          'type': 'price_update',
          'message': 'Price update $i'
        });
        
        if (i % 10 == 0) {
          await tester.pump(Duration(milliseconds: 10));
        }
      }

      stopwatch.stop();

      // Performance assertions
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Should handle 100 notifications in < 5 seconds
      
      // UI should still be responsive
      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();
      
      expect(find.text('100 notifications'), findsOneWidget);
    });

    testWidgets('Memory usage with persistent connections', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _performLogin(tester, 'memory@example.com', 'password123');

      // Test long-running connection
      for (int i = 0; i < 1000; i++) {
        await _simulateNotification(tester, {
          'id': 'mem_test_$i',
          'type': 'heartbeat',
          'timestamp': DateTime.now().toIso8601String()
        });
        
        if (i % 100 == 0) {
          await tester.pump(Duration(milliseconds: 100));
          // In a real test, you'd check memory usage here
        }
      }

      // Verify app is still responsive
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}

// Helper methods for real-time testing

Future<void> _performLogin(WidgetTester tester, String email, String password) async {
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(Key('email_field')), email);
  await tester.enterText(find.byKey(Key('password_field')), password);
  
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle(Duration(seconds: 3));
}

Future<void> _performLoginWithLocale(WidgetTester tester, String email, String password, String locale) async {
  // Set locale first
  await _switchLanguage(tester, locale);
  await _performLogin(tester, email, password);
}

Future<void> _createTestBooking(WidgetTester tester) async {
  await tester.tap(find.text('Search'));
  await tester.enterText(find.byKey(Key('destination_search')), 'Seoul');
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();

  await tester.tap(find.text('Seoul Adventure Package'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Book Now'));
  await tester.pumpAndSettle();

  // Quick booking flow
  await tester.tap(find.text('Continue with Saved Info'));
  await tester.pumpAndSettle();
}

Future<void> _createBookingWithFlight(WidgetTester tester) async {
  await tester.tap(find.text('Flight + Hotel'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(Key('destination')), 'Seoul');
  await tester.tap(find.text('Search'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Seoul Flight Package'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Book Package'));
  await tester.pumpAndSettle();
}

Future<void> _createHotelBooking(WidgetTester tester) async {
  await tester.tap(find.text('Hotels'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(Key('hotel_search')), 'Seoul Grand Hotel');
  await tester.tap(find.text('Search'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Seoul Grand Hotel'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Book Room'));
  await tester.pumpAndSettle();
}

Future<void> _createBookingForDestination(WidgetTester tester, String destination) async {
  await tester.tap(find.text('Search'));
  await tester.enterText(find.byKey(Key('destination_search')), destination);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();

  await tester.tap(find.text(destination).first);
  await tester.pumpAndSettle();

  await tester.tap(find.text('Book Now'));
  await tester.pumpAndSettle();
}

Future<void> _setupPriceAlert(WidgetTester tester, String packageName, double maxPrice) async {
  await tester.tap(find.text('Price Alerts'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Add Alert'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(Key('package_name')), packageName);
  await tester.enterText(find.byKey(Key('max_price')), maxPrice.toString());

  await tester.tap(find.text('Set Alert'));
  await tester.pumpAndSettle();
}

Future<void> _switchLanguage(WidgetTester tester, String locale) async {
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Language'));
  await tester.pumpAndSettle();

  String languageText = locale == 'ko' ? '한국어' : locale == 'ja' ? '日本語' : 'English';
  await tester.tap(find.text(languageText));
  await tester.pumpAndSettle();
}

// Socket.io simulation methods
Future<void> _simulateStatusUpdate(WidgetTester tester, String event, Map<String, dynamic> data) async {
  // In a real implementation, this would trigger a socket event
  // For testing, we simulate the event
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'socket_events',
    null,
    (data) {},
  );
  await tester.pump(Duration(milliseconds: 500));
}

Future<void> _simulatePaymentNotification(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate payment socket event
  await tester.pump(Duration(milliseconds: 300));
}

Future<void> _simulateGroupNotification(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate group socket event
  await tester.pump(Duration(milliseconds: 400));
}

Future<void> _simulateFlightStatusUpdate(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate flight status socket event
  await tester.pump(Duration(milliseconds: 600));
}

Future<void> _simulateHotelUpdate(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate hotel booking socket event
  await tester.pump(Duration(milliseconds: 500));
}

Future<void> _simulateChatMessage(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate chat message socket event
  await tester.pump(Duration(milliseconds: 200));
}

Future<void> _simulateTypingIndicator(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate typing indicator socket event
  await tester.pump(Duration(milliseconds: 100));
}

Future<void> _simulateWeatherAlert(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate weather alert socket event
  await tester.pump(Duration(milliseconds: 800));
}

Future<void> _simulatePriceDropAlert(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate price drop socket event
  await tester.pump(Duration(milliseconds: 400));
}

Future<void> _simulateMaintenanceAlert(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate maintenance alert socket event
  await tester.pump(Duration(milliseconds: 500));
}

Future<void> _simulateConnectionLoss(WidgetTester tester) async {
  // Simulate socket disconnect
  await tester.pump(Duration(milliseconds: 100));
}

Future<void> _simulateConnectionRecovery(WidgetTester tester) async {
  // Simulate socket reconnect
  await tester.pump(Duration(seconds: 2));
}

Future<void> _simulateMissedNotifications(WidgetTester tester, List<Map<String, dynamic>> notifications) async {
  // Simulate receiving queued notifications after reconnection
  for (final notification in notifications) {
    await tester.pump(Duration(milliseconds: 100));
  }
}

Future<void> _simulateLocalizedNotification(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate localized notification socket event
  await tester.pump(Duration(milliseconds: 300));
}

Future<void> _simulateRapidNotification(WidgetTester tester, Map<String, dynamic> data) async {
  // Simulate rapid notification for performance testing
  await tester.pump(Duration(milliseconds: 10));
}

Future<void> _simulateNotification(WidgetTester tester, Map<String, dynamic> data) async {
  // Generic notification simulation
  await tester.pump(Duration(milliseconds: 50));
}