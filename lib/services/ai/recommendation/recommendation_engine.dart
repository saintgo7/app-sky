import 'dart:math';

import '../../../data/models/travel_package_model.dart';
import '../../../data/models/ai_recommendation_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/booking_model.dart';
import '../profiling/user_preference_analyzer.dart';
import '../profiling/travel_style_classifier.dart';
import '../profiling/budget_analyzer.dart';

enum RecommendationStrategy { 
  collaborative, 
  contentBased, 
  hybrid, 
  demographic,
  contextual 
}

class RecommendationRequest {
  final String userId;
  final UserPreferenceProfile? userPreferences;
  final TravelStyleProfile? travelStyle;
  final BudgetProfile? budgetProfile;
  final Map<String, dynamic>? contextualFilters;
  final List<String>? excludePackageIds;
  final int maxRecommendations;
  final double minConfidence;
  final RecommendationStrategy strategy;

  const RecommendationRequest({
    required this.userId,
    this.userPreferences,
    this.travelStyle,
    this.budgetProfile,
    this.contextualFilters,
    this.excludePackageIds,
    this.maxRecommendations = 10,
    this.minConfidence = 0.3,
    this.strategy = RecommendationStrategy.hybrid,
  });
}

class RecommendationResult {
  final List<AIRecommendationModel> recommendations;
  final RecommendationMetrics metrics;
  final Map<String, dynamic> explanations;
  final DateTime generatedAt;

  const RecommendationResult({
    required this.recommendations,
    required this.metrics,
    required this.explanations,
    required this.generatedAt,
  });
}

class RecommendationMetrics {
  final int totalCandidates;
  final int filteredCandidates;
  final double averageConfidence;
  final Map<RecommendationStrategy, double> strategyContributions;
  final Duration processingTime;
  final Map<String, int> diversityMetrics;

  const RecommendationMetrics({
    required this.totalCandidates,
    required this.filteredCandidates,
    required this.averageConfidence,
    required this.strategyContributions,
    required this.processingTime,
    required this.diversityMetrics,
  });
}

class SimilarityScore {
  final String itemId;
  final double score;
  final Map<String, double> featureScores;

  const SimilarityScore({
    required this.itemId,
    required this.score,
    required this.featureScores,
  });
}

class RecommendationEngine {
  final Map<String, List<BookingModel>> _userBookingHistory = {};
  final Map<String, UserPreferenceProfile> _userPreferences = {};
  final Map<String, TravelStyleProfile> _userTravelStyles = {};
  final List<TravelPackageModel> _availablePackages = [];

  // Weights for different recommendation strategies
  static const Map<RecommendationStrategy, double> _strategyWeights = {
    RecommendationStrategy.collaborative: 0.3,
    RecommendationStrategy.contentBased: 0.4,
    RecommendationStrategy.demographic: 0.1,
    RecommendationStrategy.contextual: 0.2,
  };

  /// Main recommendation method
  Future<RecommendationResult> generateRecommendations(
    RecommendationRequest request,
  ) async {
    final startTime = DateTime.now();

    try {
      // Filter candidates based on basic criteria
      final candidates = await _filterCandidates(request);

      // Generate recommendations using different strategies
      final collaborativeRecs = await _generateCollaborativeRecommendations(request, candidates);
      final contentBasedRecs = await _generateContentBasedRecommendations(request, candidates);
      final demographicRecs = await _generateDemographicRecommendations(request, candidates);
      final contextualRecs = await _generateContextualRecommendations(request, candidates);

      // Combine and rank recommendations
      final combinedRecs = await _combineRecommendations({
        RecommendationStrategy.collaborative: collaborativeRecs,
        RecommendationStrategy.contentBased: contentBasedRecs,
        RecommendationStrategy.demographic: demographicRecs,
        RecommendationStrategy.contextual: contextualRecs,
      });

      // Apply diversity and quality filters
      final finalRecs = await _applyPostProcessing(combinedRecs, request);

      // Calculate metrics
      final processingTime = DateTime.now().difference(startTime);
      final metrics = RecommendationMetrics(
        totalCandidates: candidates.length,
        filteredCandidates: finalRecs.length,
        averageConfidence: _calculateAverageConfidence(finalRecs),
        strategyContributions: _calculateStrategyContributions(finalRecs),
        processingTime: processingTime,
        diversityMetrics: _calculateDiversityMetrics(finalRecs),
      );

      return RecommendationResult(
        recommendations: finalRecs.take(request.maxRecommendations).toList(),
        metrics: metrics,
        explanations: await _generateExplanations(finalRecs, request),
        generatedAt: DateTime.now(),
      );

    } catch (e) {
      throw RecommendationException('Failed to generate recommendations: $e');
    }
  }

