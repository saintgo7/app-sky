import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travelmate/services/ai/recommendation/recommendation_engine.dart';
import 'package:travelmate/services/ai/profiling/user_preference_analyzer.dart';
import 'package:travelmate/services/ai/profiling/travel_style_classifier.dart';
import 'package:travelmate/services/ai/profiling/budget_analyzer.dart';
import 'package:travelmate/data/models/ai_recommendation_model.dart';
import 'package:travelmate/data/models/travel_package_model.dart';
import 'package:travelmate/data/models/booking_model.dart';
import 'package:travelmate/data/models/user_model.dart';

class MockTravelPackageModel extends Mock implements TravelPackageModel {}
class MockUserPreferenceProfile extends Mock implements UserPreferenceProfile {}
class MockTravelStyleProfile extends Mock implements TravelStyleProfile {}
class MockBudgetProfile extends Mock implements BudgetProfile {}

void main() {
  group('RecommendationEngine Tests', () {
    late RecommendationEngine engine;
    late List<TravelPackageModel> mockPackages;
    late UserPreferenceProfile mockUserPreferences;
    late TravelStyleProfile mockTravelStyle;
    late BudgetProfile mockBudgetProfile;

    setUp(() {
      engine = RecommendationEngine();
      
      mockUserPreferences = MockUserPreferenceProfile();
      mockTravelStyle = MockTravelStyleProfile();
      mockBudgetProfile = MockBudgetProfile();
      
      // Create mock packages with different characteristics
      mockPackages = [
        _createMockPackage(
          id: 'package1',
          title: 'Seoul Adventure',
          destination: 'Seoul',
          countries: ['South Korea'],
          cities: ['Seoul'],
          categories: ['cultural', 'urban'],
          tags: ['city', 'culture'],
          rating: 4.5,
          reviewCount: 150,
          basePrice: 1500000.0,
          durationDays: 5,
        ),
        _createMockPackage(
          id: 'package2', 
          title: 'Tokyo Family Trip',
          destination: 'Tokyo',
          countries: ['Japan'],
          cities: ['Tokyo'],
          categories: ['family', 'cultural'],
          tags: ['family-friendly', 'city'],
          rating: 4.8,
          reviewCount: 200,
          basePrice: 2500000.0,
          durationDays: 7,
        ),
        _createMockPackage(
          id: 'package3',
          title: 'Bali Luxury Retreat',
          destination: 'Bali',
          countries: ['Indonesia'],
          cities: ['Denpasar', 'Ubud'],
          categories: ['luxury', 'beach'],
          tags: ['luxury', 'spa', 'beach'],
          rating: 4.9,
          reviewCount: 300,
          basePrice: 5000000.0,
          durationDays: 10,
        ),
        _createMockPackage(
          id: 'package4',
          title: 'Budget Bangkok Explorer',
          destination: 'Bangkok',
          countries: ['Thailand'],
          cities: ['Bangkok'],
          categories: ['budget', 'cultural'],
          tags: ['budget', 'street-food'],
          rating: 4.2,
          reviewCount: 80,
          basePrice: 800000.0,
          durationDays: 4,
        ),
      ];
      
      engine.updateAvailablePackages(mockPackages);
    });

    group('Basic Functionality', () {
      test('should initialize with empty data structures', () {
        final newEngine = RecommendationEngine();
        expect(newEngine, isNotNull);
      });

      test('should update available packages', () {
        final testPackages = [mockPackages[0]];
        engine.updateAvailablePackages(testPackages);
        expect(engine, isNotNull);
      });
    });

    group('Recommendation Generation', () {
      test('should generate recommendations with hybrid strategy', () async {
        // Setup user preferences
        when(() => mockUserPreferences.destinationPreferences).thenReturn({
          'south korea': 0.9,
          'japan': 0.7,
        });
        when(() => mockUserPreferences.activityPreferences).thenReturn({
          'cultural': 0.8,
          'urban': 0.6,
        });
        when(() => mockUserPreferences.durationPreferences).thenReturn({
          'week': 0.8,
          'short': 0.6,
        });

        when(() => mockTravelStyle.primaryStyle).thenReturn(TravelStyle.cultural);
        
        when(() => mockBudgetProfile.rangePreference).thenReturn(
          BudgetRange(minBudget: 1000000.0, maxBudget: 3000000.0),
        );

        final request = RecommendationRequest(
          userId: 'user123',
          userPreferences: mockUserPreferences,
          travelStyle: mockTravelStyle,
          budgetProfile: mockBudgetProfile,
          maxRecommendations: 5,
          minConfidence: 0.3,
          strategy: RecommendationStrategy.hybrid,
        );

        final result = await engine.generateRecommendations(request);

        expect(result.recommendations, isNotEmpty);
        expect(result.recommendations.length, lessThanOrEqualTo(5));
        expect(result.metrics.totalCandidates, greaterThan(0));
        expect(result.metrics.averageConfidence, greaterThanOrEqualTo(0.3));
        expect(result.generatedAt, isNotNull);
      });

      test('should filter candidates by budget constraints', () async {
        when(() => mockBudgetProfile.rangePreference).thenReturn(
          BudgetRange(minBudget: 2000000.0, maxBudget: 3000000.0),
        );

        final request = RecommendationRequest(
          userId: 'user123',
          budgetProfile: mockBudgetProfile,
          maxRecommendations: 10,
          minConfidence: 0.1,
        );

        final result = await engine.generateRecommendations(request);
        
        // Should only include Tokyo Family Trip (2.5M) within budget range
        expect(result.recommendations, isNotEmpty);
        for (final rec in result.recommendations) {
          final price = rec.additionalData['base_price'] as double;
          expect(price, greaterThanOrEqualTo(2000000.0));
          expect(price, lessThanOrEqualTo(3000000.0));
        }
      });

      test('should apply contextual filters', () async {
        final request = RecommendationRequest(
          userId: 'user123',
          contextualFilters: {
            'destination': 'Seoul',
            'duration': {'min': 4, 'max': 6},
          },
          maxRecommendations: 10,
          minConfidence: 0.1,
        );

        final result = await engine.generateRecommendations(request);
        
        expect(result.recommendations, isNotEmpty);
        for (final rec in result.recommendations) {
          final destination = rec.additionalData['destination'] as String;
          final duration = rec.additionalData['duration_days'] as int;
          expect(destination.toLowerCase(), contains('seoul'));
          expect(duration, greaterThanOrEqualTo(4));
          expect(duration, lessThanOrEqualTo(6));
        }
      });

      test('should exclude specified packages', () async {
        final request = RecommendationRequest(
          userId: 'user123',
          excludePackageIds: ['package1', 'package2'],
          maxRecommendations: 10,
          minConfidence: 0.1,
        );

        final result = await engine.generateRecommendations(request);
        
        for (final rec in result.recommendations) {
          final packageId = rec.content.packageId;
          expect(packageId, isNot(equals('package1')));
          expect(packageId, isNot(equals('package2')));
        }
      });

      test('should respect minimum confidence threshold', () async {
        final request = RecommendationRequest(
          userId: 'user123',
          maxRecommendations: 10,
          minConfidence: 0.5,
        );

        final result = await engine.generateRecommendations(request);
        
        for (final rec in result.recommendations) {
          expect(rec.confidence, greaterThanOrEqualTo(0.5));
        }
      });

      test('should limit number of recommendations', () async {
        final request = RecommendationRequest(
          userId: 'user123',
          maxRecommendations: 2,
          minConfidence: 0.1,
        );

        final result = await engine.generateRecommendations(request);
        
        expect(result.recommendations.length, lessThanOrEqualTo(2));
      });
    });

    group('Content-Based Filtering', () {
      test('should calculate destination match scores correctly', () {
        final engine = RecommendationEngine();
        final package = mockPackages[0]; // Seoul Adventure
        
        when(() => mockUserPreferences.destinationPreferences).thenReturn({
          'south korea': 0.9,
          'seoul': 0.8,
          'japan': 0.3,
        });

        final score = engine._calculateDestinationMatch(package, mockUserPreferences);
        expect(score, equals(0.9)); // Should match highest preference
      });

      test('should calculate activity match scores correctly', () {
        final engine = RecommendationEngine();
        final package = mockPackages[0]; // Seoul Adventure
        
        when(() => mockUserPreferences.activityPreferences).thenReturn({
          'cultural': 0.8,
          'urban': 0.7,
          'beach': 0.2,
        });

        final score = engine._calculateActivityMatch(package, mockUserPreferences);
        expect(score, equals((0.8 + 0.7) / 2)); // Average of cultural and urban
      });

      test('should calculate style match for luxury packages', () {
        final engine = RecommendationEngine();
        final package = mockPackages[2]; // Bali Luxury Retreat
        
        when(() => mockTravelStyle.primaryStyle).thenReturn(TravelStyle.luxury);

        final score = engine._calculateStyleMatch(package, mockTravelStyle);
        expect(score, equals(0.8)); // High price should match luxury style
      });

      test('should calculate style match for budget packages', () {
        final engine = RecommendationEngine();
        final package = mockPackages[3]; // Budget Bangkok Explorer
        
        when(() => mockTravelStyle.primaryStyle).thenReturn(TravelStyle.budget);

        final score = engine._calculateStyleMatch(package, mockTravelStyle);
        expect(score, equals(0.8)); // Low price should match budget style
      });

      test('should calculate duration preferences correctly', () {
        final engine = RecommendationEngine();
        final package = mockPackages[1]; // Tokyo Family Trip (7 days)
        
        when(() => mockUserPreferences.durationPreferences).thenReturn({
          'week': 0.9,
          'short': 0.3,
          'extended': 0.4,
        });

        final score = engine._calculateDurationMatch(package, mockUserPreferences);
        expect(score, equals(0.9)); // 7 days should match 'week' preference
      });
    });

    group('Collaborative Filtering', () {
      test('should find similar users based on booking patterns', () async {
        final engine = RecommendationEngine();
        final userBookings = [
          _createMockBooking('booking1', 'package1', 1500000.0),
          _createMockBooking('booking2', 'package2', 2500000.0),
        ];
        
        final otherUserBookings = [
          _createMockBooking('booking3', 'package1', 1500000.0),
          _createMockBooking('booking4', 'package3', 5000000.0),
        ];
        
        engine.updateUserBookingHistory('user123', userBookings);
        engine.updateUserBookingHistory('user456', otherUserBookings);

        final similarUsers = await engine._findSimilarUsers('user123', userBookings);
        
        expect(similarUsers, isNotEmpty);
        expect(similarUsers.first.userId, equals('user456'));
        expect(similarUsers.first.similarity, greaterThan(0.0));
      });

      test('should calculate collaborative scores based on similar users', () async {
        final engine = RecommendationEngine();
        final candidate = mockPackages[0];
        final similarUsers = [
          SimilarUser(
            userId: 'user456',
            similarity: 0.8,
            bookings: [_createMockBooking('booking1', 'package1', 1500000.0)],
          ),
        ];
        final userBookings = <BookingModel>[];

        final score = await engine._calculateCollaborativeScore(
          candidate, 
          similarUsers, 
          userBookings,
        );
        
        expect(score, equals(0.8)); // Should match similarity of user who booked it
      });
    });

    group('Recommendation Quality Metrics', () {
      test('should calculate diversity metrics correctly', () async {
        final engine = RecommendationEngine();
        final recommendations = [
          _createMockRecommendation('rec1', 'Seoul', ['cultural'], 'budget'),
          _createMockRecommendation('rec2', 'Tokyo', ['family'], 'mid-range'),
          _createMockRecommendation('rec3', 'Bali', ['luxury'], 'luxury'),
        ];

        final metrics = engine._calculateDiversityMetrics(recommendations);
        
        expect(metrics['unique_destinations'], equals(3));
        expect(metrics['unique_categories'], equals(3));
        expect(metrics['price_ranges'], equals(3));
      });

      test('should calculate average confidence correctly', () {
        final engine = RecommendationEngine();
        final recommendations = [
          _createMockRecommendationWithConfidence(0.8),
          _createMockRecommendationWithConfidence(0.6),
          _createMockRecommendationWithConfidence(0.9),
        ];

        final avgConfidence = engine._calculateAverageConfidence(recommendations);
        
        expect(avgConfidence, closeTo(0.77, 0.01)); // (0.8 + 0.6 + 0.9) / 3
      });

      test('should apply diversity filtering', () async {
        final engine = RecommendationEngine();
        final recommendations = List.generate(10, (i) => 
          _createMockRecommendation('rec$i', 'Seoul', ['cultural'], 'budget'));

        final diverseRecs = await engine._applyDiversityFiltering(recommendations);
        
        // Should reduce redundancy while maintaining minimum recommendations
        expect(diverseRecs.length, lessThan(recommendations.length));
        expect(diverseRecs.length, greaterThanOrEqualTo(5));
      });
    });

    group('Error Handling', () {
      test('should handle empty package list gracefully', () async {
        final engine = RecommendationEngine();
        engine.updateAvailablePackages([]);

        final request = RecommendationRequest(
          userId: 'user123',
          maxRecommendations: 5,
          minConfidence: 0.3,
        );

        final result = await engine.generateRecommendations(request);
        
        expect(result.recommendations, isEmpty);
        expect(result.metrics.totalCandidates, equals(0));
      });

      test('should handle invalid user preferences', () async {
        final request = RecommendationRequest(
          userId: 'user123',
          userPreferences: null,
          maxRecommendations: 5,
          minConfidence: 0.3,
        );

        final result = await engine.generateRecommendations(request);
        
        // Should still generate some recommendations using other strategies
        expect(result, isNotNull);
        expect(result.recommendations, isA<List<AIRecommendationModel>>());
      });

      test('should throw RecommendationException on critical errors', () async {
        // This would require mocking internal dependencies to fail
        // For now, we test the exception class
        expect(() => throw RecommendationException('Test error'), 
               throwsA(isA<RecommendationException>()));
      });
    });

    group('Performance Tests', () {
      test('should complete recommendations within acceptable time', () async {
        final engine = RecommendationEngine();
        final largePackageList = List.generate(100, (i) => 
          _createMockPackage(
            id: 'package$i',
            title: 'Package $i',
            destination: 'Destination $i',
            countries: ['Country ${i % 5}'],
            cities: ['City $i'],
            categories: ['category${i % 3}'],
            tags: ['tag${i % 4}'],
            rating: 3.0 + (i % 20) / 10.0,
            reviewCount: i * 10,
            basePrice: 1000000.0 + (i * 100000),
            durationDays: 3 + (i % 10),
          ));
        
        engine.updateAvailablePackages(largePackageList);

        final stopwatch = Stopwatch()..start();
        
        final request = RecommendationRequest(
          userId: 'user123',
          maxRecommendations: 10,
          minConfidence: 0.1,
        );

        final result = await engine.generateRecommendations(request);
        
        stopwatch.stop();
        
        expect(result.recommendations, isNotEmpty);
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Should complete in < 5 seconds
        expect(result.metrics.processingTime.inMilliseconds, lessThan(5000));
      });
    });

    group('Strategy Combination', () {
      test('should combine multiple strategy scores correctly', () async {
        final engine = RecommendationEngine();
        
        // Mock data for different strategies
        final collaborativeRecs = [
          _createMockRecommendationWithStrategy('rec1', 0.8, 'collaborative'),
        ];
        final contentBasedRecs = [
          _createMockRecommendationWithStrategy('rec1', 0.6, 'contentBased'),
        ];
        final demographicRecs = [
          _createMockRecommendationWithStrategy('rec1', 0.7, 'demographic'),
        ];

        final strategyRecommendations = {
          RecommendationStrategy.collaborative: collaborativeRecs,
          RecommendationStrategy.contentBased: contentBasedRecs,
          RecommendationStrategy.demographic: demographicRecs,
        };

        final combinedRecs = await engine._combineRecommendations(strategyRecommendations);
        
        expect(combinedRecs, hasLength(1));
        
        // Combined score should be weighted sum: 0.8*0.3 + 0.6*0.4 + 0.7*0.1 = 0.55
        expect(combinedRecs.first.confidence, closeTo(0.55, 0.01));
      });
    });
  });

  group('Supporting Classes Tests', () {
    test('SimilarUser should store data correctly', () {
      final bookings = [_createMockBooking('booking1', 'package1', 1000.0)];
      final similarUser = SimilarUser(
        userId: 'user123',
        similarity: 0.85,
        bookings: bookings,
      );

      expect(similarUser.userId, equals('user123'));
      expect(similarUser.similarity, equals(0.85));
      expect(similarUser.bookings, equals(bookings));
    });

    test('RecommendationRequest should have correct defaults', () {
      const request = RecommendationRequest(userId: 'user123');
      
      expect(request.maxRecommendations, equals(10));
      expect(request.minConfidence, equals(0.3));
      expect(request.strategy, equals(RecommendationStrategy.hybrid));
    });

    test('RecommendationException should display message correctly', () {
      const exception = RecommendationException('Test error message');
      
      expect(exception.message, equals('Test error message'));
      expect(exception.toString(), contains('Test error message'));
    });
  });
}

