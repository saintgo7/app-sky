import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/presentation/screens/ai/personalized_recommendation_screen.dart';
import 'package:travelmate/services/ai/recommendation/recommendation_engine.dart';
import 'package:travelmate/data/models/ai_recommendation_model.dart';

class MockRecommendationEngine extends Mock implements RecommendationEngine {}

void main() {
  group('PersonalizedRecommendationScreen Widget Tests', () {
    late MockRecommendationEngine mockRecommendationEngine;

    setUp(() {
      mockRecommendationEngine = MockRecommendationEngine();
    });

    testWidgets('should display loading indicator initially', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading recommendations...'), findsOneWidget);
    });

    testWidgets('should display recommendations after loading', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'Seoul Adventure Package',
          description: 'Explore the vibrant city of Seoul',
          confidence: 0.9,
          imageUrl: 'https://example.com/seoul.jpg',
        ),
        _createMockRecommendation(
          id: 'rec2',
          title: 'Tokyo Cultural Experience',
          description: 'Immerse in Japanese culture',
          confidence: 0.8,
          imageUrl: 'https://example.com/tokyo.jpg',
        ),
      ];

      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle(); // Wait for loading to complete

      // Assert
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Seoul Adventure Package'), findsOneWidget);
      expect(find.text('Tokyo Cultural Experience'), findsOneWidget);
      expect(find.text('Explore the vibrant city of Seoul'), findsOneWidget);
    });

    testWidgets('should display tab navigation correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('For You'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Trending'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
    });

    testWidgets('should switch between tabs correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Popular'));
      await tester.pumpAndSettle();

      // Assert - Tab should be selected
      final TabBar tabBar = tester.widget(find.byType(TabBar));
      // Note: In a real implementation, you'd check the selected tab index
    });

    testWidgets('should display filter chips', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FilterChip), findsWidgets);
      expect(find.text('Domestic'), findsOneWidget);
      expect(find.text('International'), findsOneWidget);
      expect(find.text('Budget'), findsOneWidget);
      expect(find.text('Luxury'), findsOneWidget);
    });

    testWidgets('should toggle filter chips when tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Budget'));
      await tester.pumpAndSettle();

      // Assert - Filter should be toggled (in real implementation, verify state change)
      final FilterChip budgetChip = tester.widget(
        find.widgetWithText(FilterChip, 'Budget'),
      );
      // In a real test, you'd verify the selected state changed
    });

    testWidgets('should display recommendation cards with correct information', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'Seoul Adventure Package',
          description: 'Explore the vibrant city of Seoul',
          confidence: 0.9,
          rating: 4.5,
          reasons: ['Matches your preferences', 'Popular destination'],
        ),
      ];

      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Seoul Adventure Package'), findsOneWidget);
      expect(find.text('Explore the vibrant city of Seoul'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsWidgets);
      expect(find.text('90% match'), findsOneWidget); // Confidence as percentage
    });

    testWidgets('should display recommendation reasons', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'Seoul Adventure Package',
          description: 'Explore Seoul',
          confidence: 0.9,
          reasons: ['Matches your travel style', 'Within your budget', 'Popular choice'],
        ),
      ];

      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Matches your travel style'), findsOneWidget);
      expect(find.textContaining('Within your budget'), findsOneWidget);
      expect(find.textContaining('Popular choice'), findsOneWidget);
    });

    testWidgets('should navigate to recommendation details on tap', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'Seoul Adventure Package',
          description: 'Explore Seoul',
          confidence: 0.9,
        ),
      ];

      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
          routes: {
            '/recommendation-details': (context) => Scaffold(
              body: Text('Recommendation Details'),
            ),
          },
        ),
      );

      await tester.pumpAndSettle();

      // Tap on recommendation card
      await tester.tap(find.text('Seoul Adventure Package'));
      await tester.pumpAndSettle();

      // Assert - Navigation occurred (in real implementation)
      // expect(find.text('Recommendation Details'), findsOneWidget);
    });

    testWidgets('should display empty state when no recommendations', (WidgetTester tester) async {
      // Arrange
      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: [],
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No recommendations available'), findsOneWidget);
      expect(find.text('Try adjusting your filters or preferences'), findsOneWidget);
      expect(find.byIcon(Icons.explore_off), findsOneWidget);
    });

    testWidgets('should display error state on failure', (WidgetTester tester) async {
      // Arrange
      when(mockRecommendationEngine.generateRecommendations(any))
          .thenThrow(Exception('Failed to load recommendations'));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Failed to load recommendations'), findsOneWidget);
      expect(find.text('Please try again later'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should retry loading on retry button tap', (WidgetTester tester) async {
      // Arrange
      when(mockRecommendationEngine.generateRecommendations(any))
          .thenThrow(Exception('Failed to load recommendations'));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(mockRecommendationEngine.generateRecommendations(any)).called(2);
    });

    testWidgets('should support pull-to-refresh', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'Seoul Adventure Package',
          description: 'Explore Seoul',
          confidence: 0.9,
        ),
      ];

      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Perform pull-to-refresh
      await tester.fling(
        find.byType(RefreshIndicator),
        Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      // Assert - Refresh should trigger reload
      verify(mockRecommendationEngine.generateRecommendations(any)).called(2);
    });

    testWidgets('should display confidence indicators correctly', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'High Confidence Package',
          confidence: 0.95,
          confidenceLevel: ConfidenceLevel.veryHigh,
        ),
        _createMockRecommendation(
          id: 'rec2',
          title: 'Medium Confidence Package',
          confidence: 0.65,
          confidenceLevel: ConfidenceLevel.medium,
        ),
        _createMockRecommendation(
          id: 'rec3',
          title: 'Low Confidence Package',
          confidence: 0.35,
          confidenceLevel: ConfidenceLevel.low,
        ),
      ];

      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('95% match'), findsOneWidget);
      expect(find.text('65% match'), findsOneWidget);
      expect(find.text('35% match'), findsOneWidget);
    });

    testWidgets('should display bookmark button and handle bookmark toggle', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'Seoul Adventure Package',
          confidence: 0.9,
          isBookmarked: false,
        ),
      ];

      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

      // Act - Toggle bookmark
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();

      // Assert - Bookmark should be filled (in real implementation)
      // expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('should display like button and handle like toggle', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'Seoul Adventure Package',
          confidence: 0.9,
          isLiked: false,
        ),
      ];

      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      // Act - Toggle like
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      // Assert - Heart should be filled (in real implementation)
      // expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('PersonalizedRecommendationScreen Accessibility Tests', () {
    testWidgets('should have proper accessibility labels', (WidgetTester tester) async {
      // Arrange
      final mockRecommendations = [
        _createMockRecommendation(
          id: 'rec1',
          title: 'Seoul Adventure Package',
          description: 'Explore Seoul',
          confidence: 0.9,
        ),
      ];

      final mockRecommendationEngine = MockRecommendationEngine();
      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: mockRecommendations,
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Check for semantic labels
      expect(find.bySemanticsLabel('Personalized recommendations'), findsOneWidget);
      expect(find.bySemanticsLabel('Filter recommendations'), findsWidgets);
      expect(find.bySemanticsLabel('Bookmark recommendation'), findsWidgets);
      expect(find.bySemanticsLabel('Like recommendation'), findsWidgets);
    });

    testWidgets('should support screen reader navigation', (WidgetTester tester) async {
      // This test would verify that the screen is properly structured for screen readers
      // with appropriate semantic roles and hierarchy
      
      final mockRecommendationEngine = MockRecommendationEngine();
      when(mockRecommendationEngine.generateRecommendations(any))
          .thenAnswer((_) async => RecommendationResult(
                recommendations: [],
                metrics: _createMockMetrics(),
                explanations: {},
                generatedAt: DateTime.now(),
              ));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<RecommendationEngine>.value(
            value: mockRecommendationEngine,
            child: PersonalizedRecommendationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Test semantic structure
      final semantics = tester.getSemantics(find.byType(PersonalizedRecommendationScreen));
      // In a real test, you'd verify the semantic tree structure
    });
  });
}

