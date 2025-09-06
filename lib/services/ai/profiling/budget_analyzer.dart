import 'dart:math';

import '../../../data/models/booking_model.dart';
import '../../../data/models/user_model.dart';
import 'travel_style_classifier.dart';

enum BudgetCategory { ultraLow, low, moderate, high, luxury, unlimited }

class BudgetProfile {
  final BudgetCategory primaryCategory;
  final double averageSpendingPerDay;
  final double averageTotalSpending;
  final Map<String, double> spendingByCategory;
  final BudgetRangePreference rangePreference;
  final List<BudgetPattern> patterns;
  final double flexibility;
  final DateTime analyzedAt;
  final double confidence;

  const BudgetProfile({
    required this.primaryCategory,
    required this.averageSpendingPerDay,
    required this.averageTotalSpending,
    required this.spendingByCategory,
    required this.rangePreference,
    required this.patterns,
    required this.flexibility,
    required this.analyzedAt,
    required this.confidence,
  });

  bool isWithinBudget(double amount) {
    final range = rangePreference;
    return amount >= range.minBudget && amount <= range.maxBudget;
  }

  double getBudgetUtilization(double amount) {
    final range = rangePreference;
    if (range.maxBudget == range.minBudget) return 1.0;
    return (amount - range.minBudget) / (range.maxBudget - range.minBudget);
  }

  BudgetCategory categorizeBudget(double amount) {
    if (amount < 500000) return BudgetCategory.ultraLow;
    if (amount < 1500000) return BudgetCategory.low;
    if (amount < 3000000) return BudgetCategory.moderate;
    if (amount < 6000000) return BudgetCategory.high;
    if (amount < 12000000) return BudgetCategory.luxury;
    return BudgetCategory.unlimited;
  }
}

class BudgetRangePreference {
  final double minBudget;
  final double maxBudget;
  final double preferredBudget;
  final String currency;
  final double confidence;

  const BudgetRangePreference({
    required this.minBudget,
    required this.maxBudget,
    required this.preferredBudget,
    required this.currency,
    required this.confidence,
  });

  double get range => maxBudget - minBudget;
  double get midpoint => (minBudget + maxBudget) / 2;
  
  bool contains(double amount) => amount >= minBudget && amount <= maxBudget;
}

class BudgetPattern {
  final String patternType;
  final String description;
  final double strength;
  final Map<String, dynamic> parameters;

  const BudgetPattern({
    required this.patternType,
    required this.description,
    required this.strength,
    required this.parameters,
  });
}

class SeasonalBudgetAdjustment {
  final String season;
  final double multiplier;
  final String reason;

  const SeasonalBudgetAdjustment({
    required this.season,
    required this.multiplier,
    required this.reason,
  });
}

class BudgetAnalyzer {
  static const Map<BudgetCategory, Map<String, double>> _categoryRanges = {
    BudgetCategory.ultraLow: {'min': 0, 'max': 500000},
    BudgetCategory.low: {'min': 500000, 'max': 1500000},
    BudgetCategory.moderate: {'min': 1500000, 'max': 3000000},
    BudgetCategory.high: {'min': 3000000, 'max': 6000000},
    BudgetCategory.luxury: {'min': 6000000, 'max': 12000000},
    BudgetCategory.unlimited: {'min': 12000000, 'max': double.infinity},
  };

  /// Analyzes user's historical bookings to determine budget patterns
  Future<BudgetProfile> analyzeBudgetProfile({
    required List<BookingModel> bookings,
    UserModel? user,
    TravelStyleProfile? travelStyle,
    DateTime? cutoffDate,
  }) async {
    final effectiveCutoffDate = cutoffDate ?? DateTime.now().subtract(const Duration(days: 365 * 2));
    final recentBookings = bookings
        .where((booking) => booking.createdAt.isAfter(effectiveCutoffDate))
        .toList();

    if (recentBookings.isEmpty) {
      return _createDefaultProfile();
    }

    final spendingData = await _extractSpendingData(recentBookings);
    final categorySpending = await _analyzeSpendingByCategory(recentBookings);
    final rangePreference = await _calculateBudgetRange(spendingData, travelStyle);
    final patterns = await _identifyBudgetPatterns(recentBookings);
    final flexibility = await _calculateBudgetFlexibility(spendingData);

    final averageTotal = spendingData.fold<double>(0.0, (sum, data) => sum + data.totalSpending) / spendingData.length;
    final averagePerDay = spendingData.fold<double>(0.0, (sum, data) => sum + data.spendingPerDay) / spendingData.length;

    final primaryCategory = _categorizeBudget(averageTotal);
    final confidence = _calculateConfidence(recentBookings.length, spendingData);

    return BudgetProfile(
      primaryCategory: primaryCategory,
      averageSpendingPerDay: averagePerDay,
      averageTotalSpending: averageTotal,
      spendingByCategory: categorySpending,
      rangePreference: rangePreference,
      patterns: patterns,
      flexibility: flexibility,
      analyzedAt: DateTime.now(),
      confidence: confidence,
    );
  }