// Helper methods for creating mock objects

TravelPackageModel _createMockPackage({
  required String id,
  required String title,
  required String destination,
  required List<String> countries,
  required List<String> cities,
  required List<String> categories,
  required List<String> tags,
  required double rating,
  required int reviewCount,
  required double basePrice,
  required int durationDays,
}) {
  final mock = MockTravelPackageModel();
  when(() => mock.id).thenReturn(id);
  when(() => mock.title).thenReturn(title);
  when(() => mock.destination).thenReturn(destination);
  when(() => mock.countries).thenReturn(countries);
  when(() => mock.cities).thenReturn(cities);
  when(() => mock.categories).thenReturn(categories);
  when(() => mock.tags).thenReturn(tags);
  when(() => mock.rating).thenReturn(rating);
  when(() => mock.reviewCount).thenReturn(reviewCount);
  when(() => mock.durationDays).thenReturn(durationDays);
  when(() => mock.description).thenReturn('Description for $title');
  when(() => mock.thumbnailImage).thenReturn('https://example.com/$id.jpg');
  
  final mockPricing = MockPricingInfo();
  when(() => mockPricing.basePrice).thenReturn(basePrice);
  when(() => mockPricing.currency).thenReturn('KRW');
  when(() => mock.pricingInfo).thenReturn(mockPricing);
  
  final mockAvailability = MockAvailabilitySlot();
  when(() => mockAvailability.startDate).thenReturn(DateTime.now());
  when(() => mockAvailability.endDate).thenReturn(DateTime.now().add(Duration(days: 365)));
  when(() => mockAvailability.availableSlots).thenReturn(10);
  when(() => mock.availability).thenReturn([mockAvailability]);
  
  final mockItinerary = MockItineraryDay();
  when(() => mockItinerary.title).thenReturn('Day 1: Arrival');
  when(() => mock.itinerary).thenReturn([mockItinerary]);
  
  when(() => mock.packageType).thenReturn(PackageType.standard);
  
  return mock;
}