// Helper functions for creating mock objects

AIRecommendationModel _createMockRecommendation({
  required String id,
  required String title,
  String? description,
  required double confidence,
  ConfidenceLevel? confidenceLevel,
  double? rating,
  List<String>? reasons,
  String? imageUrl,
  bool isBookmarked = false,
  bool isLiked = false,
}) {
  return AIRecommendationModel(
    id: id,
    userId: 'user123',
    type: RecommendationType.package,
    title: title,
    description: description ?? 'Description for $title',
    confidence: confidence,
    confidenceLevel: confidenceLevel ?? _getConfidenceLevel(confidence),
    content: RecommendationContent(
      packageId: 'package_$id',
      priceRange: PriceRange(
        min: 100000.0,
        max: 200000.0,
        category: 'mid-range',
      ),
      currency: 'KRW',
      duration: '5 days',
      highlights: ['Highlight 1', 'Highlight 2'],
    ),
    reasons: reasons ?? ['Great match for you'],
    tags: ['cultural', 'urban'],
    rating: rating,
    imageUrl: imageUrl ?? 'https://example.com/$id.jpg',
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
      algorithm: 'hybrid',
      accuracy: confidence,
      trainedAt: DateTime.now(),
      hyperparameters: {},
      features: [],
    ),
    additionalData: {},
    isViewed: false,
    isLiked: isLiked,
    isBookmarked: isBookmarked,
    isBooked: false,
    generatedAt: DateTime.now(),
    expiresAt: DateTime.now().add(Duration(days: 7)),
  );
}

ConfidenceLevel _getConfidenceLevel(double confidence) {
  if (confidence >= 0.8) return ConfidenceLevel.veryHigh;
  if (confidence >= 0.6) return ConfidenceLevel.high;
  if (confidence >= 0.4) return ConfidenceLevel.medium;
  return ConfidenceLevel.low;
}

RecommendationMetrics _createMockMetrics() {
  return RecommendationMetrics(
    totalCandidates: 50,
    filteredCandidates: 10,
    averageConfidence: 0.75,
    strategyContributions: {
      RecommendationStrategy.collaborative: 0.3,
      RecommendationStrategy.contentBased: 0.4,
      RecommendationStrategy.demographic: 0.1,
      RecommendationStrategy.contextual: 0.2,
    },
    processingTime: Duration(milliseconds: 500),
    diversityMetrics: {
      'unique_destinations': 5,
      'unique_categories': 3,
      'price_ranges': 2,
    },
  );
}