  /// Predicts budget for a new trip based on parameters
  Future<BudgetPrediction> predictTripBudget({
    required BudgetProfile budgetProfile,
    required int durationDays,
    required int travelers,
    required DateTime travelDate,
    String? destination,
    TravelStyle? travelStyle,
    List<String>? activities,
  }) async {
    // Base prediction from user's average spending
    double baseBudget = budgetProfile.averageSpendingPerDay * durationDays;

    // Adjust for number of travelers
    final travelerMultiplier = _calculateTravelerMultiplier(travelers);
    baseBudget *= travelerMultiplier;

    // Seasonal adjustments
    final seasonalAdjustment = await _getSeasonalAdjustment(travelDate, destination);
    baseBudget *= seasonalAdjustment.multiplier;

    // Destination adjustments
    final destinationMultiplier = await _getDestinationMultiplier(destination);
    baseBudget *= destinationMultiplier;

    // Travel style adjustments
    final styleMultiplier = _getTravelStyleMultiplier(travelStyle);
    baseBudget *= styleMultiplier;

    // Activity-based adjustments
    final activityMultiplier = await _getActivityMultiplier(activities);
    baseBudget *= activityMultiplier;

    // Calculate range based on flexibility
    final flexibility = budgetProfile.flexibility;
    final minBudget = baseBudget * (1 - flexibility * 0.3);
    final maxBudget = baseBudget * (1 + flexibility * 0.5);

    return BudgetPrediction(
      predictedBudget: baseBudget,
      minBudget: minBudget,
      maxBudget: maxBudget,
      budgetBreakdown: await _createBudgetBreakdown(baseBudget, travelStyle),
      confidence: budgetProfile.confidence * 0.8, // Reduce confidence for predictions
      adjustments: [
        if (travelerMultiplier != 1.0) 
          BudgetAdjustment('travelers', travelerMultiplier, 'Adjusted for $travelers travelers'),
        if (seasonalAdjustment.multiplier != 1.0) seasonalAdjustment,
        if (destinationMultiplier != 1.0) 
          BudgetAdjustment('destination', destinationMultiplier, 'Destination price adjustment'),
        if (styleMultiplier != 1.0) 
          BudgetAdjustment('style', styleMultiplier, 'Travel style adjustment'),
        if (activityMultiplier != 1.0) 
          BudgetAdjustment('activities', activityMultiplier, 'Activity-based adjustment'),
      ],
    );
  }

  /// Optimizes budget allocation across different categories
  Future<BudgetOptimization> optimizeBudgetAllocation({
    required BudgetProfile budgetProfile,
    required double totalBudget,
    required int durationDays,
    TravelStyle? travelStyle,
    Map<String, double>? constraints,
  }) async {
    final baseAllocation = await _getBaseAllocation(travelStyle);
    final userPreferences = budgetProfile.spendingByCategory;

    // Blend base allocation with user preferences
    final optimizedAllocation = <String, double>{};
    final blendRatio = 0.7; // 70% user preference, 30% base allocation

    for (final category in baseAllocation.keys) {
      final baseRatio = baseAllocation[category] ?? 0.0;
      final userRatio = userPreferences[category] ?? baseRatio;
      optimizedAllocation[category] = (userRatio * blendRatio) + (baseRatio * (1 - blendRatio));
    }

    // Apply constraints
    if (constraints != null) {
      for (final entry in constraints.entries) {
        if (optimizedAllocation.containsKey(entry.key)) {
          optimizedAllocation[entry.key] = entry.value;
        }
      }
    }

    // Normalize to ensure total equals 1.0
    final total = optimizedAllocation.values.fold<double>(0.0, (sum, value) => sum + value);
    if (total != 0) {
      optimizedAllocation.updateAll((key, value) => value / total);
    }

    // Convert to actual amounts
    final allocation = optimizedAllocation.map((key, ratio) => 
        MapEntry(key, totalBudget * ratio));

    // Calculate daily breakdown
    final dailyAllocation = allocation.map((key, amount) => 
        MapEntry(key, amount / durationDays));

    return BudgetOptimization(
      totalBudget: totalBudget,
      categoryAllocation: allocation,
      dailyAllocation: dailyAllocation,
      optimizationScore: _calculateOptimizationScore(optimizedAllocation, userPreferences),
      recommendations: await _generateBudgetRecommendations(allocation, travelStyle),
    );
  }

