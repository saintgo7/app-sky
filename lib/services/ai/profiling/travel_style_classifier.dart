import 'dart:math';

import '../../../data/models/booking_model.dart';
import '../../../data/models/travel_package_model.dart';
import 'user_preference_analyzer.dart';

enum TravelStyle { luxury, midRange, budget, backpacker, family, business, adventure, cultural, wellness, romantic }

class TravelStyleProfile {
  final TravelStyle primaryStyle;
  final TravelStyle? secondaryStyle;
  final Map<TravelStyle, double> styleScores;
  final double confidence;
  final List<String> styleCharacteristics;
  final DateTime analyzedAt;

  const TravelStyleProfile({
    required this.primaryStyle,
    this.secondaryStyle,
    required this.styleScores,
    required this.confidence,
    required this.styleCharacteristics,
    required this.analyzedAt,
  });

  bool isPrimaryStyle(TravelStyle style) => primaryStyle == style;
  bool hasStyle(TravelStyle style) => primaryStyle == style || secondaryStyle == style;
  
  double getStyleScore(TravelStyle style) => styleScores[style] ?? 0.0;
  
  List<TravelStyle> getTopStyles({int limit = 3}) {
    final sortedEntries = styleScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries.take(limit).map((e) => e.key).toList();
  }
}

class TravelStyleIndicators {
  final double averageSpendingPerDay;
  final double accommodationSpendingRatio;
  final double activitySpendingRatio;
  final Map<String, int> accommodationTypes;
  final Map<String, int> activityTypes;
  final Map<String, int> destinationTypes;
  final double averageTripDuration;
  final Map<String, int> companionTypes;
  final Map<String, int> seasonalPatterns;
  final Map<String, int> bookingLeadTimes;

  const TravelStyleIndicators({
    required this.averageSpendingPerDay,
    required this.accommodationSpendingRatio,
    required this.activitySpendingRatio,
    required this.accommodationTypes,
    required this.activityTypes,
    required this.destinationTypes,
    required this.averageTripDuration,
    required this.companionTypes,
    required this.seasonalPatterns,
    required this.bookingLeadTimes,
  });
}

class TravelStyleClassifier {
  static const Map<TravelStyle, List<String>> _styleKeywords = {
    TravelStyle.luxury: ['luxury', 'premium', 'five-star', 'exclusive', 'vip', 'suite', 'spa'],
    TravelStyle.budget: ['budget', 'economy', 'cheap', 'affordable', 'hostel', 'backpacker'],
    TravelStyle.family: ['family', 'kids', 'children', 'theme park', 'zoo', 'aquarium'],
    TravelStyle.business: ['business', 'conference', 'meeting', 'corporate', 'convention'],
    TravelStyle.adventure: ['adventure', 'hiking', 'trekking', 'climbing', 'extreme', 'outdoor'],
    TravelStyle.cultural: ['cultural', 'museum', 'heritage', 'historical', 'traditional', 'temple'],
    TravelStyle.wellness: ['wellness', 'spa', 'yoga', 'meditation', 'health', 'retreat'],
    TravelStyle.romantic: ['romantic', 'honeymoon', 'couple', 'intimate', 'private', 'sunset'],
  };

  static const Map<TravelStyle, Map<String, dynamic>> _styleThresholds = {
    TravelStyle.luxury: {
      'minSpendingPerDay': 300000.0, // KRW
      'minAccommodationRatio': 0.4,
      'preferredAccommodations': ['luxury', 'resort', 'boutique'],
      'minTripDuration': 4,
    },
    TravelStyle.budget: {
      'maxSpendingPerDay': 150000.0,
      'maxAccommodationRatio': 0.25,
      'preferredAccommodations': ['hostel', 'guesthouse', 'budget'],
      'maxTripDuration': 10,
    },
    TravelStyle.family: {
      'minTravelers': 3,
      'preferredActivities': ['theme park', 'zoo', 'family-friendly'],
      'minTripDuration': 3,
    },
    TravelStyle.business: {
      'preferredAccommodations': ['business', 'city'],
      'maxTripDuration': 5,
      'preferredDestinations': ['business district', 'city center'],
    },
  };