  /// Collaborative filtering recommendations
  Future<List<AIRecommendationModel>> _generateCollaborativeRecommendations(
    RecommendationRequest request,
    List<TravelPackageModel> candidates,
  ) async {
    final userBookings = _userBookingHistory[request.userId] ?? [];
    if (userBookings.isEmpty) return [];

    final recommendations = <AIRecommendationModel>[];
    
    // Find similar users based on booking patterns
    final similarUsers = await _findSimilarUsers(request.userId, userBookings);
    
    for (final candidate in candidates) {
      // Calculate collaborative filtering score
      final score = await _calculateCollaborativeScore(
        candidate,
        similarUsers,
        userBookings,
      );

      if (score > request.minConfidence) {
        final recommendation = await _createRecommendation(
          candidate,
          score,
          RecommendationType.package,
          request.userId,
          reasons: ['Similar travelers also booked this'],
          strategy: RecommendationStrategy.collaborative,
        );
        recommendations.add(recommendation);
      }
    }

    return recommendations..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  /// Content-based filtering recommendations
  Future<List<AIRecommendationModel>> _generateContentBasedRecommendations(
    RecommendationRequest request,
    List<TravelPackageModel> candidates,
  ) async {
    final userPrefs = request.userPreferences;
    final travelStyle = request.travelStyle;
    
    if (userPrefs == null) return [];

    final recommendations = <AIRecommendationModel>[];

    for (final candidate in candidates) {
      // Calculate content-based similarity score
      final score = await _calculateContentBasedScore(
        candidate,
        userPrefs,
        travelStyle,
      );

      if (score > request.minConfidence) {
        final matchedPreferences = await _identifyMatchedPreferences(
          candidate,
          userPrefs,
        );

        final recommendation = await _createRecommendation(
          candidate,
          score,
          RecommendationType.package,
          request.userId,
          reasons: _generateContentBasedReasons(matchedPreferences),
          strategy: RecommendationStrategy.contentBased,
          matchedPreferences: matchedPreferences,
        );
        recommendations.add(recommendation);
      }
    }

    return recommendations..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  /// Demographic-based recommendations
  Future<List<AIRecommendationModel>> _generateDemographicRecommendations(
    RecommendationRequest request,
    List<TravelPackageModel> candidates,
  ) async {
    final travelStyle = request.travelStyle;
    if (travelStyle == null) return [];

    final recommendations = <AIRecommendationModel>[];

    // Find packages popular among users with similar demographics
    for (final candidate in candidates) {
      final popularityScore = await _calculateDemographicPopularity(
        candidate,
        travelStyle,
      );

      if (popularityScore > request.minConfidence) {
        final recommendation = await _createRecommendation(
          candidate,
          popularityScore,
          RecommendationType.package,
          request.userId,
          reasons: ['Popular among ${travelStyle.primaryStyle.name} travelers'],
          strategy: RecommendationStrategy.demographic,
        );
        recommendations.add(recommendation);
      }
    }

    return recommendations..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  /// Contextual recommendations based on external factors
  Future<List<AIRecommendationModel>> _generateContextualRecommendations(
    RecommendationRequest request,
    List<TravelPackageModel> candidates,
  ) async {
    final contextFilters = request.contextualFilters ?? {};
    final recommendations = <AIRecommendationModel>[];

    for (final candidate in candidates) {
      final contextScore = await _calculateContextualScore(
        candidate,
        contextFilters,
      );

      if (contextScore > request.minConfidence) {
        final contextReasons = await _generateContextualReasons(
          candidate,
          contextFilters,
        );

        final recommendation = await _createRecommendation(
          candidate,
          contextScore,
          RecommendationType.package,
          request.userId,
          reasons: contextReasons,
          strategy: RecommendationStrategy.contextual,
        );
        recommendations.add(recommendation);
      }
    }

    return recommendations..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  /// Combine recommendations from different strategies
  Future<List<AIRecommendationModel>> _combineRecommendations(
    Map<RecommendationStrategy, List<AIRecommendationModel>> strategyRecommendations,
  ) async {
    final combinedScores = <String, CombinedRecommendation>{};

    // Combine scores from different strategies
    strategyRecommendations.forEach((strategy, recommendations) {
      final weight = _strategyWeights[strategy] ?? 0.0;

      for (final rec in recommendations) {
        final packageId = rec.content.packageId ?? rec.id;
        
        if (!combinedScores.containsKey(packageId)) {
          combinedScores[packageId] = CombinedRecommendation(
            recommendation: rec,
            strategyScores: {},
            combinedScore: 0.0,
            reasons: Set<String>.from(rec.reasons),
          );
        }

        final combined = combinedScores[packageId]!;
        combined.strategyScores[strategy] = rec.confidence;
        combined.combinedScore += rec.confidence * weight;
        combined.reasons.addAll(rec.reasons);
      }
    });

    // Create final recommendations with combined scores
    final finalRecommendations = <AIRecommendationModel>[];
    
    for (final combined in combinedScores.values) {
      final updatedRec = combined.recommendation.copyWith(
        confidence: combined.combinedScore,
        reasons: combined.reasons.toList(),
        additionalData: {
          ...combined.recommendation.additionalData,
          'strategy_scores': combined.strategyScores.map(
            (k, v) => MapEntry(k.name, v),
          ),
        },
      );
      finalRecommendations.add(updatedRec);
    }

    return finalRecommendations..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  /// Apply diversity and quality post-processing
  Future<List<AIRecommendationModel>> _applyPostProcessing(
    List<AIRecommendationModel> recommendations,
    RecommendationRequest request,
  ) async {
    var processedRecs = List<AIRecommendationModel>.from(recommendations);

    // Apply confidence threshold
    processedRecs = processedRecs
        .where((rec) => rec.confidence >= request.minConfidence)
        .toList();

    // Apply diversity filtering
    processedRecs = await _applyDiversityFiltering(processedRecs);

    // Remove already booked packages
    final userBookings = _userBookingHistory[request.userId] ?? [];
    final bookedPackageIds = userBookings.map((b) => b.packageId).toSet();
    
    processedRecs = processedRecs
        .where((rec) => !bookedPackageIds.contains(rec.content.packageId))
        .toList();

    // Exclude specified packages
    if (request.excludePackageIds != null) {
      processedRecs = processedRecs
          .where((rec) => !request.excludePackageIds!.contains(rec.content.packageId))
          .toList();
    }

    return processedRecs;
  }

  // Helper methods

  Future<List<TravelPackageModel>> _filterCandidates(
    RecommendationRequest request,
  ) async {
    var candidates = List<TravelPackageModel>.from(_availablePackages);

    // Filter by budget if available
    if (request.budgetProfile != null) {
      final budgetRange = request.budgetProfile!.rangePreference;
      candidates = candidates.where((package) {
        return package.pricingInfo.basePrice >= budgetRange.minBudget &&
               package.pricingInfo.basePrice <= budgetRange.maxBudget;
      }).toList();
    }

    // Filter by contextual criteria
    if (request.contextualFilters != null) {
      final filters = request.contextualFilters!;

      if (filters.containsKey('destination')) {
        final destination = filters['destination'] as String?;
        if (destination != null) {
          candidates = candidates.where((package) {
            return package.destination.toLowerCase().contains(destination.toLowerCase()) ||
                   package.countries.any((country) => 
                       country.toLowerCase().contains(destination.toLowerCase()));
          }).toList();
        }
      }

      if (filters.containsKey('duration')) {
        final duration = filters['duration'] as Map<String, int>?;
        if (duration != null) {
          final minDays = duration['min'] ?? 0;
          final maxDays = duration['max'] ?? 365;
          
          candidates = candidates.where((package) {
            return package.durationDays >= minDays && package.durationDays <= maxDays;
          }).toList();
        }
      }

      if (filters.containsKey('travelDate')) {
        final travelDate = filters['travelDate'] as DateTime?;
        if (travelDate != null) {
          candidates = candidates.where((package) {
            return package.availability.any((slot) =>
                travelDate.isAfter(slot.startDate) &&
                travelDate.isBefore(slot.endDate) &&
                slot.availableSlots > 0);
          }).toList();
        }
      }
    }

    return candidates;
  }

  Future<List<SimilarUser>> _findSimilarUsers(
    String userId,
    List<BookingModel> userBookings,
  ) async {
    final similarUsers = <SimilarUser>[];
    
    // Extract user's booking patterns
    final userDestinations = userBookings.map((b) => b.packageTitle).toSet();
    final userSpendingRange = userBookings.isEmpty ? null : {
      'min': userBookings.map((b) => b.pricing.totalPrice).reduce(min),
      'max': userBookings.map((b) => b.pricing.totalPrice).reduce(max),
    };

    // Compare with other users
    for (final entry in _userBookingHistory.entries) {
      if (entry.key == userId) continue;

      final otherUserBookings = entry.value;
      final otherDestinations = otherUserBookings.map((b) => b.packageTitle).toSet();
      
      // Calculate similarity based on destinations
      final commonDestinations = userDestinations.intersection(otherDestinations);
      final destinationSimilarity = commonDestinations.length / 
          max(userDestinations.length, otherDestinations.length);

      // Calculate spending similarity
      double spendingSimilarity = 0.0;
      if (userSpendingRange != null && otherUserBookings.isNotEmpty) {
        final otherSpendingRange = {
          'min': otherUserBookings.map((b) => b.pricing.totalPrice).reduce(min),
          'max': otherUserBookings.map((b) => b.pricing.totalPrice).reduce(max),
        };
        
        spendingSimilarity = _calculateSpendingRangeSimilarity(
          userSpendingRange,
          otherSpendingRange,
        );
      }

      final overallSimilarity = (destinationSimilarity + spendingSimilarity) / 2;

      if (overallSimilarity > 0.1) { // Minimum similarity threshold
        similarUsers.add(SimilarUser(
          userId: entry.key,
          similarity: overallSimilarity,
          bookings: otherUserBookings,
        ));
      }
    }

    return similarUsers
      ..sort((a, b) => b.similarity.compareTo(a.similarity))
      ..take(10).toList();
  }

  Future<double> _calculateCollaborativeScore(
    TravelPackageModel candidate,
    List<SimilarUser> similarUsers,
    List<BookingModel> userBookings,
  ) async {
    if (similarUsers.isEmpty) return 0.0;

    double totalScore = 0.0;
    double totalWeight = 0.0;

    for (final similarUser in similarUsers) {
      // Check if similar user has booked this package
      final hasBooked = similarUser.bookings.any((booking) =>
          booking.packageId == candidate.id);

      if (hasBooked) {
        totalScore += similarUser.similarity;
        totalWeight += similarUser.similarity;
      }
    }

    return totalWeight > 0 ? totalScore / totalWeight : 0.0;
  }

  Future<double> _calculateContentBasedScore(
    TravelPackageModel candidate,
    UserPreferenceProfile userPrefs,
    TravelStyleProfile? travelStyle,
  ) async {
    double score = 0.0;
    int factors = 0;

    // Destination preference match
    final destinationScore = _calculateDestinationMatch(candidate, userPrefs);
    score += destinationScore;
    factors++;

    // Activity preference match
    final activityScore = _calculateActivityMatch(candidate, userPrefs);
    score += activityScore;
    factors++;

    // Travel style match
    if (travelStyle != null) {
      final styleScore = _calculateStyleMatch(candidate, travelStyle);
      score += styleScore;
      factors++;
    }

    // Duration preference match
    final durationScore = _calculateDurationMatch(candidate, userPrefs);
    score += durationScore;
    factors++;

    return factors > 0 ? score / factors : 0.0;
  }

  double _calculateDestinationMatch(
    TravelPackageModel candidate,
    UserPreferenceProfile userPrefs,
  ) {
    double maxScore = 0.0;

    // Check if package destination matches user preferences
    for (final country in candidate.countries) {
      final prefScore = userPrefs.destinationPreferences[country.toLowerCase()] ?? 0.0;
      maxScore = max(maxScore, prefScore);
    }

    for (final city in candidate.cities) {
      final prefScore = userPrefs.destinationPreferences[city.toLowerCase()] ?? 0.0;
      maxScore = max(maxScore, prefScore);
    }

    return maxScore;
  }

  double _calculateActivityMatch(
    TravelPackageModel candidate,
    UserPreferenceProfile userPrefs,
  ) {
    double totalScore = 0.0;
    int matchCount = 0;

    // Match package categories with user activity preferences
    for (final category in candidate.categories) {
      final prefScore = userPrefs.activityPreferences[category.toLowerCase()] ?? 0.0;
      if (prefScore > 0) {
        totalScore += prefScore;
        matchCount++;
      }
    }

    // Match package tags with user activity preferences
    for (final tag in candidate.tags) {
      final prefScore = userPrefs.activityPreferences[tag.toLowerCase()] ?? 0.0;
      if (prefScore > 0) {
        totalScore += prefScore;
        matchCount++;
      }
    }

    return matchCount > 0 ? totalScore / matchCount : 0.0;
  }

  double _calculateStyleMatch(
    TravelPackageModel candidate,
    TravelStyleProfile travelStyle,
  ) {
    // Simple style matching based on package characteristics
    final primaryStyle = travelStyle.primaryStyle;
    
    switch (primaryStyle) {
      case TravelStyle.luxury:
        return candidate.pricingInfo.basePrice > 3000000 ? 0.8 : 0.2;
      case TravelStyle.budget:
        return candidate.pricingInfo.basePrice < 1500000 ? 0.8 : 0.2;
      case TravelStyle.family:
        return candidate.categories.contains('family') || 
               candidate.tags.contains('family-friendly') ? 0.8 : 0.3;
      case TravelStyle.adventure:
        return candidate.categories.contains('adventure') ||
               candidate.tags.contains('outdoor') ? 0.8 : 0.3;
      default:
        return 0.5; // Neutral score for other styles
    }
  }

  double _calculateDurationMatch(
    TravelPackageModel candidate,
    UserPreferenceProfile userPrefs,
  ) {
    // Check duration preferences
    final duration = candidate.durationDays;
    
    if (duration <= 3 && userPrefs.durationPreferences['short'] != null) {
      return userPrefs.durationPreferences['short']!;
    } else if (duration <= 7 && userPrefs.durationPreferences['week'] != null) {
      return userPrefs.durationPreferences['week']!;
    } else if (duration <= 14 && userPrefs.durationPreferences['extended'] != null) {
      return userPrefs.durationPreferences['extended']!;
    } else if (userPrefs.durationPreferences['long'] != null) {
      return userPrefs.durationPreferences['long']!;
    }

    return 0.5; // Default neutral score
  }

  Future<double> _calculateDemographicPopularity(
    TravelPackageModel candidate,
    TravelStyleProfile travelStyle,
  ) async {
    // Calculate popularity among similar demographic groups
    // This would typically involve analyzing booking data from users with similar profiles
    
    // Simplified implementation
    double popularityScore = candidate.rating / 5.0; // Normalize rating to 0-1
    
    // Adjust based on review count (more reviews = more reliable)
    final reviewFactor = min(candidate.reviewCount / 100.0, 1.0);
    popularityScore = (popularityScore * 0.7) + (reviewFactor * 0.3);

    return popularityScore;
  }

  Future<double> _calculateContextualScore(
    TravelPackageModel candidate,
    Map<String, dynamic> contextFilters,
  ) async {
    double score = 0.5; // Base score
    int factors = 0;

    // Weather/seasonal context
    if (contextFilters.containsKey('season')) {
      final season = contextFilters['season'] as String?;
      if (season != null) {
        // This would integrate with weather/seasonal data
        score += 0.2; // Placeholder
        factors++;
      }
    }

    // Exchange rate context
    if (contextFilters.containsKey('exchangeRate')) {
      final exchangeRate = contextFilters['exchangeRate'] as double?;
      if (exchangeRate != null && exchangeRate < 1.0) {
        // Favorable exchange rate
        score += 0.1;
        factors++;
      }
    }

    // Local events context
    if (contextFilters.containsKey('events')) {
      final events = contextFilters['events'] as List<String>?;
      if (events != null && events.isNotEmpty) {
        score += 0.15;
        factors++;
      }
    }

    return score;
  }

  Future<AIRecommendationModel> _createRecommendation(
    TravelPackageModel package,
    double confidence,
    RecommendationType type,
    String userId, {
    required List<String> reasons,
    required RecommendationStrategy strategy,
    List<UserPreference>? matchedPreferences,
  }) async {
    return AIRecommendationModel(
      id: '${package.id}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: type,
      title: package.title,
      description: package.description,
      confidence: confidence,
      confidenceLevel: _getConfidenceLevel(confidence),
      content: RecommendationContent(
        packageId: package.id,
        priceRange: PriceRange(
          min: package.pricingInfo.basePrice,
          max: package.pricingInfo.basePrice * 1.2,
          category: _categorizePriceRange(package.pricingInfo.basePrice),
        ),
        currency: package.pricingInfo.currency,
        duration: '${package.durationDays} days',
        highlights: package.itinerary.take(3).map((day) => day.title).toList(),
      ),
      reasons: reasons,
      tags: package.tags,
      rating: package.rating,
      imageUrl: package.thumbnailImage,
      userContext: UserContext(
        searchHistory: [],
        bookingHistory: [],
        viewedItems: [],
        likedItems: [],
        contextTimestamp: DateTime.now(),
      ),
      matchedPreferences: matchedPreferences ?? [],
      modelInfo: ModelInfo(
        modelName: 'TravelMate Hybrid Recommender',
        modelVersion: '1.0',
        algorithm: strategy.name,
        accuracy: confidence,
        trainedAt: DateTime.now(),
        hyperparameters: {'strategy_weight': _strategyWeights[strategy] ?? 1.0},
        features: ['user_preferences', 'collaborative_filtering', 'content_based'],
      ),
      additionalData: {
        'package_type': package.packageType.name,
        'destination': package.destination,
        'duration_days': package.durationDays,
        'base_price': package.pricingInfo.basePrice,
        'rating': package.rating,
        'review_count': package.reviewCount,
      },
      isViewed: false,
      isLiked: false,
      isBookmarked: false,
      isBooked: false,
      generatedAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }

  // Additional helper methods...

  ConfidenceLevel _getConfidenceLevel(double confidence) {
    if (confidence >= 0.8) return ConfidenceLevel.veryHigh;
    if (confidence >= 0.6) return ConfidenceLevel.high;
    if (confidence >= 0.4) return ConfidenceLevel.medium;
    return ConfidenceLevel.low;
  }

  String _categorizePriceRange(double price) {
    if (price < 1000000) return 'budget';
    if (price < 3000000) return 'mid-range';
    if (price < 6000000) return 'premium';
    return 'luxury';
  }

  Future<List<UserPreference>> _identifyMatchedPreferences(
    TravelPackageModel candidate,
    UserPreferenceProfile userPrefs,
  ) async {
    final matched = <UserPreference>[];

    // Check destination preferences
    for (final country in candidate.countries) {
      final score = userPrefs.destinationPreferences[country.toLowerCase()];
      if (score != null && score > 0.3) {
        matched.add(UserPreference(
          id: 'dest_$country',
          category: PreferenceCategory.destination,
          name: country,
          weight: score,
          value: country,
          matchScore: score,
          reason: 'Matches your destination preferences',
        ));
      }
    }

    // Check activity preferences
    for (final category in candidate.categories) {
      final score = userPrefs.activityPreferences[category.toLowerCase()];
      if (score != null && score > 0.3) {
        matched.add(UserPreference(
          id: 'activity_$category',
          category: PreferenceCategory.activity,
          name: category,
          weight: score,
          value: category,
          matchScore: score,
          reason: 'Matches your activity preferences',
        ));
      }
    }

    return matched;
  }

  List<String> _generateContentBasedReasons(List<UserPreference> matchedPreferences) {
    final reasons = <String>[];
    
    for (final pref in matchedPreferences.take(3)) {
      switch (pref.category) {
        case PreferenceCategory.destination:
          reasons.add('You\'ve shown interest in ${pref.name}');
          break;
        case PreferenceCategory.activity:
          reasons.add('Includes ${pref.name} activities you enjoy');
          break;
        default:
          reasons.add('Matches your preferences for ${pref.name}');
      }
    }

    return reasons;
  }

  Future<List<String>> _generateContextualReasons(
    TravelPackageModel candidate,
    Map<String, dynamic> contextFilters,
  ) async {
    final reasons = <String>[];

    if (contextFilters.containsKey('season')) {
      reasons.add('Perfect for ${contextFilters['season']} travel');
    }

    if (contextFilters.containsKey('exchangeRate')) {
      reasons.add('Great value with current exchange rates');
    }

    if (contextFilters.containsKey('events')) {
      reasons.add('Coincides with local events and festivals');
    }

    return reasons.isNotEmpty ? reasons : ['Recommended based on current trends'];
  }

  // Utility methods for calculations and processing...

  double _calculateSpendingRangeSimilarity(
    Map<String, double> range1,
    Map<String, double> range2,
  ) {
    final min1 = range1['min']!;
    final max1 = range1['max']!;
    final min2 = range2['min']!;
    final max2 = range2['max']!;

    final overlapMin = max(min1, min2);
    final overlapMax = min(max1, max2);

    if (overlapMin >= overlapMax) return 0.0; // No overlap

    final overlapSize = overlapMax - overlapMin;
    final totalSize = max(max1, max2) - min(min1, min2);

    return overlapSize / totalSize;
  }

  Future<List<AIRecommendationModel>> _applyDiversityFiltering(
    List<AIRecommendationModel> recommendations,
  ) async {
    final diverseRecs = <AIRecommendationModel>[];
    final usedDestinations = <String>{};
    final usedCategories = <String>{};

    for (final rec in recommendations) {
      final destination = rec.additionalData['destination'] as String?;
      final categories = rec.tags;

      bool isDiverse = true;

      // Check destination diversity
      if (destination != null && usedDestinations.contains(destination)) {
        if (usedDestinations.length < 3) {
          isDiverse = false;
        }
      }

      // Check category diversity
      final hasNewCategory = categories.any((cat) => !usedCategories.contains(cat));
      if (!hasNewCategory && usedCategories.length < 5) {
        isDiverse = false;
      }

      if (isDiverse || diverseRecs.length < 5) {
        diverseRecs.add(rec);
        if (destination != null) usedDestinations.add(destination);
        usedCategories.addAll(categories);
      }

      if (diverseRecs.length >= 20) break; // Limit processing
    }

    return diverseRecs;
  }

  double _calculateAverageConfidence(List<AIRecommendationModel> recommendations) {
    if (recommendations.isEmpty) return 0.0;
    
    final total = recommendations.fold<double>(0.0, (sum, rec) => sum + rec.confidence);
    return total / recommendations.length;
  }

  Map<RecommendationStrategy, double> _calculateStrategyContributions(
    List<AIRecommendationModel> recommendations,
  ) {
    final contributions = <RecommendationStrategy, double>{};
    
    for (final rec in recommendations) {
      final strategy = RecommendationStrategy.values.firstWhere(
        (s) => s.name == rec.modelInfo.algorithm,
        orElse: () => RecommendationStrategy.hybrid,
      );
      
      contributions[strategy] = (contributions[strategy] ?? 0.0) + rec.confidence;
    }

    // Normalize
    final total = contributions.values.fold<double>(0.0, (sum, value) => sum + value);
    if (total > 0) {
      contributions.updateAll((key, value) => value / total);
    }

    return contributions;
  }

  Map<String, int> _calculateDiversityMetrics(List<AIRecommendationModel> recommendations) {
    final uniqueDestinations = <String>{};
    final uniqueCategories = <String>{};
    final priceRanges = <String>{};

    for (final rec in recommendations) {
      final destination = rec.additionalData['destination'] as String?;
      if (destination != null) uniqueDestinations.add(destination);

      uniqueCategories.addAll(rec.tags);

      final priceRange = rec.content.priceRange?.category;
      if (priceRange != null) priceRanges.add(priceRange);
    }

    return {
      'unique_destinations': uniqueDestinations.length,
      'unique_categories': uniqueCategories.length,
      'price_ranges': priceRanges.length,
    };
  }

  Future<Map<String, dynamic>> _generateExplanations(
    List<AIRecommendationModel> recommendations,
    RecommendationRequest request,
  ) async {
    return {
      'total_recommendations': recommendations.length,
      'primary_strategy': request.strategy.name,
      'personalization_level': request.userPreferences != null ? 'high' : 'medium',
      'confidence_distribution': _getConfidenceDistribution(recommendations),
      'top_reasons': _getTopReasons(recommendations),
    };
  }

  Map<String, int> _getConfidenceDistribution(List<AIRecommendationModel> recommendations) {
    final distribution = <String, int>{
      'very_high': 0,
      'high': 0,
      'medium': 0,
      'low': 0,
    };

    for (final rec in recommendations) {
      distribution[rec.confidenceLevel.name] = 
          (distribution[rec.confidenceLevel.name] ?? 0) + 1;
    }

    return distribution;
  }

  List<String> _getTopReasons(List<AIRecommendationModel> recommendations) {
    final reasonCounts = <String, int>{};

    for (final rec in recommendations) {
      for (final reason in rec.reasons) {
        reasonCounts[reason] = (reasonCounts[reason] ?? 0) + 1;
      }
    }

    final sortedReasons = reasonCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedReasons.take(5).map((e) => e.key).toList();
  }

  // Data management methods

  void updateUserBookingHistory(String userId, List<BookingModel> bookings) {
    _userBookingHistory[userId] = bookings;
  }

  void updateUserPreferences(String userId, UserPreferenceProfile preferences) {
    _userPreferences[userId] = preferences;
  }

  void updateUserTravelStyle(String userId, TravelStyleProfile travelStyle) {
    _userTravelStyles[userId] = travelStyle;
  }

  void updateAvailablePackages(List<TravelPackageModel> packages) {
    _availablePackages.clear();
    _availablePackages.addAll(packages);
  }
}

// Supporting classes

class SimilarUser {
  final String userId;
  final double similarity;
  final List<BookingModel> bookings;

  const SimilarUser({
    required this.userId,
    required this.similarity,
    required this.bookings,
  });
}

class CombinedRecommendation {
  final AIRecommendationModel recommendation;
  final Map<RecommendationStrategy, double> strategyScores;
  double combinedScore;
  final Set<String> reasons;

  CombinedRecommendation({
    required this.recommendation,
    required this.strategyScores,
    required this.combinedScore,
    required this.reasons,
  });
}

class RecommendationException implements Exception {
  final String message;
  const RecommendationException(this.message);
  
  @override
  String toString() => 'RecommendationException: $message';
}

// Extension methods

extension AIRecommendationModelExtension on AIRecommendationModel {
  AIRecommendationModel copyWith({
    String? id,
    String? userId,
    RecommendationType? type,
    String? title,
    String? description,
    double? confidence,
    ConfidenceLevel? confidenceLevel,
    RecommendationContent? content,
    List<String>? reasons,
    List<String>? tags,
    double? rating,
    String? imageUrl,
    UserContext? userContext,
    List<UserPreference>? matchedPreferences,
    ModelInfo? modelInfo,
    Map<String, dynamic>? additionalData,
    bool? isViewed,
    bool? isLiked,
    bool? isBookmarked,
    bool? isBooked,
    DateTime? viewedAt,
    DateTime? interactedAt,
    DateTime? generatedAt,
    DateTime? expiresAt,
  }) {
    return AIRecommendationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      confidence: confidence ?? this.confidence,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      content: content ?? this.content,
      reasons: reasons ?? this.reasons,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      userContext: userContext ?? this.userContext,
      matchedPreferences: matchedPreferences ?? this.matchedPreferences,
      modelInfo: modelInfo ?? this.modelInfo,
      additionalData: additionalData ?? this.additionalData,
      isViewed: isViewed ?? this.isViewed,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isBooked: isBooked ?? this.isBooked,
      viewedAt: viewedAt ?? this.viewedAt,
      interactedAt: interactedAt ?? this.interactedAt,
      generatedAt: generatedAt ?? this.generatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}