  /// Compares budget with similar users
  Future<BudgetComparison> compareBudgetWithPeers({
    required BudgetProfile userBudget,
    required List<BudgetProfile> peerBudgets,
    TravelStyle? travelStyle,
  }) async {
    final relevantPeers = peerBudgets.where((peer) {
      // Filter peers with similar characteristics
      final categoryDiff = (peer.primaryCategory.index - userBudget.primaryCategory.index).abs();
      return categoryDiff <= 1; // Allow adjacent budget categories
    }).toList();

    if (relevantPeers.isEmpty) {
      return BudgetComparison(
        userBudget: userBudget,
        peerAverage: userBudget.averageTotalSpending,
        percentile: 50.0,
        comparison: BudgetComparisonResult.average,
        insights: ['Insufficient peer data for comparison'],
      );
    }

    final peerAverages = relevantPeers.map((p) => p.averageTotalSpending).toList()..sort();
    final peerAverage = peerAverages.fold<double>(0.0, (sum, amount) => sum + amount) / peerAverages.length;
    
    final userSpending = userBudget.averageTotalSpending;
    final percentile = _calculatePercentile(userSpending, peerAverages);

    BudgetComparisonResult comparison;
    if (percentile < 25) {
      comparison = BudgetComparisonResult.low;
    } else if (percentile < 75) {
      comparison = BudgetComparisonResult.average;
    } else {
      comparison = BudgetComparisonResult.high;
    }

    final insights = await _generateComparisonInsights(userBudget, relevantPeers, percentile);

    return BudgetComparison(
      userBudget: userBudget,
      peerAverage: peerAverage,
      percentile: percentile,
      comparison: comparison,
      insights: insights,
    );
  }

  /// Detects budget anomalies and unusual patterns
  Future<List<BudgetAnomaly>> detectBudgetAnomalies({
    required List<BookingModel> bookings,
    required BudgetProfile budgetProfile,
  }) async {
    final anomalies = <BudgetAnomaly>[];
    final expectedRange = budgetProfile.rangePreference;

    for (final booking in bookings) {
      final spendingPerDay = booking.pricing.totalPrice / 
          booking.travelEndDate.difference(booking.travelStartDate).inDays;

      // Check for spending outside normal range
      if (!expectedRange.contains(booking.pricing.totalPrice)) {
        final deviation = booking.pricing.totalPrice > expectedRange.maxBudget
            ? (booking.pricing.totalPrice - expectedRange.maxBudget) / expectedRange.maxBudget
            : (expectedRange.minBudget - booking.pricing.totalPrice) / expectedRange.minBudget;

        if (deviation > 0.5) { // 50% deviation threshold
          anomalies.add(BudgetAnomaly(
            bookingId: booking.id,
            anomalyType: booking.pricing.totalPrice > expectedRange.maxBudget 
                ? BudgetAnomalyType.excessiveSpending 
                : BudgetAnomalyType.unusuallyLow,
            amount: booking.pricing.totalPrice,
            expectedAmount: expectedRange.preferredBudget,
            deviation: deviation,
            detectedAt: DateTime.now(),
            possibleReasons: await _identifyAnomalyReasons(booking, budgetProfile),
          ));
        }
      }

      // Check for unusual spending patterns within a trip
      final categorySpending = await _analyzeTripSpending(booking);
      final unusualCategories = _detectUnusualCategorySpending(
          categorySpending, budgetProfile.spendingByCategory);
      
      if (unusualCategories.isNotEmpty) {
        anomalies.add(BudgetAnomaly(
          bookingId: booking.id,
          anomalyType: BudgetAnomalyType.unusualPattern,
          amount: booking.pricing.totalPrice,
          expectedAmount: budgetProfile.averageTotalSpending,
          deviation: 0.0,
          detectedAt: DateTime.now(),
          possibleReasons: unusualCategories.map((cat) => 'Unusual spending in $cat').toList(),
        ));
      }
    }

    return anomalies;
  }