  /// Analyzes user's booking history to classify travel style
  Future<TravelStyleProfile> classifyTravelStyle({
    required List<BookingModel> bookings,
    UserPreferenceProfile? preferenceProfile,
    DateTime? cutoffDate,
  }) async {
    if (bookings.isEmpty) {
      return _createDefaultProfile();
    }

    final effectiveCutoffDate = cutoffDate ?? DateTime.now().subtract(const Duration(days: 365));
    final recentBookings = bookings
        .where((booking) => booking.createdAt.isAfter(effectiveCutoffDate))
        .toList();

    final indicators = await _extractTravelStyleIndicators(recentBookings);
    final styleScores = await _calculateStyleScores(indicators, recentBookings);
    final characteristics = await _identifyStyleCharacteristics(indicators, styleScores);

    final sortedStyles = styleScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final primaryStyle = sortedStyles.first.key;
    final secondaryStyle = sortedStyles.length > 1 && sortedStyles[1].value > 0.3 
        ? sortedStyles[1].key 
        : null;

    final confidence = _calculateConfidence(recentBookings.length, styleScores);

    return TravelStyleProfile(
      primaryStyle: primaryStyle,
      secondaryStyle: secondaryStyle,
      styleScores: styleScores,
      confidence: confidence,
      styleCharacteristics: characteristics,
      analyzedAt: DateTime.now(),
    );
  }

  /// Classifies a single trip based on package and booking details
  Future<TravelStyle> classifyTripStyle({
    required BookingModel booking,
    TravelPackageModel? package,
  }) async {
    final indicators = await _extractTripIndicators(booking, package);
    final styleScores = <TravelStyle, double>{};

    for (final style in TravelStyle.values) {
      styleScores[style] = _calculateSingleTripStyleScore(style, indicators);
    }

    final maxEntry = styleScores.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return maxEntry.key;
  }

  /// Updates travel style based on new booking
  Future<TravelStyleProfile> updateStyleWithNewBooking({
    required TravelStyleProfile currentProfile,
    required BookingModel newBooking,
    TravelPackageModel? package,
    double learningRate = 0.1,
  }) async {
    final tripStyle = await classifyTripStyle(booking: newBooking, package: package);
    final updatedScores = Map<TravelStyle, double>.from(currentProfile.styleScores);

    // Update scores with exponential moving average
    for (final style in TravelStyle.values) {
      final currentScore = updatedScores[style] ?? 0.0;
      final newScore = style == tripStyle ? 1.0 : 0.0;
      updatedScores[style] = (1 - learningRate) * currentScore + learningRate * newScore;
    }

    // Recalculate primary and secondary styles
    final sortedStyles = updatedScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return currentProfile.copyWith(
      primaryStyle: sortedStyles.first.key,
      secondaryStyle: sortedStyles.length > 1 && sortedStyles[1].value > 0.3 
          ? sortedStyles[1].key 
          : null,
      styleScores: updatedScores,
      analyzedAt: DateTime.now(),
    );
  }

  /// Predicts travel style evolution based on trends
  Future<Map<TravelStyle, double>> predictStyleEvolution({
    required List<TravelStyleProfile> historicalProfiles,
    Duration forecastPeriod = const Duration(days: 180),
  }) async {
    if (historicalProfiles.length < 2) {
      return historicalProfiles.isNotEmpty 
          ? historicalProfiles.last.styleScores 
          : <TravelStyle, double>{};
    }

    final predictions = <TravelStyle, double>{};

    for (final style in TravelStyle.values) {
      final values = historicalProfiles
          .map((profile) => profile.getStyleScore(style))
          .toList();
      
      final timestamps = historicalProfiles
          .map((profile) => profile.analyzedAt)
          .toList();

      if (values.length >= 2) {
        final trend = _calculateTrend(values, timestamps);
        final currentValue = values.last;
        final predictedValue = currentValue + (trend * forecastPeriod.inDays);
        predictions[style] = max(0.0, min(1.0, predictedValue));
      }
    }

    return _normalizeScores(predictions);
  }

