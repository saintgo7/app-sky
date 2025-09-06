import 'dart:math';

import '../../../data/models/user_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/travel_package_model.dart';
import '../../../data/models/ai_recommendation_model.dart';

enum PreferenceStrength { weak, moderate, strong, veryStrong }

class UserPreferenceProfile {
  final Map<String, double> destinationPreferences;
  final Map<String, double> activityPreferences;
  final Map<String, double> accommodationPreferences;
  final Map<String, double> seasonalPreferences;
  final Map<String, double> budgetPreferences;
  final Map<String, double> durationPreferences;
  final Map<String, double> companionPreferences;
  final DateTime lastUpdated;
  final double confidenceScore;

  const UserPreferenceProfile({
    required this.destinationPreferences,
    required this.activityPreferences,
    required this.accommodationPreferences,
    required this.seasonalPreferences,
    required this.budgetPreferences,
    required this.durationPreferences,
    required this.companionPreferences,
    required this.lastUpdated,
    required this.confidenceScore,
  });

  UserPreferenceProfile copyWith({
    Map<String, double>? destinationPreferences,
    Map<String, double>? activityPreferences,
    Map<String, double>? accommodationPreferences,
    Map<String, double>? seasonalPreferences,
    Map<String, double>? budgetPreferences,
    Map<String, double>? durationPreferences,
    Map<String, double>? companionPreferences,
    DateTime? lastUpdated,
    double? confidenceScore,
  }) {
    return UserPreferenceProfile(
      destinationPreferences: destinationPreferences ?? this.destinationPreferences,
      activityPreferences: activityPreferences ?? this.activityPreferences,
      accommodationPreferences: accommodationPreferences ?? this.accommodationPreferences,
      seasonalPreferences: seasonalPreferences ?? this.seasonalPreferences,
      budgetPreferences: budgetPreferences ?? this.budgetPreferences,
      durationPreferences: durationPreferences ?? this.durationPreferences,
      companionPreferences: companionPreferences ?? this.companionPreferences,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }
}

class SearchPattern {
  final String query;
  final List<String> destinations;
  final List<String> activities;
  final String? budgetRange;
  final DateTime timestamp;
  final bool resultedInBooking;

  const SearchPattern({
    required this.query,
    required this.destinations,
    required this.activities,
    this.budgetRange,
    required this.timestamp,
    required this.resultedInBooking,
  });
}

class UserPreferenceAnalyzer {
  static const double _minConfidenceThreshold = 0.3;
  static const double _maxConfidenceScore = 1.0;
  static const int _minDataPointsForConfidence = 5;

  /// Analyzes user booking history to extract preferences
  Future<UserPreferenceProfile> analyzeBookingHistory(
    List<BookingModel> bookings, {
    DateTime? cutoffDate,
  }) async {
    final effectiveCutoffDate = cutoffDate ?? DateTime.now().subtract(const Duration(days: 365 * 2));
    final recentBookings = bookings
        .where((booking) => booking.createdAt.isAfter(effectiveCutoffDate))
        .toList();

    if (recentBookings.isEmpty) {
      return _createEmptyProfile();
    }

    final destinationPrefs = _analyzeDestinationPreferences(recentBookings);
    final activityPrefs = _analyzeActivityPreferences(recentBookings);
    final accommodationPrefs = _analyzeAccommodationPreferences(recentBookings);
    final seasonalPrefs = _analyzeSeasonalPreferences(recentBookings);
    final budgetPrefs = _analyzeBudgetPreferences(recentBookings);
    final durationPrefs = _analyzeDurationPreferences(recentBookings);
    final companionPrefs = _analyzeCompanionPreferences(recentBookings);

    final confidenceScore = _calculateConfidenceScore(recentBookings.length);

    return UserPreferenceProfile(
      destinationPreferences: destinationPrefs,
      activityPreferences: activityPrefs,
      accommodationPreferences: accommodationPrefs,
      seasonalPreferences: seasonalPrefs,
      budgetPreferences: budgetPrefs,
      durationPreferences: durationPrefs,
      companionPreferences: companionPrefs,
      lastUpdated: DateTime.now(),
      confidenceScore: confidenceScore,
    );
  }