  // Private helper methods

  Future<List<SpendingData>> _extractSpendingData(List<BookingModel> bookings) async {
    return bookings.map((booking) {
      final duration = booking.travelEndDate.difference(booking.travelStartDate).inDays;
      return SpendingData(
        bookingId: booking.id,
        totalSpending: booking.pricing.totalPrice,
        spendingPerDay: duration > 0 ? booking.pricing.totalPrice / duration : booking.pricing.totalPrice,
        duration: duration,
        travelers: booking.numberOfTravelers,
        travelDate: booking.travelStartDate,
        currency: booking.pricing.currency,
      );
    }).toList();
  }

  Future<Map<String, double>> _analyzeSpendingByCategory(List<BookingModel> bookings) async {
    final categoryTotals = <String, double>{};
    double totalSpending = 0.0;

    for (final booking in bookings) {
      totalSpending += booking.pricing.totalPrice;

      // Estimate category spending from booking details
      final categoryBreakdown = await _estimateCategorySpending(booking);
      
      for (final entry in categoryBreakdown.entries) {
        categoryTotals[entry.key] = (categoryTotals[entry.key] ?? 0.0) + entry.value;
      }
    }

    // Convert to ratios
    return categoryTotals.map((key, amount) => 
        MapEntry(key, totalSpending > 0 ? amount / totalSpending : 0.0));
  }

  Future<Map<String, double>> _estimateCategorySpending(BookingModel booking) async {
    final breakdown = <String, double>{};
    final total = booking.pricing.totalPrice;

    // Estimate accommodation costs (typically 40-60% of total)
    if (booking.hotelBookings?.isNotEmpty == true) {
      breakdown['accommodation'] = total * 0.45;
    } else {
      breakdown['accommodation'] = total * 0.35; // Lower if no specific hotel booking
    }

    // Estimate transportation costs (typically 20-30% of total)
    if (booking.flightBookings?.isNotEmpty == true) {
      breakdown['transportation'] = total * 0.25;
    } else {
      breakdown['transportation'] = total * 0.15;
    }

    // Estimate food costs (typically 15-25% of total)
    breakdown['food'] = total * 0.2;

    // Activities and additional services
    if (booking.additionalServices?.isNotEmpty == true) {
      final activitiesCost = booking.additionalServices!
          .fold<double>(0.0, (sum, service) => sum + service.price);
      breakdown['activities'] = activitiesCost;
    } else {
      breakdown['activities'] = total * 0.1;
    }

    // Miscellaneous (shopping, tips, etc.)
    breakdown['miscellaneous'] = total * 0.1;

    return breakdown;
  }

  Future<BudgetRangePreference> _calculateBudgetRange(
    List<SpendingData> spendingData,
    TravelStyleProfile? travelStyle,
  ) async {
    final amounts = spendingData.map((data) => data.totalSpending).toList()..sort();
    
    if (amounts.isEmpty) {
      return const BudgetRangePreference(
        minBudget: 500000,
        maxBudget: 2000000,
        preferredBudget: 1000000,
        currency: 'KRW',
        confidence: 0.0,
      );
    }

    final mean = amounts.fold<double>(0.0, (sum, amount) => sum + amount) / amounts.length;
    final stdDev = _calculateStandardDeviation(amounts, mean);

    // Calculate range based on standard deviation
    final minBudget = max(0, mean - stdDev);
    final maxBudget = mean + stdDev;

    // Adjust based on travel style if available
    double styleMultiplier = 1.0;
    if (travelStyle != null) {
      switch (travelStyle.primaryStyle) {
        case TravelStyle.luxury:
          styleMultiplier = 1.5;
          break;
        case TravelStyle.budget:
          styleMultiplier = 0.6;
          break;
        case TravelStyle.backpacker:
          styleMultiplier = 0.4;
          break;
        default:
          styleMultiplier = 1.0;
      }
    }

    final adjustedMin = minBudget * styleMultiplier;
    final adjustedMax = maxBudget * styleMultiplier;
    final adjustedPreferred = mean * styleMultiplier;

    final confidence = _calculateRangeConfidence(amounts.length, stdDev, mean);

    return BudgetRangePreference(
      minBudget: adjustedMin,
      maxBudget: adjustedMax,
      preferredBudget: adjustedPreferred,
      currency: spendingData.first.currency,
      confidence: confidence,
    );
  }