  // Private methods

  Future<TravelStyleIndicators> _extractTravelStyleIndicators(
    List<BookingModel> bookings,
  ) async {
    if (bookings.isEmpty) {
      return _createEmptyIndicators();
    }

    double totalSpending = 0.0;
    int totalDays = 0;
    double totalAccommodationSpending = 0.0;
    double totalActivitySpending = 0.0;

    final accommodationTypes = <String, int>{};
    final activityTypes = <String, int>{};
    final destinationTypes = <String, int>{};
    final companionTypes = <String, int>{};
    final seasonalPatterns = <String, int>{};
    final bookingLeadTimes = <String, int>{};

    for (final booking in bookings) {
      // Calculate spending metrics
      totalSpending += booking.pricing.totalPrice;
      final duration = booking.travelEndDate.difference(booking.travelStartDate).inDays;
      totalDays += duration;

      // Analyze accommodation spending
      if (booking.hotelBookings?.isNotEmpty == true) {
        final accommodationCost = _estimateAccommodationCost(booking);
        totalAccommodationSpending += accommodationCost;
        
        final hotelType = _categorizeAccommodationType(booking.hotelBookings!.first.hotelName);
        accommodationTypes[hotelType] = (accommodationTypes[hotelType] ?? 0) + 1;
      }

      // Analyze activity spending
      if (booking.additionalServices?.isNotEmpty == true) {
        final activityCost = booking.additionalServices!
            .fold<double>(0.0, (sum, service) => sum + service.price);
        totalActivitySpending += activityCost;

        for (final service in booking.additionalServices!) {
          final activityType = _categorizeActivityType(service.name);
          activityTypes[activityType] = (activityTypes[activityType] ?? 0) + 1;
        }
      }

      // Analyze destination type
      final destinationType = _categorizeDestinationType(booking.packageTitle);
      destinationTypes[destinationType] = (destinationTypes[destinationType] ?? 0) + 1;

      // Analyze companion type
      final companionType = _categorizeCompanionType(booking.numberOfTravelers, booking.bookingType);
      companionTypes[companionType] = (companionTypes[companionType] ?? 0) + 1;

      // Analyze seasonal pattern
      final season = _getSeason(booking.travelStartDate);
      seasonalPatterns[season] = (seasonalPatterns[season] ?? 0) + 1;

      // Analyze booking lead time
      final leadTime = booking.travelStartDate.difference(booking.createdAt).inDays;
      final leadTimeCategory = _categorizeLeadTime(leadTime);
      bookingLeadTimes[leadTimeCategory] = (bookingLeadTimes[leadTimeCategory] ?? 0) + 1;
    }

    return TravelStyleIndicators(
      averageSpendingPerDay: totalDays > 0 ? totalSpending / totalDays : 0.0,
      accommodationSpendingRatio: totalSpending > 0 ? totalAccommodationSpending / totalSpending : 0.0,
      activitySpendingRatio: totalSpending > 0 ? totalActivitySpending / totalSpending : 0.0,
      accommodationTypes: accommodationTypes,
      activityTypes: activityTypes,
      destinationTypes: destinationTypes,
      averageTripDuration: bookings.isNotEmpty 
          ? totalDays / bookings.length 
          : 0.0,
      companionTypes: companionTypes,
      seasonalPatterns: seasonalPatterns,
      bookingLeadTimes: bookingLeadTimes,
    );
  }

  Future<Map<TravelStyle, double>> _calculateStyleScores(
    TravelStyleIndicators indicators,
    List<BookingModel> bookings,
  ) async {
    final scores = <TravelStyle, double>{};

    for (final style in TravelStyle.values) {
      scores[style] = _calculateIndividualStyleScore(style, indicators, bookings);
    }

    return _normalizeScores(scores);
  }