  /// Analyzes search patterns to understand user interests
  Future<Map<String, double>> analyzeSearchPatterns(
    List<SearchPattern> searchPatterns, {
    Duration lookbackPeriod = const Duration(days: 90),
  }) async {
    final cutoffDate = DateTime.now().subtract(lookbackPeriod);
    final recentSearches = searchPatterns
        .where((pattern) => pattern.timestamp.isAfter(cutoffDate))
        .toList();

    final preferences = <String, double>{};
    final searchCounts = <String, int>{};
    final conversionCounts = <String, int>{};

    for (final pattern in recentSearches) {
      // Count destination searches
      for (final destination in pattern.destinations) {
        searchCounts[destination] = (searchCounts[destination] ?? 0) + 1;
        if (pattern.resultedInBooking) {
          conversionCounts[destination] = (conversionCounts[destination] ?? 0) + 1;
        }
      }

      // Count activity searches
      for (final activity in pattern.activities) {
        searchCounts[activity] = (searchCounts[activity] ?? 0) + 1;
        if (pattern.resultedInBooking) {
          conversionCounts[activity] = (conversionCounts[activity] ?? 0) + 1;
        }
      }
    }

    // Calculate preference scores based on search frequency and conversion rate
    for (final entry in searchCounts.entries) {
      final searchCount = entry.value;
      final conversionCount = conversionCounts[entry.key] ?? 0;
      final conversionRate = conversionCount / searchCount;
      
      // Weight by both frequency and conversion rate
      final frequencyScore = min(searchCount / 10.0, 1.0);
      final conversionScore = conversionRate;
      preferences[entry.key] = (frequencyScore * 0.7) + (conversionScore * 0.3);
    }

    return _normalizePreferences(preferences);
  }

  /// Combines multiple preference sources with weights
  Future<UserPreferenceProfile> combinePreferences(
    UserPreferenceProfile bookingPrefs,
    Map<String, double> searchPrefs,
    UserPreferences? userSettings, {
    double bookingWeight = 0.6,
    double searchWeight = 0.3,
    double settingsWeight = 0.1,
  }) async {
    final combinedDestinationPrefs = _combinePreferenceMaps([
      (bookingPrefs.destinationPreferences, bookingWeight),
      (searchPrefs, searchWeight),
      if (userSettings?.favoriteDestinations != null)
        (_convertListToPreferenceMap(userSettings!.favoriteDestinations!), settingsWeight),
    ]);

    final combinedActivityPrefs = _combinePreferenceMaps([
      (bookingPrefs.activityPreferences, bookingWeight),
      if (userSettings?.travelPreferences?.activities != null)
        (_convertListToPreferenceMap(userSettings!.travelPreferences!.activities!), settingsWeight),
    ]);

    return bookingPrefs.copyWith(
      destinationPreferences: combinedDestinationPrefs,
      activityPreferences: combinedActivityPrefs,
      lastUpdated: DateTime.now(),
    );
  }

  /// Detects preference changes over time
  Future<PreferenceChanges> detectPreferenceChanges(
    UserPreferenceProfile oldProfile,
    UserPreferenceProfile newProfile, {
    double significanceThreshold = 0.2,
  }) async {
    final changes = <PreferenceChange>[];

    // Check destination preference changes
    final destChanges = _detectChangesInMap(
      oldProfile.destinationPreferences,
      newProfile.destinationPreferences,
      'destination',
      significanceThreshold,
    );
    changes.addAll(destChanges);

    // Check activity preference changes
    final activityChanges = _detectChangesInMap(
      oldProfile.activityPreferences,
      newProfile.activityPreferences,
      'activity',
      significanceThreshold,
    );
    changes.addAll(activityChanges);

    // Check seasonal preference changes
    final seasonalChanges = _detectChangesInMap(
      oldProfile.seasonalPreferences,
      newProfile.seasonalPreferences,
      'season',
      significanceThreshold,
    );
    changes.addAll(seasonalChanges);

    return PreferenceChanges(
      changes: changes,
      overallChangeScore: _calculateOverallChangeScore(changes),
      detectedAt: DateTime.now(),
    );
  }