  Future<List<BudgetPattern>> _identifyBudgetPatterns(List<BookingModel> bookings) async {
    final patterns = <BudgetPattern>[];

    // Seasonal spending patterns
    final seasonalPattern = await _analyzeSeasonalSpending(bookings);
    if (seasonalPattern != null) patterns.add(seasonalPattern);

    // Duration-based patterns
    final durationPattern = await _analyzeDurationSpending(bookings);
    if (durationPattern != null) patterns.add(durationPattern);

    // Companion-based patterns
    final companionPattern = await _analyzeCompanionSpending(bookings);
    if (companionPattern != null) patterns.add(companionPattern);

    // Advance booking patterns
    final advanceBookingPattern = await _analyzeAdvanceBookingSpending(bookings);
    if (advanceBookingPattern != null) patterns.add(advanceBookingPattern);

    return patterns;
  }

  Future<double> _calculateBudgetFlexibility(List<SpendingData> spendingData) async {
    if (spendingData.length < 2) return 0.5; // Default moderate flexibility

    final amounts = spendingData.map((data) => data.totalSpending).toList();
    final mean = amounts.fold<double>(0.0, (sum, amount) => sum + amount) / amounts.length;
    final coefficientOfVariation = _calculateStandardDeviation(amounts, mean) / mean;

    // Higher CV indicates more flexibility/variation in spending
    return min(1.0, coefficientOfVariation);
  }

  BudgetCategory _categorizeBudget(double amount) {
    for (final entry in _categoryRanges.entries) {
      final range = entry.value;
      if (amount >= range['min']! && amount < range['max']!) {
        return entry.key;
      }
    }
    return BudgetCategory.unlimited;
  }

  double _calculateConfidence(int dataPoints, List<SpendingData> spendingData) {
    if (dataPoints < 2) return 0.2;
    if (dataPoints < 5) return 0.5;

    // Factor in data consistency
    final amounts = spendingData.map((data) => data.totalSpending).toList();
    final mean = amounts.fold<double>(0.0, (sum, amount) => sum + amount) / amounts.length;
    final consistency = 1.0 - (_calculateStandardDeviation(amounts, mean) / mean);

    final dataConfidence = min(dataPoints / 10.0, 1.0);
    return (dataConfidence * 0.7) + (consistency * 0.3);
  }

  BudgetProfile _createDefaultProfile() {
    return BudgetProfile(
      primaryCategory: BudgetCategory.moderate,
      averageSpendingPerDay: 200000,
      averageTotalSpending: 1200000,
      spendingByCategory: {
        'accommodation': 0.4,
        'transportation': 0.25,
        'food': 0.2,
        'activities': 0.1,
        'miscellaneous': 0.05,
      },
      rangePreference: const BudgetRangePreference(
        minBudget: 800000,
        maxBudget: 2000000,
        preferredBudget: 1200000,
        currency: 'KRW',
        confidence: 0.0,
      ),
      patterns: [],
      flexibility: 0.3,
      analyzedAt: DateTime.now(),
      confidence: 0.0,
    );
  }

  double _calculateStandardDeviation(List<double> values, double mean) {
    final squaredDiffs = values.map((value) => pow(value - mean, 2));
    final variance = squaredDiffs.fold<double>(0.0, (sum, diff) => sum + diff) / values.length;
    return sqrt(variance);
  }

  double _calculateTravelerMultiplier(int travelers) {
    // Economies of scale for multiple travelers
    if (travelers <= 1) return 1.0;
    if (travelers == 2) return 1.8;
    if (travelers <= 4) return 2.5;
    return travelers * 0.8; // Further economies for larger groups
  }