  double _calculateIndividualStyleScore(
    TravelStyle style,
    TravelStyleIndicators indicators,
    List<BookingModel> bookings,
  ) {
    double score = 0.0;

    switch (style) {
      case TravelStyle.luxury:
        score += _scoreLuxuryStyle(indicators);
        break;
      case TravelStyle.budget:
        score += _scoreBudgetStyle(indicators);
        break;
      case TravelStyle.family:
        score += _scoreFamilyStyle(indicators);
        break;
      case TravelStyle.business:
        score += _scoreBusinessStyle(indicators);
        break;
      case TravelStyle.adventure:
        score += _scoreAdventureStyle(indicators);
        break;
      case TravelStyle.cultural:
        score += _scoreCulturalStyle(indicators);
        break;
      case TravelStyle.wellness:
        score += _scoreWellnessStyle(indicators);
        break;
      case TravelStyle.romantic:
        score += _scoreRomanticStyle(indicators);
        break;
      case TravelStyle.midRange:
        score += _scoreMidRangeStyle(indicators);
        break;
      case TravelStyle.backpacker:
        score += _scoreBackpackerStyle(indicators);
        break;
    }

    // Add keyword-based scoring from booking descriptions
    for (final booking in bookings) {
      final keywordScore = _calculateKeywordScore(style, booking.packageTitle + ' ' + (booking.specialRequests ?? ''));
      score += keywordScore * 0.1; // Weight keyword matches lower
    }

    return max(0.0, min(1.0, score));
  }

  double _scoreLuxuryStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // High spending per day
    if (indicators.averageSpendingPerDay > 300000) score += 0.3;
    else if (indicators.averageSpendingPerDay > 200000) score += 0.2;

    // High accommodation spending ratio
    if (indicators.accommodationSpendingRatio > 0.4) score += 0.2;