  /// Predicts future travel preferences based on trends
  Future<Map<String, double>> predictFuturePreferences(
    List<UserPreferenceProfile> historicalProfiles, {
    Duration forecastPeriod = const Duration(days: 90),
  }) async {
    if (historicalProfiles.length < 2) {
      return historicalProfiles.isNotEmpty 
          ? historicalProfiles.last.destinationPreferences 
          : <String, double>{};
    }

    final predictions = <String, double>{};
    final allKeys = <String>{};

    // Collect all preference keys
    for (final profile in historicalProfiles) {
      allKeys.addAll(profile.destinationPreferences.keys);
      allKeys.addAll(profile.activityPreferences.keys);
    }

    // Calculate trends for each preference
    for (final key in allKeys) {
      final values = <double>[];
      final timestamps = <DateTime>[];

      for (final profile in historicalProfiles) {
        final value = profile.destinationPreferences[key] ?? 
                     profile.activityPreferences[key] ?? 0.0;
        values.add(value);
        timestamps.add(profile.lastUpdated);
      }

      if (values.length >= 2) {
        final trend = _calculateLinearTrend(values, timestamps);
        final currentValue = values.last;
        final predictedValue = currentValue + (trend * forecastPeriod.inDays);
        predictions[key] = max(0.0, min(1.0, predictedValue));
      }
    }

    return _normalizePreferences(predictions);
  }

  // Private helper methods

  Map<String, double> _analyzeDestinationPreferences(List<BookingModel> bookings) {
    final destinationCounts = <String, int>{};
    final destinationSpending = <String, double>{};

    for (final booking in bookings) {
      // Extract destination from package title or other fields
      final destination = _extractDestinationFromBooking(booking);
      if (destination.isNotEmpty) {
        destinationCounts[destination] = (destinationCounts[destination] ?? 0) + 1;
        destinationSpending[destination] = 
            (destinationSpending[destination] ?? 0.0) + booking.pricing.totalPrice;
      }
    }

    return _calculatePreferenceScores(destinationCounts, destinationSpending);
  }

  Map<String, double> _analyzeActivityPreferences(List<BookingModel> bookings) {
    final activityCounts = <String, int>{};
    final activitySpending = <String, double>{};

    for (final booking in bookings) {
      final activities = _extractActivitiesFromBooking(booking);
      for (final activity in activities) {
        activityCounts[activity] = (activityCounts[activity] ?? 0) + 1;
        activitySpending[activity] = 
            (activitySpending[activity] ?? 0.0) + (booking.pricing.totalPrice / activities.length);
      }
    }

    return _calculatePreferenceScores(activityCounts, activitySpending);
  }

  Map<String, double> _analyzeAccommodationPreferences(List<BookingModel> bookings) {
    final accommodationCounts = <String, int>{};

    for (final booking in bookings) {
      if (booking.hotelBookings?.isNotEmpty == true) {
        final hotelType = _categorizeHotelType(booking.hotelBookings!.first.hotelName);
        accommodationCounts[hotelType] = (accommodationCounts[hotelType] ?? 0) + 1;
      }
    }

    return _normalizeToPreferences(accommodationCounts);
  }

  Map<String, double> _analyzeSeasonalPreferences(List<BookingModel> bookings) {
    final seasonCounts = <String, int>{};

    for (final booking in bookings) {
      final season = _determineSeason(booking.travelStartDate);
      seasonCounts[season] = (seasonCounts[season] ?? 0) + 1;
    }

    return _normalizeToPreferences(seasonCounts);
  }

  Map<String, double> _analyzeBudgetPreferences(List<BookingModel> bookings) {
    final budgetRangeCounts = <String, int>{};

    for (final booking in bookings) {
      final budgetRange = _categorizeBudgetRange(booking.pricing.totalPrice);
      budgetRangeCounts[budgetRange] = (budgetRangeCounts[budgetRange] ?? 0) + 1;
    }

    return _normalizeToPreferences(budgetRangeCounts);
  }

  Map<String, double> _analyzeDurationPreferences(List<BookingModel> bookings) {
    final durationCounts = <String, int>{};

    for (final booking in bookings) {
      final duration = booking.travelEndDate.difference(booking.travelStartDate).inDays;
      final durationCategory = _categorizeDuration(duration);
      durationCounts[durationCategory] = (durationCounts[durationCategory] ?? 0) + 1;
    }

    return _normalizeToPreferences(durationCounts);
  }