  Future<SeasonalBudgetAdjustment> _getSeasonalAdjustment(DateTime travelDate, String? destination) async {
    final month = travelDate.month;
    final season = _getSeason(month);

    // General seasonal adjustments (can be enhanced with destination-specific data)
    switch (season) {
      case 'summer':
        return const SeasonalBudgetAdjustment(
          season: 'summer',
          multiplier: 1.2,
          reason: 'Peak season pricing',
        );
      case 'winter':
        return const SeasonalBudgetAdjustment(
          season: 'winter',
          multiplier: 1.1,
          reason: 'Holiday season pricing',
        );
      case 'spring':
      case 'autumn':
        return const SeasonalBudgetAdjustment(
          season: season,
          multiplier: 0.9,
          reason: 'Shoulder season savings',
        );
      default:
        return const SeasonalBudgetAdjustment(
          season: 'unknown',
          multiplier: 1.0,
          reason: 'No seasonal adjustment',
        );
    }
  }

  Future<double> _getDestinationMultiplier(String? destination) async {
    if (destination == null) return 1.0;

    // Simplified destination cost multipliers (should be data-driven in production)
    final costMultipliers = <String, double>{
      'japan': 1.3,
      'singapore': 1.2,
      'thailand': 0.7,
      'vietnam': 0.6,
      'malaysia': 0.8,
      'korea': 1.0,
    };

    return costMultipliers[destination.toLowerCase()] ?? 1.0;
  }

  double _getTravelStyleMultiplier(TravelStyle? travelStyle) {
    if (travelStyle == null) return 1.0;

    switch (travelStyle) {
      case TravelStyle.luxury:
        return 1.8;
      case TravelStyle.budget:
        return 0.6;
      case TravelStyle.backpacker:
        return 0.4;
      case TravelStyle.business:
        return 1.3;
      case TravelStyle.family:
        return 1.1;
      default:
        return 1.0;
    }
  }

  Future<double> _getActivityMultiplier(List<String>? activities) async {
    if (activities == null || activities.isEmpty) return 1.0;

    // Activity cost multipliers
    final activityMultipliers = <String, double>{
      'adventure': 1.3,
      'luxury': 1.5,
      'wellness': 1.2,
      'cultural': 0.9,
      'culinary': 1.1,
    };

    double totalMultiplier = 0.0;
    for (final activity in activities) {
      totalMultiplier += activityMultipliers[activity] ?? 1.0;
    }

    return totalMultiplier / activities.length;
  }

  Future<Map<String, double>> _createBudgetBreakdown(double totalBudget, TravelStyle? travelStyle) async {
    final baseBreakdown = <String, double>{
      'accommodation': 0.4,
      'transportation': 0.25,
      'food': 0.2,
      'activities': 0.1,
      'miscellaneous': 0.05,
    };

    // Adjust breakdown based on travel style
    if (travelStyle != null) {
      switch (travelStyle) {
        case TravelStyle.luxury:
          baseBreakdown['accommodation'] = 0.5;
          baseBreakdown['food'] = 0.25;
          baseBreakdown['activities'] = 0.15;
          break;
        case TravelStyle.budget:
          baseBreakdown['accommodation'] = 0.3;
          baseBreakdown['transportation'] = 0.3;
          baseBreakdown['food'] = 0.25;
          break;
        case TravelStyle.adventure:
          baseBreakdown['activities'] = 0.2;
          baseBreakdown['accommodation'] = 0.35;
          break;
        default:
          // Keep base breakdown
          break;
      }
    }

    return baseBreakdown.map((key, ratio) => MapEntry(key, totalBudget * ratio));
  }