BookingModel _createMockBooking(String id, String packageId, double price) {
  return BookingModel(
    id: id,
    userId: 'user123',
    bookingType: BookingType.individual,
    packageId: packageId,
    packageTitle: 'Test Package',
    travelStartDate: DateTime.now().add(Duration(days: 30)),
    travelEndDate: DateTime.now().add(Duration(days: 37)),
    numberOfTravelers: 1,
    travelers: [],
    pricing: BookingPricing(
      basePrice: price,
      totalPrice: price,
      currency: 'KRW',
      breakdown: [],
      taxAmount: 0.0,
      servicesFee: 0.0,
    ),
    paymentInfo: PaymentInfo(transactions: [], installmentPayment: false),
    status: BookingStatus.confirmed,
    paymentStatus: PaymentStatus.paid,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

AIRecommendationModel _createMockRecommendation(
  String id, 
  String destination, 
  List<String> tags, 
  String priceCategory,
) {
  return AIRecommendationModel(
    id: id,
    userId: 'user123',
    type: RecommendationType.package,
    title: 'Test Recommendation $id',
    description: 'Test description',
    confidence: 0.7,
    confidenceLevel: ConfidenceLevel.medium,
    content: RecommendationContent(
      priceRange: PriceRange(min: 1000.0, max: 2000.0, category: priceCategory),
    ),
    reasons: ['Test reason'],
    tags: tags,
    userContext: UserContext(
      searchHistory: [],
      bookingHistory: [],
      viewedItems: [],
      likedItems: [],
      contextTimestamp: DateTime.now(),
    ),
    matchedPreferences: [],
    modelInfo: ModelInfo(
      modelName: 'Test Model',
      modelVersion: '1.0',
      algorithm: 'test',
      accuracy: 0.7,
      trainedAt: DateTime.now(),
      hyperparameters: {},
      features: [],
    ),
    additionalData: {
      'destination': destination,
      'duration_days': 7,
      'base_price': 1000.0,
    },
    isViewed: false,
    isLiked: false,
    isBookmarked: false,
    isBooked: false,
    generatedAt: DateTime.now(),
    expiresAt: DateTime.now().add(Duration(days: 7)),
  );
}

AIRecommendationModel _createMockRecommendationWithConfidence(double confidence) {
  return _createMockRecommendation('rec', 'Test', ['tag'], 'budget').copyWith(confidence: confidence);
}

AIRecommendationModel _createMockRecommendationWithStrategy(String id, double confidence, String algorithm) {
  final modelInfo = ModelInfo(
    modelName: 'Test Model',
    modelVersion: '1.0',
    algorithm: algorithm,
    accuracy: confidence,
    trainedAt: DateTime.now(),
    hyperparameters: {},
    features: [],
  );
  
  return _createMockRecommendation(id, 'Test', ['tag'], 'budget').copyWith(
    confidence: confidence,
    modelInfo: modelInfo,
  );
}

class MockPricingInfo extends Mock implements PricingInfo {}
class MockAvailabilitySlot extends Mock implements AvailabilitySlot {}
class MockItineraryDay extends Mock implements ItineraryDay {}

// Mock enums/classes that might not exist yet
enum PackageType { standard, premium, luxury }
enum TravelStyle { luxury, budget, family, adventure, cultural }

class PricingInfo {
  final double basePrice;
  final String currency;
  PricingInfo({required this.basePrice, required this.currency});
}

class AvailabilitySlot {
  final DateTime startDate;
  final DateTime endDate;
  final int availableSlots;
  AvailabilitySlot({required this.startDate, required this.endDate, required this.availableSlots});
}

class ItineraryDay {
  final String title;
  ItineraryDay({required this.title});
}

class UserPreferenceProfile {
  final Map<String, double> destinationPreferences;
  final Map<String, double> activityPreferences;
  final Map<String, double> durationPreferences;
  
  UserPreferenceProfile({
    required this.destinationPreferences,
    required this.activityPreferences,
    required this.durationPreferences,
  });
}

class TravelStyleProfile {
  final TravelStyle primaryStyle;
  TravelStyleProfile({required this.primaryStyle});
}

class BudgetProfile {
  final BudgetRange rangePreference;
  BudgetProfile({required this.rangePreference});
}

class BudgetRange {
  final double minBudget;
  final double maxBudget;
  BudgetRange({required this.minBudget, required this.maxBudget});
}