    // Luxury accommodation preferences
    final luxuryAccommodations = ['luxury', 'resort', 'boutique', 'five-star'];
    for (final type in luxuryAccommodations) {
      if (indicators.accommodationTypes[type] != null) {
        score += 0.1 * (indicators.accommodationTypes[type]! / indicators.accommodationTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    // Premium activities
    final premiumActivities = ['spa', 'fine-dining', 'private-tour', 'vip'];
    for (final type in premiumActivities) {
      if (indicators.activityTypes[type] != null) {
        score += 0.1 * (indicators.activityTypes[type]! / indicators.activityTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    return score;
  }

  double _scoreBudgetStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Low spending per day
    if (indicators.averageSpendingPerDay < 100000) score += 0.3;
    else if (indicators.averageSpendingPerDay < 150000) score += 0.2;

    // Low accommodation spending ratio
    if (indicators.accommodationSpendingRatio < 0.25) score += 0.2;

    // Budget accommodation preferences
    final budgetAccommodations = ['hostel', 'guesthouse', 'budget', 'motel'];
    for (final type in budgetAccommodations) {
      if (indicators.accommodationTypes[type] != null) {
        score += 0.1 * (indicators.accommodationTypes[type]! / indicators.accommodationTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    return score;
  }

  double _scoreFamilyStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Multiple travelers (family size)
    if (indicators.companionTypes['family'] != null) {
      score += 0.4 * (indicators.companionTypes['family']! / indicators.companionTypes.values.fold(0, (sum, count) => sum + count));
    }

    // Family-friendly activities
    final familyActivities = ['theme-park', 'zoo', 'aquarium', 'family-friendly'];
    for (final type in familyActivities) {
      if (indicators.activityTypes[type] != null) {
        score += 0.15 * (indicators.activityTypes[type]! / indicators.activityTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    return score;
  }

  double _scoreBusinessStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Short trip duration
    if (indicators.averageTripDuration <= 5) score += 0.2;

    // Business accommodations
    final businessAccommodations = ['business', 'city', 'conference'];
    for (final type in businessAccommodations) {
      if (indicators.accommodationTypes[type] != null) {
        score += 0.2 * (indicators.accommodationTypes[type]! / indicators.accommodationTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    // Short booking lead time
    if (indicators.bookingLeadTimes['last-minute'] != null) {
      score += 0.1 * (indicators.bookingLeadTimes['last-minute']! / indicators.bookingLeadTimes.values.fold(0, (sum, count) => sum + count));
    }

    return score;
  }

  double _scoreAdventureStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Adventure activities
    final adventureActivities = ['hiking', 'climbing', 'extreme', 'outdoor', 'adventure'];
    for (final type in adventureActivities) {
      if (indicators.activityTypes[type] != null) {
        score += 0.2 * (indicators.activityTypes[type]! / indicators.activityTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    // Adventure destinations
    if (indicators.destinationTypes['mountain'] != null || indicators.destinationTypes['nature'] != null) {
      final total = indicators.destinationTypes.values.fold(0, (sum, count) => sum + count);
      score += 0.2 * ((indicators.destinationTypes['mountain'] ?? 0) + (indicators.destinationTypes['nature'] ?? 0)) / total;
    }

    return score;
  }

  double _scoreCulturalStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Cultural activities
    final culturalActivities = ['museum', 'heritage', 'historical', 'traditional', 'cultural'];
    for (final type in culturalActivities) {
      if (indicators.activityTypes[type] != null) {
        score += 0.2 * (indicators.activityTypes[type]! / indicators.activityTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    return score;
  }

  double _scoreWellnessStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Wellness activities
    final wellnessActivities = ['spa', 'yoga', 'meditation', 'wellness', 'retreat'];
    for (final type in wellnessActivities) {
      if (indicators.activityTypes[type] != null) {
        score += 0.2 * (indicators.activityTypes[type]! / indicators.activityTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    return score;
  }

  double _scoreRomanticStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Couple travelers
    if (indicators.companionTypes['couple'] != null) {
      score += 0.4 * (indicators.companionTypes['couple']! / indicators.companionTypes.values.fold(0, (sum, count) => sum + count));
    }

    // Romantic activities
    final romanticActivities = ['romantic', 'sunset', 'private', 'intimate'];
    for (final type in romanticActivities) {
      if (indicators.activityTypes[type] != null) {
        score += 0.15 * (indicators.activityTypes[type]! / indicators.activityTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    return score;
  }

  double _scoreMidRangeStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Mid-range spending
    if (indicators.averageSpendingPerDay >= 150000 && indicators.averageSpendingPerDay <= 300000) {
      score += 0.3;
    }

    // Balanced accommodation spending
    if (indicators.accommodationSpendingRatio >= 0.25 && indicators.accommodationSpendingRatio <= 0.4) {
      score += 0.2;
    }

    return score;
  }

  double _scoreBackpackerStyle(TravelStyleIndicators indicators) {
    double score = 0.0;

    // Very low spending
    if (indicators.averageSpendingPerDay < 80000) score += 0.3;

    // Long trip duration
    if (indicators.averageTripDuration > 14) score += 0.2;

    // Backpacker accommodations
    final backpackerAccommodations = ['hostel', 'dorm', 'backpacker'];
    for (final type in backpackerAccommodations) {
      if (indicators.accommodationTypes[type] != null) {
        score += 0.2 * (indicators.accommodationTypes[type]! / indicators.accommodationTypes.values.fold(0, (sum, count) => sum + count));
      }
    }

    return score;
  }

  double _calculateKeywordScore(TravelStyle style, String text) {
    final keywords = _styleKeywords[style] ?? [];
    final lowerText = text.toLowerCase();
    
    int matches = 0;
    for (final keyword in keywords) {
      if (lowerText.contains(keyword)) {
        matches++;
      }
    }

    return keywords.isEmpty ? 0.0 : matches / keywords.length;
  }

  Future<List<String>> _identifyStyleCharacteristics(
    TravelStyleIndicators indicators,
    Map<TravelStyle, double> styleScores,
  ) async {
    final characteristics = <String>[];

    // Add spending characteristics
    if (indicators.averageSpendingPerDay > 300000) {
      characteristics.add('High-budget traveler');
    } else if (indicators.averageSpendingPerDay < 100000) {
      characteristics.add('Budget-conscious traveler');
    }

    // Add duration characteristics
    if (indicators.averageTripDuration > 14) {
      characteristics.add('Long-term traveler');
    } else if (indicators.averageTripDuration < 4) {
      characteristics.add('Short-trip traveler');
    }

    // Add top accommodation preference
    final topAccommodation = indicators.accommodationTypes.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    characteristics.add('Prefers ${topAccommodation.key} accommodations');

    // Add seasonal preference
    final topSeason = indicators.seasonalPatterns.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    characteristics.add('Prefers ${topSeason.key} travel');

    return characteristics;
  }

  double _calculateConfidence(int dataPoints, Map<TravelStyle, double> styleScores) {
    if (dataPoints < 2) return 0.3;
    if (dataPoints < 5) return 0.5;

    // Calculate confidence based on data points and score distribution
    final maxScore = styleScores.values.reduce(max);
    final scoreVariance = _calculateVariance(styleScores.values.toList());
    
    final dataConfidence = min(dataPoints / 10.0, 1.0);
    final scoreConfidence = maxScore * (1.0 - scoreVariance);
    
    return (dataConfidence * 0.6) + (scoreConfidence * 0.4);
  }

  Map<TravelStyle, double> _normalizeScores(Map<TravelStyle, double> scores) {
    final maxScore = scores.values.fold(0.0, (max, score) => math.max(max, score));
    if (maxScore == 0) return scores;

    return scores.map((style, score) => MapEntry(style, score / maxScore));
  }

  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;
    
    final mean = values.fold(0.0, (sum, value) => sum + value) / values.length;
    final squaredDiffs = values.map((value) => pow(value - mean, 2)).toList();
    return squaredDiffs.fold(0.0, (sum, diff) => sum + diff) / values.length;
  }

  // Helper methods for categorization

  double _estimateAccommodationCost(BookingModel booking) {
    // Estimate based on total price and typical accommodation ratios
    return booking.pricing.totalPrice * 0.4; // Rough estimate
  }

  String _categorizeAccommodationType(String hotelName) {
    final name = hotelName.toLowerCase();
    if (name.contains('resort')) return 'resort';
    if (name.contains('luxury') || name.contains('grand')) return 'luxury';
    if (name.contains('boutique')) return 'boutique';
    if (name.contains('business')) return 'business';
    if (name.contains('budget') || name.contains('inn')) return 'budget';
    if (name.contains('hostel')) return 'hostel';
    return 'standard';
  }

  String _categorizeActivityType(String activityName) {
    final name = activityName.toLowerCase();
    if (name.contains('spa') || name.contains('wellness')) return 'wellness';
    if (name.contains('adventure') || name.contains('extreme')) return 'adventure';
    if (name.contains('cultural') || name.contains('museum')) return 'cultural';
    if (name.contains('food') || name.contains('dining')) return 'culinary';
    if (name.contains('family') || name.contains('kids')) return 'family-friendly';
    return 'general';
  }

  String _categorizeDestinationType(String packageTitle) {
    final title = packageTitle.toLowerCase();
    if (title.contains('beach') || title.contains('island')) return 'beach';
    if (title.contains('mountain') || title.contains('hiking')) return 'mountain';
    if (title.contains('city') || title.contains('urban')) return 'city';
    if (title.contains('nature') || title.contains('park')) return 'nature';
    if (title.contains('cultural') || title.contains('heritage')) return 'cultural';
    return 'general';
  }

  String _categorizeCompanionType(int travelers, BookingType bookingType) {
    if (bookingType == BookingType.group) return 'group';
    if (travelers == 1) return 'solo';
    if (travelers == 2) return 'couple';
    if (travelers <= 4) return 'family';
    return 'large-group';
  }

  String _getSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  String _categorizeLeadTime(int days) {
    if (days <= 7) return 'last-minute';
    if (days <= 30) return 'short-term';
    if (days <= 90) return 'medium-term';
    return 'long-term';
  }

  TravelStyleIndicators _createEmptyIndicators() {
    return const TravelStyleIndicators(
      averageSpendingPerDay: 0.0,
      accommodationSpendingRatio: 0.0,
      activitySpendingRatio: 0.0,
      accommodationTypes: <String, int>{},
      activityTypes: <String, int>{},
      destinationTypes: <String, int>{},
      averageTripDuration: 0.0,
      companionTypes: <String, int>{},
      seasonalPatterns: <String, int>{},
      bookingLeadTimes: <String, int>{},
    );
  }

  TravelStyleProfile _createDefaultProfile() {
    return TravelStyleProfile(
      primaryStyle: TravelStyle.midRange,
      secondaryStyle: null,
      styleScores: {for (final style in TravelStyle.values) style: 0.1},
      confidence: 0.0,
      styleCharacteristics: ['New user'],
      analyzedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> _extractTripIndicators(
    BookingModel booking,
    TravelPackageModel? package,
  ) {
    final indicators = <String, dynamic>{};
    
    indicators['spendingPerDay'] = booking.pricing.totalPrice / 
        booking.travelEndDate.difference(booking.travelStartDate).inDays;
    indicators['travelers'] = booking.numberOfTravelers;
    indicators['duration'] = booking.travelEndDate.difference(booking.travelStartDate).inDays;
    indicators['bookingType'] = booking.bookingType;
    indicators['season'] = _getSeason(booking.travelStartDate);
    
    if (booking.additionalServices?.isNotEmpty == true) {
      indicators['activities'] = booking.additionalServices!
          .map((service) => _categorizeActivityType(service.name))
          .toList();
    }
    
    if (booking.hotelBookings?.isNotEmpty == true) {
      indicators['accommodationType'] = _categorizeAccommodationType(
          booking.hotelBookings!.first.hotelName);
    }
    
    return indicators;
  }

  double _calculateSingleTripStyleScore(TravelStyle style, Map<String, dynamic> indicators) {
    double score = 0.0;

    switch (style) {
      case TravelStyle.luxury:
        if (indicators['spendingPerDay'] > 300000) score += 0.5;
        if (indicators['accommodationType'] == 'luxury') score += 0.3;
        break;
      case TravelStyle.budget:
        if (indicators['spendingPerDay'] < 150000) score += 0.5;
        if (indicators['accommodationType'] == 'budget') score += 0.3;
        break;
      case TravelStyle.family:
        if (indicators['travelers'] >= 3) score += 0.4;
        final activities = indicators['activities'] as List<String>? ?? [];
        if (activities.contains('family-friendly')) score += 0.3;
        break;
      case TravelStyle.business:
        if (indicators['duration'] <= 5) score += 0.3;
        if (indicators['accommodationType'] == 'business') score += 0.4;
        break;
      default:
        // Add scoring for other styles...
        break;
    }

    return max(0.0, min(1.0, score));
  }

  double _calculateTrend(List<double> values, List<DateTime> timestamps) {
    if (values.length < 2) return 0.0;

    // Simple linear trend calculation
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    final n = values.length;

    for (int i = 0; i < n; i++) {
      final x = i.toDouble();
      final y = values[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }

    final denominator = n * sumX2 - sumX * sumX;
    return denominator != 0 ? (n * sumXY - sumX * sumY) / denominator : 0.0;
  }
}

extension TravelStyleProfileExtension on TravelStyleProfile {
  TravelStyleProfile copyWith({
    TravelStyle? primaryStyle,
    TravelStyle? secondaryStyle,
    Map<TravelStyle, double>? styleScores,
    double? confidence,
    List<String>? styleCharacteristics,
    DateTime? analyzedAt,
  }) {
    return TravelStyleProfile(
      primaryStyle: primaryStyle ?? this.primaryStyle,
      secondaryStyle: secondaryStyle ?? this.secondaryStyle,
      styleScores: styleScores ?? this.styleScores,
      confidence: confidence ?? this.confidence,
      styleCharacteristics: styleCharacteristics ?? this.styleCharacteristics,
      analyzedAt: analyzedAt ?? this.analyzedAt,
    );
  }
}