  String _getSeason(int month) {
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  // Additional helper methods for pattern analysis, anomaly detection, etc.
  // ... (implementation details for remaining methods)
  
  Future<BudgetPattern?> _analyzeSeasonalSpending(List<BookingModel> bookings) async {
    // Implementation for seasonal spending analysis
    return null; // Placeholder
  }

  Future<BudgetPattern?> _analyzeDurationSpending(List<BookingModel> bookings) async {
    // Implementation for duration-based spending analysis
    return null; // Placeholder
  }

  Future<BudgetPattern?> _analyzeCompanionSpending(List<BookingModel> bookings) async {
    // Implementation for companion-based spending analysis
    return null; // Placeholder
  }

  Future<BudgetPattern?> _analyzeAdvanceBookingSpending(List<BookingModel> bookings) async {
    // Implementation for advance booking spending analysis
    return null; // Placeholder
  }

  Future<Map<String, double>> _getBaseAllocation(TravelStyle? travelStyle) async {
    // Implementation for base allocation calculation
    return {
      'accommodation': 0.4,
      'transportation': 0.25,
      'food': 0.2,
      'activities': 0.1,
      'miscellaneous': 0.05,
    };
  }

  double _calculateOptimizationScore(Map<String, double> optimized, Map<String, double> user) {
    // Implementation for optimization score calculation
    return 0.8; // Placeholder
  }

  Future<List<String>> _generateBudgetRecommendations(Map<String, double> allocation, TravelStyle? travelStyle) async {
    // Implementation for budget recommendations
    return ['Consider allocating more for accommodation', 'Look for activity discounts']; // Placeholder
  }

  double _calculatePercentile(double value, List<double> sortedValues) {
    // Implementation for percentile calculation
    final index = sortedValues.indexWhere((v) => v >= value);
    return index < 0 ? 100.0 : (index / sortedValues.length) * 100;
  }

  Future<List<String>> _generateComparisonInsights(BudgetProfile user, List<BudgetProfile> peers, double percentile) async {
    // Implementation for comparison insights
    return ['Your spending is typical for your travel style']; // Placeholder
  }

  Future<List<String>> _identifyAnomalyReasons(BookingModel booking, BudgetProfile profile) async {
    // Implementation for anomaly reason identification
    return ['Special occasion', 'Peak season']; // Placeholder
  }

  Future<Map<String, double>> _analyzeTripSpending(BookingModel booking) async {
    // Implementation for trip spending analysis
    return await _estimateCategorySpending(booking);
  }

  List<String> _detectUnusualCategorySpending(Map<String, double> trip, Map<String, double> profile) {
    // Implementation for unusual category spending detection
    return []; // Placeholder
  }

  double _calculateRangeConfidence(int dataPoints, double stdDev, double mean) {
    // Implementation for range confidence calculation
    return min(1.0, dataPoints / 10.0) * (1.0 - (stdDev / mean));
  }
}

// Supporting classes
class SpendingData {
  final String bookingId;
  final double totalSpending;
  final double spendingPerDay;
  final int duration;
  final int travelers;
  final DateTime travelDate;
  final String currency;

  const SpendingData({
    required this.bookingId,
    required this.totalSpending,
    required this.spendingPerDay,
    required this.duration,
    required this.travelers,
    required this.travelDate,
    required this.currency,
  });
}

class BudgetPrediction {
  final double predictedBudget;
  final double minBudget;
  final double maxBudget;
  final Map<String, double> budgetBreakdown;
  final double confidence;
  final List<BudgetAdjustment> adjustments;

  const BudgetPrediction({
    required this.predictedBudget,
    required this.minBudget,
    required this.maxBudget,
    required this.budgetBreakdown,
    required this.confidence,
    required this.adjustments,
  });
}

class BudgetAdjustment {
  final String type;
  final double multiplier;
  final String reason;

  const BudgetAdjustment(this.type, this.multiplier, this.reason);
}

class BudgetOptimization {
  final double totalBudget;
  final Map<String, double> categoryAllocation;
  final Map<String, double> dailyAllocation;
  final double optimizationScore;
  final List<String> recommendations;

  const BudgetOptimization({
    required this.totalBudget,
    required this.categoryAllocation,
    required this.dailyAllocation,
    required this.optimizationScore,
    required this.recommendations,
  });
}

class BudgetComparison {
  final BudgetProfile userBudget;
  final double peerAverage;
  final double percentile;
  final BudgetComparisonResult comparison;
  final List<String> insights;

  const BudgetComparison({
    required this.userBudget,
    required this.peerAverage,
    required this.percentile,
    required this.comparison,
    required this.insights,
  });
}

enum BudgetComparisonResult { low, average, high }

class BudgetAnomaly {
  final String bookingId;
  final BudgetAnomalyType anomalyType;
  final double amount;
  final double expectedAmount;
  final double deviation;
  final DateTime detectedAt;
  final List<String> possibleReasons;

  const BudgetAnomaly({
    required this.bookingId,
    required this.anomalyType,
    required this.amount,
    required this.expectedAmount,
    required this.deviation,
    required this.detectedAt,
    required this.possibleReasons,
  });
}

enum BudgetAnomalyType { excessiveSpending, unusuallyLow, unusualPattern }