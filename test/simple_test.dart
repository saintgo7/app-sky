import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Simple Test Suite', () {
    test('Basic arithmetic operations', () {
      expect(2 + 2, equals(4));
      expect(10 - 5, equals(5));
      expect(3 * 4, equals(12));
      expect(8 / 2, equals(4));
    });

    test('String operations', () {
      const String greeting = 'Hello, SkyAir!';
      expect(greeting.length, equals(14));
      expect(greeting.toLowerCase(), equals('hello, skyair!'));
      expect(greeting.contains('Sky'), isTrue);
    });

    test('List operations', () {
      final List<String> destinations = ['Seoul', 'Tokyo', 'Bangkok', 'Singapore'];
      expect(destinations.length, equals(4));
      expect(destinations.first, equals('Seoul'));
      expect(destinations.last, equals('Singapore'));
      expect(destinations.contains('Tokyo'), isTrue);
    });

    test('Map operations', () {
      final Map<String, double> prices = {
        'Seoul': 1500000.0,
        'Tokyo': 2000000.0,
        'Bangkok': 800000.0,
      };
      expect(prices.length, equals(3));
      expect(prices['Seoul'], equals(1500000.0));
      expect(prices.containsKey('Tokyo'), isTrue);
    });

    test('DateTime operations', () {
      final DateTime now = DateTime.now();
      final DateTime future = now.add(Duration(days: 7));
      
      expect(future.isAfter(now), isTrue);
      expect(future.difference(now).inDays, equals(7));
    });
  });

  group('Travel Domain Logic Tests', () {
    test('Calculate trip duration', () {
      final DateTime startDate = DateTime(2024, 6, 1);
      final DateTime endDate = DateTime(2024, 6, 8);
      final int duration = endDate.difference(startDate).inDays;
      
      expect(duration, equals(7));
    });

    test('Calculate total price with tax', () {
      const double basePrice = 1000000.0;
      const double taxRate = 0.1;
      final double totalPrice = basePrice * (1 + taxRate);
      
      expect(totalPrice, equals(1100000.0));
    });

    test('Validate email format', () {
      bool isValidEmail(String email) {
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
      }
      
      expect(isValidEmail('user@example.com'), isTrue);
      expect(isValidEmail('invalid.email'), isFalse);
      expect(isValidEmail('user@travel.co.kr'), isTrue);
    });

    test('Format currency', () {
      String formatCurrency(double amount) {
        return '₩${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
          (Match m) => '${m[1]},'
        )}';
      }
      
      expect(formatCurrency(1000000), equals('₩1,000,000'));
      expect(formatCurrency(500000), equals('₩500,000'));
    });

    test('Calculate distance between coordinates', () {
      double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        // Simplified distance calculation for testing
        final double deltaLat = (lat2 - lat1).abs();
        final double deltaLon = (lon2 - lon1).abs();
        return deltaLat + deltaLon; // Simplified Manhattan distance
      }
      
      // Seoul to Busan approximate coordinates
      final double distance = calculateDistance(37.5665, 126.9780, 35.1796, 129.0756);
      expect(distance, greaterThan(0));
    });
  });
}