  Map<String, double> _analyzeCompanionPreferences(List<BookingModel> bookings) {
    final companionCounts = <String, int>{};

    for (final booking in bookings) {
      final companionType = _determineCompanionType(booking.numberOfTravelers, booking.bookingType);
      companionCounts[companionType] = (companionCounts[companionType] ?? 0) + 1;
    }

    return _normalizeToPreferences(companionCounts);
  }

  String _extractDestinationFromBooking(BookingModel booking) {
    // Extract destination from package title or use a more sophisticated method
    // This is a simplified implementation
    final title = booking.packageTitle.toLowerCase();
    final destinations = ['japan', 'korea', 'thailand', 'vietnam', 'singapore', 'malaysia'];
    
    for (final dest in destinations) {
      if (title.contains(dest)) {
        return dest;
      }
    }
    return 'other';
  }

  List<String> _extractActivitiesFromBooking(BookingModel booking) {
    // Extract activities from additional services or package details
    final activities = <String>[];
    
    if (booking.additionalServices != null) {
      for (final service in booking.additionalServices!) {
        final category = _categorizeService(service.name);
        if (category.isNotEmpty) {
          activities.add(category);
        }
      }
    }
    
    return activities.isEmpty ? ['general'] : activities;
  }

  String _categorizeService(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('tour') || name.contains('guide')) return 'sightseeing';
    if (name.contains('food') || name.contains('restaurant')) return 'culinary';
    if (name.contains('spa') || name.contains('wellness')) return 'wellness';
    if (name.contains('adventure') || name.contains('hiking')) return 'adventure';
    if (name.contains('culture') || name.contains('museum')) return 'culture';
    return 'general';
  }

  String _categorizeHotelType(String hotelName) {
    final name = hotelName.toLowerCase();
    if (name.contains('resort')) return 'resort';
    if (name.contains('boutique')) return 'boutique';
    if (name.contains('business') || name.contains('city')) return 'business';
    if (name.contains('luxury') || name.contains('grand')) return 'luxury';
    if (name.contains('budget') || name.contains('inn')) return 'budget';
    return 'standard';
  }

  String _determineSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  String _categorizeBudgetRange(double amount) {
    if (amount < 500000) return 'budget';
    if (amount < 1500000) return 'mid-range';
    if (amount < 3000000) return 'premium';
    return 'luxury';
  }

  String _categorizeDuration(int days) {
    if (days <= 3) return 'short';
    if (days <= 7) return 'week';
    if (days <= 14) return 'extended';
    return 'long';
  }

  String _determineCompanionType(int travelers, BookingType bookingType) {
    if (bookingType == BookingType.group) return 'group';
    if (travelers == 1) return 'solo';
    if (travelers == 2) return 'couple';
    if (travelers <= 4) return 'family';
    return 'large-group';
  }

  Map<String, double> _calculatePreferenceScores(
    Map<String, int> counts,
    Map<String, double> spending,
  ) {
    final preferences = <String, double>{};
    final totalCount = counts.values.fold(0, (sum, count) => sum + count);
    final totalSpending = spending.values.fold(0.0, (sum, amount) => sum + amount);

    for (final entry in counts.entries) {
      final frequencyScore = entry.value / totalCount;
      final spendingScore = totalSpending > 0 
          ? (spending[entry.key] ?? 0.0) / totalSpending 
          : 0.0;
      
      // Combine frequency and spending with weights
      preferences[entry.key] = (frequencyScore * 0.6) + (spendingScore * 0.4);
    }

    return _normalizePreferences(preferences);
  }

  Map<String, double> _normalizeToPreferences(Map<String, int> counts) {
    final total = counts.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return <String, double>{};

    return counts.map((key, count) => MapEntry(key, count / total));
  }

  Map<String, double> _normalizePreferences(Map<String, double> preferences) {
    final maxValue = preferences.values.fold(0.0, (max, value) => math.max(max, value));
    if (maxValue == 0) return preferences;

    return preferences.map((key, value) => MapEntry(key, value / maxValue));
  }

  double _calculateConfidenceScore(int dataPoints) {
    if (dataPoints < _minDataPointsForConfidence) {
      return _minConfidenceThreshold;
    }
    
    final normalizedPoints = min(dataPoints / 20.0, 1.0);
    return _minConfidenceThreshold + 
           (normalizedPoints * (_maxConfidenceScore - _minConfidenceThreshold));
  }

  UserPreferenceProfile _createEmptyProfile() {
    return UserPreferenceProfile(
      destinationPreferences: <String, double>{},
      activityPreferences: <String, double>{},
      accommodationPreferences: <String, double>{},
      seasonalPreferences: <String, double>{},
      budgetPreferences: <String, double>{},
      durationPreferences: <String, double>{},
      companionPreferences: <String, double>{},
      lastUpdated: DateTime.now(),
      confidenceScore: 0.0,
    );
  }

  Map<String, double> _convertListToPreferenceMap(List<String> items) {
    if (items.isEmpty) return <String, double>{};
    
    final weight = 1.0 / items.length;
    return {for (final item in items) item: weight};
  }

  Map<String, double> _combinePreferenceMaps(
    List<(Map<String, double>, double)> weightedMaps,
  ) {
    final combined = <String, double>{};
    final allKeys = <String>{};

    // Collect all keys
    for (final (map, _) in weightedMaps) {
      allKeys.addAll(map.keys);
    }

    // Combine weighted values
    for (final key in allKeys) {
      double totalWeight = 0.0;
      double weightedSum = 0.0;

      for (final (map, weight) in weightedMaps) {
        if (map.containsKey(key)) {
          weightedSum += (map[key] ?? 0.0) * weight;
          totalWeight += weight;
        }
      }

      if (totalWeight > 0) {
        combined[key] = weightedSum / totalWeight;
      }
    }

    return _normalizePreferences(combined);
  }

  List<PreferenceChange> _detectChangesInMap(
    Map<String, double> oldMap,
    Map<String, double> newMap,
    String category,
    double threshold,
  ) {
    final changes = <PreferenceChange>[];
    final allKeys = {...oldMap.keys, ...newMap.keys};

    for (final key in allKeys) {
      final oldValue = oldMap[key] ?? 0.0;
      final newValue = newMap[key] ?? 0.0;
      final change = newValue - oldValue;

      if (change.abs() >= threshold) {
        changes.add(PreferenceChange(
          category: category,
          item: key,
          oldValue: oldValue,
          newValue: newValue,
          changeAmount: change,
          changeType: change > 0 
              ? PreferenceChangeType.increased 
              : PreferenceChangeType.decreased,
        ));
      }
    }

    return changes;
  }

  double _calculateOverallChangeScore(List<PreferenceChange> changes) {
    if (changes.isEmpty) return 0.0;
    
    final totalChange = changes.fold<double>(
      0.0, 
      (sum, change) => sum + change.changeAmount.abs(),
    );
    
    return min(totalChange / changes.length, 1.0);
  }

  double _calculateLinearTrend(List<double> values, List<DateTime> timestamps) {
    if (values.length < 2) return 0.0;

    // Convert timestamps to days since first timestamp
    final baseDays = timestamps.first.millisecondsSinceEpoch / (1000 * 60 * 60 * 24);
    final daysList = timestamps
        .map((t) => t.millisecondsSinceEpoch / (1000 * 60 * 60 * 24) - baseDays)
        .toList();

    // Calculate linear regression slope
    final n = values.length;
    final sumX = daysList.fold<double>(0.0, (sum, x) => sum + x);
    final sumY = values.fold<double>(0.0, (sum, y) => sum + y);
    final sumXY = List.generate(n, (i) => daysList[i] * values[i])
        .fold<double>(0.0, (sum, xy) => sum + xy);
    final sumX2 = daysList.fold<double>(0.0, (sum, x) => sum + (x * x));

    final denominator = (n * sumX2) - (sumX * sumX);
    if (denominator == 0) return 0.0;

    return ((n * sumXY) - (sumX * sumY)) / denominator;
  }
}

class PreferenceChanges {
  final List<PreferenceChange> changes;
  final double overallChangeScore;
  final DateTime detectedAt;

  const PreferenceChanges({
    required this.changes,
    required this.overallChangeScore,
    required this.detectedAt,
  });
}

class PreferenceChange {
  final String category;
  final String item;
  final double oldValue;
  final double newValue;
  final double changeAmount;
  final PreferenceChangeType changeType;

  const PreferenceChange({
    required this.category,
    required this.item,
    required this.oldValue,
    required this.newValue,
    required this.changeAmount,
    required this.changeType,
  });
}

enum PreferenceChangeType { increased, decreased, added, removed }