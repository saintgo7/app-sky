import 'dart:math';

import '../../../data/models/booking_model.dart';
import '../../../data/models/travel_package_model.dart';
import '../../../data/models/ai_recommendation_model.dart';
import '../../../data/api/ai_service.dart';
import '../../../core/environment/app_environment.dart';
import '../profiling/user_preference_analyzer.dart';
import '../profiling/travel_style_classifier.dart';
import '../profiling/budget_analyzer.dart';

enum ItineraryOptimizationGoal { 
  timeOptimized, 
  costOptimized, 
  experienceOptimized, 
  balanced,
  cultural,
  adventure,
  relaxation
}

enum TransportMode { walking, publicTransport, taxi, rental, tour }

class ItineraryActivity {
  final String id;
  final String name;
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final Duration estimatedDuration;
  final double cost;
  final List<String> tags;
  final int priority;
  final Map<String, dynamic> metadata;
  final List<String> openingHours;
  final double rating;
  final int reviewCount;

  const ItineraryActivity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.estimatedDuration,
    required this.cost,
    required this.tags,
    required this.priority,
    required this.metadata,
    required this.openingHours,
    required this.rating,
    required this.reviewCount,
  });

  double distanceTo(ItineraryActivity other) {
    // Haversine formula for distance calculation
    const double earthRadius = 6371; // km
    final double dLat = (other.latitude - latitude) * pi / 180;
    final double dLon = (other.longitude - longitude) * pi / 180;
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(latitude * pi / 180) * cos(other.latitude * pi / 180) *
        sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
}

class ItineraryDay {
  final int dayNumber;
  final DateTime date;
  final List<ItineraryActivity> activities;
  final List<TransportSegment> transportSegments;
  final double totalCost;
  final Duration totalDuration;
  final String theme;
  final Map<String, dynamic> metadata;

  const ItineraryDay({
    required this.dayNumber,
    required this.date,
    required this.activities,
    required this.transportSegments,
    required this.totalCost,
    required this.totalDuration,
    required this.theme,
    required this.metadata,
  });

  double get pacingScore {
    if (activities.isEmpty) return 0.0;
    final totalMinutes = totalDuration.inMinutes;
    final activityMinutes = activities.fold<int>(
      0, 
      (sum, activity) => sum + activity.estimatedDuration.inMinutes,
    );
    return activityMinutes / totalMinutes;
  }
}

class TransportSegment {
  final ItineraryActivity? from;
  final ItineraryActivity to;
  final TransportMode mode;
  final Duration duration;
  final double cost;
  final String instructions;

  const TransportSegment({
    this.from,
    required this.to,
    required this.mode,
    required this.duration,
    required this.cost,
    required this.instructions,
  });
}

class GeneratedItinerary {
  final String id;
  final List<ItineraryDay> days;
  final double totalCost;
  final Duration totalDuration;
  final ItineraryOptimizationGoal optimizationGoal;
  final Map<String, dynamic> metrics;
  final List<String> highlights;
  final List<String> recommendations;
  final double feasibilityScore;
  final DateTime generatedAt;

  const GeneratedItinerary({
    required this.id,
    required this.days,
    required this.totalCost,
    required this.totalDuration,
    required this.optimizationGoal,
    required this.metrics,
    required this.highlights,
    required this.recommendations,
    required this.feasibilityScore,
    required this.generatedAt,
  });

  double get averageDailyCost => days.isEmpty ? 0.0 : totalCost / days.length;
  
  int get totalActivities => days.fold(0, (sum, day) => sum + day.activities.length);
  
  List<String> get allCategories => days
      .expand((day) => day.activities)
      .map((activity) => activity.category)
      .toSet()
      .toList();
}

class ItineraryConstraints {
  final double maxBudget;
  final Duration maxDailyDuration;
  final List<String> mustIncludeCategories;
  final List<String> excludeCategories;
  final Map<String, dynamic> accessibility;
  final List<TransportMode> preferredTransport;
  final double maxWalkingDistance;
  final Map<int, List<String>> dayThemes; // day number -> themes

  const ItineraryConstraints({
    required this.maxBudget,
    required this.maxDailyDuration,
    required this.mustIncludeCategories,
    required this.excludeCategories,
    required this.accessibility,
    required this.preferredTransport,
    required this.maxWalkingDistance,
    required this.dayThemes,
  });
}

class ItineraryGenerator {
  final AIService _aiService;

  static const Map<ItineraryOptimizationGoal, Map<String, double>> _goalWeights = {
    ItineraryOptimizationGoal.timeOptimized: {
      'efficiency': 0.4,
      'distance': 0.3,
      'duration': 0.2,
      'cost': 0.1,
    },
    ItineraryOptimizationGoal.costOptimized: {
      'cost': 0.5,
      'efficiency': 0.2,
      'experience': 0.2,
      'distance': 0.1,
    },
    ItineraryOptimizationGoal.experienceOptimized: {
      'experience': 0.4,
      'variety': 0.3,
      'rating': 0.2,
      'cost': 0.1,
    },
    ItineraryOptimizationGoal.balanced: {
      'experience': 0.25,
      'cost': 0.25,
      'efficiency': 0.25,
      'variety': 0.25,
    },
  };

  ItineraryGenerator(this._aiService);

  /// Generates AI-optimized travel itinerary
  Future<GeneratedItinerary> generateItinerary({
    required String destination,
    required DateTime startDate,
    required int durationDays,
    required int travelers,
    UserPreferenceProfile? userPreferences,
    TravelStyleProfile? travelStyle,
    BudgetProfile? budgetProfile,
    ItineraryOptimizationGoal goal = ItineraryOptimizationGoal.balanced,
    ItineraryConstraints? constraints,
  }) async {
    try {
      // Gather available activities and attractions
      final availableActivities = await _getAvailableActivities(destination);
      
      // Score and filter activities based on user preferences
      final scoredActivities = await _scoreActivities(
        availableActivities,
        userPreferences: userPreferences,
        travelStyle: travelStyle,
        budgetProfile: budgetProfile,
      );

      // Apply constraints
      final filteredActivities = _applyConstraints(scoredActivities, constraints);

      // Generate optimized daily itineraries
      final days = <ItineraryDay>[];
      for (int dayNum = 1; dayNum <= durationDays; dayNum++) {
        final dayDate = startDate.add(Duration(days: dayNum - 1));
        final dayTheme = _determineDayTheme(dayNum, travelStyle, constraints);
        
        final dayItinerary = await _generateDayItinerary(
          dayNumber: dayNum,
          date: dayDate,
          availableActivities: filteredActivities,
          theme: dayTheme,
          goal: goal,
          constraints: constraints,
          previousDays: days,
        );
        
        days.add(dayItinerary);
      }

      // Calculate metrics and generate recommendations
      final metrics = await _calculateItineraryMetrics(days, goal);
      final highlights = _generateHighlights(days);
      final recommendations = await _generateRecommendations(days, constraints);
      final feasibilityScore = _calculateFeasibilityScore(days, constraints);

      return GeneratedItinerary(
        id: _generateId(),
        days: days,
        totalCost: days.fold(0.0, (sum, day) => sum + day.totalCost),
        totalDuration: Duration(
          minutes: days.fold(0, (sum, day) => sum + day.totalDuration.inMinutes),
        ),
        optimizationGoal: goal,
        metrics: metrics,
        highlights: highlights,
        recommendations: recommendations,
        feasibilityScore: feasibilityScore,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to generate itinerary: $e');
    }
  }

  /// Optimizes existing itinerary based on feedback
  Future<GeneratedItinerary> optimizeItinerary({
    required GeneratedItinerary currentItinerary,
    required List<String> feedback,
    Map<String, dynamic>? constraints,
  }) async {
    final optimizedDays = <ItineraryDay>[];

    for (final day in currentItinerary.days) {
      final optimizedDay = await _optimizeDayBasedOnFeedback(day, feedback);
      optimizedDays.add(optimizedDay);
    }

    final metrics = await _calculateItineraryMetrics(optimizedDays, currentItinerary.optimizationGoal);
    final highlights = _generateHighlights(optimizedDays);
    final recommendations = await _generateRecommendations(optimizedDays, null);
    final feasibilityScore = _calculateFeasibilityScore(optimizedDays, null);

    return currentItinerary.copyWith(
      days: optimizedDays,
      totalCost: optimizedDays.fold(0.0, (sum, day) => sum + day.totalCost),
      totalDuration: Duration(
        minutes: optimizedDays.fold(0, (sum, day) => sum + day.totalDuration.inMinutes),
      ),
      metrics: metrics,
      highlights: highlights,
      recommendations: recommendations,
      feasibilityScore: feasibilityScore,
      generatedAt: DateTime.now(),
    );
  }

  /// Generates alternative itineraries with different focuses
  Future<List<GeneratedItinerary>> generateAlternatives({
    required String destination,
    required DateTime startDate,
    required int durationDays,
    required int travelers,
    UserPreferenceProfile? userPreferences,
    TravelStyleProfile? travelStyle,
    BudgetProfile? budgetProfile,
    int alternativeCount = 3,
  }) async {
    final alternatives = <GeneratedItinerary>[];
    final goals = [
      ItineraryOptimizationGoal.costOptimized,
      ItineraryOptimizationGoal.experienceOptimized,
      ItineraryOptimizationGoal.balanced,
    ];

    for (int i = 0; i < min(alternativeCount, goals.length); i++) {
      final alternative = await generateItinerary(
        destination: destination,
        startDate: startDate,
        durationDays: durationDays,
        travelers: travelers,
        userPreferences: userPreferences,
        travelStyle: travelStyle,
        budgetProfile: budgetProfile,
        goal: goals[i],
      );
      alternatives.add(alternative);
    }

    return alternatives;
  }

  /// Suggests itinerary modifications based on real-time factors
  Future<List<ItineraryModification>> suggestModifications({
    required GeneratedItinerary itinerary,
    required DateTime currentDate,
    Map<String, dynamic>? realTimeFactors,
  }) async {
    final modifications = <ItineraryModification>[];

    // Weather-based modifications
    if (realTimeFactors?['weather'] != null) {
      final weatherMods = await _suggestWeatherBasedModifications(
        itinerary,
        realTimeFactors!['weather'],
      );
      modifications.addAll(weatherMods);
    }

    // Crowd-based modifications
    if (realTimeFactors?['crowdLevels'] != null) {
      final crowdMods = await _suggestCrowdBasedModifications(
        itinerary,
        realTimeFactors!['crowdLevels'],
      );
      modifications.addAll(crowdMods);
    }

    // Event-based modifications
    if (realTimeFactors?['localEvents'] != null) {
      final eventMods = await _suggestEventBasedModifications(
        itinerary,
        realTimeFactors!['localEvents'],
      );
      modifications.addAll(eventMods);
    }

    return modifications;
  }

  // Private helper methods

  Future<List<ItineraryActivity>> _getAvailableActivities(String destination) async {
    // In a real implementation, this would fetch from multiple APIs:
    // - Google Places API
    // - TripAdvisor API
    // - Local tourism databases
    // - User-generated content platforms
    
    // Mock data for demonstration
    return [
      ItineraryActivity(
        id: 'act_001',
        name: 'Central Museum',
        description: 'Largest museum showcasing local history and culture',
        category: 'cultural',
        latitude: 37.5665,
        longitude: 126.9780,
        estimatedDuration: const Duration(hours: 2, minutes: 30),
        cost: 15000,
        tags: ['history', 'art', 'indoor', 'educational'],
        priority: 8,
        metadata: {
          'openingTime': '09:00',
          'closingTime': '18:00',
          'wheelchairAccessible': true,
        },
        openingHours: ['09:00-18:00', '09:00-18:00', '09:00-18:00', '09:00-18:00', '09:00-18:00', '10:00-17:00', '10:00-17:00'],
        rating: 4.2,
        reviewCount: 1234,
      ),
      ItineraryActivity(
        id: 'act_002',
        name: 'Traditional Market',
        description: 'Bustling local market with street food and souvenirs',
        category: 'culinary',
        latitude: 37.5701,
        longitude: 126.9767,
        estimatedDuration: const Duration(hours: 1, minutes: 30),
        cost: 25000,
        tags: ['food', 'shopping', 'local', 'outdoor'],
        priority: 9,
        metadata: {
          'openingTime': '08:00',
          'closingTime': '20:00',
          'wheelchairAccessible': false,
        },
        openingHours: ['08:00-20:00', '08:00-20:00', '08:00-20:00', '08:00-20:00', '08:00-20:00', '08:00-21:00', '08:00-21:00'],
        rating: 4.5,
        reviewCount: 2156,
      ),
      // Add more activities...
    ];
  }

  Future<List<ItineraryActivity>> _scoreActivities(
    List<ItineraryActivity> activities, {
    UserPreferenceProfile? userPreferences,
    TravelStyleProfile? travelStyle,
    BudgetProfile? budgetProfile,
  }) async {
    final scoredActivities = <(ItineraryActivity, double)>[];

    for (final activity in activities) {
      double score = activity.rating / 5.0; // Base score from ratings

      // Apply user preference scoring
      if (userPreferences != null) {
        final categoryPref = userPreferences.activityPreferences[activity.category] ?? 0.0;
        score += categoryPref * 0.3;
      }

      // Apply travel style scoring
      if (travelStyle != null) {
        score += _calculateTravelStyleScore(activity, travelStyle) * 0.2;
      }

      // Apply budget scoring
      if (budgetProfile != null) {
        score += _calculateBudgetScore(activity, budgetProfile) * 0.2;
      }

      // Priority boost
      score += (activity.priority / 10.0) * 0.3;

      scoredActivities.add((activity, score));
    }

    // Sort by score descending
    scoredActivities.sort((a, b) => b.$2.compareTo(a.$2));
    return scoredActivities.map((tuple) => tuple.$1).toList();
  }

  double _calculateTravelStyleScore(ItineraryActivity activity, TravelStyleProfile travelStyle) {
    final styleScores = <TravelStyle, double>{
      TravelStyle.cultural: activity.category == 'cultural' ? 1.0 : 0.0,
      TravelStyle.adventure: activity.tags.contains('adventure') ? 1.0 : 0.0,
      TravelStyle.luxury: activity.cost > 50000 ? 1.0 : 0.0,
      TravelStyle.budget: activity.cost < 20000 ? 1.0 : 0.0,
      TravelStyle.family: activity.tags.contains('family-friendly') ? 1.0 : 0.0,
    };

    double score = 0.0;
    for (final style in travelStyle.styleScores.entries) {
      score += (styleScores[style.key] ?? 0.0) * style.value;
    }

    return score;
  }

  double _calculateBudgetScore(ItineraryActivity activity, BudgetProfile budgetProfile) {
    if (budgetProfile.isWithinBudget(activity.cost)) {
      return 1.0;
    }
    
    final utilization = budgetProfile.getBudgetUtilization(activity.cost);
    return max(0.0, 1.0 - utilization);
  }

  List<ItineraryActivity> _applyConstraints(
    List<ItineraryActivity> activities,
    ItineraryConstraints? constraints,
  ) {
    if (constraints == null) return activities;

    return activities.where((activity) {
      // Budget constraint
      if (activity.cost > constraints.maxBudget) return false;

      // Category constraints
      if (constraints.excludeCategories.contains(activity.category)) return false;

      // Accessibility constraints
      if (constraints.accessibility['wheelchairRequired'] == true) {
        if (activity.metadata['wheelchairAccessible'] != true) return false;
      }

      return true;
    }).toList();
  }

  String _determineDayTheme(
    int dayNumber,
    TravelStyleProfile? travelStyle,
    ItineraryConstraints? constraints,
  ) {
    // Check if theme is specified in constraints
    if (constraints?.dayThemes[dayNumber] != null) {
      return constraints!.dayThemes[dayNumber]!.first;
    }

    // Determine theme based on travel style and day number
    if (travelStyle != null) {
      switch (travelStyle.primaryStyle) {
        case TravelStyle.cultural:
          return ['cultural exploration', 'heritage discovery', 'local immersion'][dayNumber % 3];
        case TravelStyle.adventure:
          return ['outdoor adventure', 'thrill seeking', 'nature exploration'][dayNumber % 3];
        case TravelStyle.luxury:
          return ['premium experiences', 'exclusive venues', 'fine dining'][dayNumber % 3];
        case TravelStyle.budget:
          return ['local discoveries', 'free attractions', 'street food'][dayNumber % 3];
        default:
          return 'balanced exploration';
      }
    }

    return 'general exploration';
  }

  Future<ItineraryDay> _generateDayItinerary({
    required int dayNumber,
    required DateTime date,
    required List<ItineraryActivity> availableActivities,
    required String theme,
    required ItineraryOptimizationGoal goal,
    ItineraryConstraints? constraints,
    required List<ItineraryDay> previousDays,
  }) async {
    final usedActivityIds = previousDays
        .expand((day) => day.activities)
        .map((activity) => activity.id)
        .toSet();

    final remainingActivities = availableActivities
        .where((activity) => !usedActivityIds.contains(activity.id))
        .toList();

    // Select activities for this day based on theme and constraints
    final selectedActivities = await _selectDayActivities(
      remainingActivities,
      theme,
      goal,
      constraints,
    );

    // Optimize activity order
    final optimizedActivities = await _optimizeActivityOrder(selectedActivities, goal);

    // Generate transport segments
    final transportSegments = await _generateTransportSegments(optimizedActivities);

    // Calculate costs and duration
    final activityCosts = optimizedActivities.fold<double>(0.0, (sum, activity) => sum + activity.cost);
    final transportCosts = transportSegments.fold<double>(0.0, (sum, segment) => sum + segment.cost);
    final totalCost = activityCosts + transportCosts;

    final activityDuration = optimizedActivities.fold<Duration>(
      Duration.zero,
      (sum, activity) => sum + activity.estimatedDuration,
    );
    final transportDuration = transportSegments.fold<Duration>(
      Duration.zero,
      (sum, segment) => sum + segment.duration,
    );
    final totalDuration = activityDuration + transportDuration;

    return ItineraryDay(
      dayNumber: dayNumber,
      date: date,
      activities: optimizedActivities,
      transportSegments: transportSegments,
      totalCost: totalCost,
      totalDuration: totalDuration,
      theme: theme,
      metadata: {
        'activityCosts': activityCosts,
        'transportCosts': transportCosts,
        'pacingScore': _calculateDayPacingScore(optimizedActivities, totalDuration),
        'diversityScore': _calculateDayDiversityScore(optimizedActivities),
      },
    );
  }

  Future<List<ItineraryActivity>> _selectDayActivities(
    List<ItineraryActivity> availableActivities,
    String theme,
    ItineraryOptimizationGoal goal,
    ItineraryConstraints? constraints,
  ) async {
    final themeRelevantActivities = availableActivities.where((activity) {
      return _isActivityRelevantToTheme(activity, theme);
    }).toList();

    final maxDuration = constraints?.maxDailyDuration ?? const Duration(hours: 8);
    final selected = <ItineraryActivity>[];
    Duration currentDuration = Duration.zero;

    // Greedy selection based on optimization goal
    for (final activity in themeRelevantActivities) {
      if (currentDuration + activity.estimatedDuration <= maxDuration) {
        selected.add(activity);
        currentDuration += activity.estimatedDuration;
        
        if (selected.length >= 4) break; // Max 4 activities per day
      }
    }

    return selected;
  }

  bool _isActivityRelevantToTheme(ItineraryActivity activity, String theme) {
    final themeKeywords = theme.toLowerCase().split(' ');
    
    for (final keyword in themeKeywords) {
      if (activity.category.contains(keyword) ||
          activity.tags.any((tag) => tag.contains(keyword)) ||
          activity.name.toLowerCase().contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  Future<List<ItineraryActivity>> _optimizeActivityOrder(
    List<ItineraryActivity> activities,
    ItineraryOptimizationGoal goal,
  ) async {
    if (activities.length <= 1) return activities;

    // Traveling Salesman Problem approximation for optimal ordering
    final weights = _goalWeights[goal] ?? _goalWeights[ItineraryOptimizationGoal.balanced]!;
    
    // Calculate distance matrix
    final distances = <List<double>>[];
    for (int i = 0; i < activities.length; i++) {
      distances.add(<double>[]);
      for (int j = 0; j < activities.length; j++) {
        if (i == j) {
          distances[i].add(0.0);
        } else {
          distances[i].add(activities[i].distanceTo(activities[j]));
        }
      }
    }

    // Simple nearest neighbor heuristic
    final visited = <bool>[for (int i = 0; i < activities.length; i++) false];
    final optimizedOrder = <ItineraryActivity>[];
    int currentIndex = 0;

    optimizedOrder.add(activities[currentIndex]);
    visited[currentIndex] = true;

    while (optimizedOrder.length < activities.length) {
      double minDistance = double.infinity;
      int nextIndex = -1;

      for (int i = 0; i < activities.length; i++) {
        if (!visited[i] && distances[currentIndex][i] < minDistance) {
          minDistance = distances[currentIndex][i];
          nextIndex = i;
        }
      }

      if (nextIndex != -1) {
        optimizedOrder.add(activities[nextIndex]);
        visited[nextIndex] = true;
        currentIndex = nextIndex;
      } else {
        break;
      }
    }

    return optimizedOrder;
  }

  Future<List<TransportSegment>> _generateTransportSegments(
    List<ItineraryActivity> activities,
  ) async {
    if (activities.length <= 1) return [];

    final segments = <TransportSegment>[];
    
    for (int i = 0; i < activities.length - 1; i++) {
      final from = activities[i];
      final to = activities[i + 1];
      final distance = from.distanceTo(to);
      
      // Determine best transport mode based on distance
      TransportMode mode;
      Duration duration;
      double cost;

      if (distance <= 0.5) {
        mode = TransportMode.walking;
        duration = Duration(minutes: (distance * 12).round()); // ~5 km/h walking speed
        cost = 0;
      } else if (distance <= 3) {
        mode = TransportMode.publicTransport;
        duration = Duration(minutes: (distance * 8).round());
        cost = 1500; // Average subway/bus fare
      } else {
        mode = TransportMode.taxi;
        duration = Duration(minutes: (distance * 4).round());
        cost = distance * 1200 + 3000; // Base fare + per km
      }

      segments.add(TransportSegment(
        from: from,
        to: to,
        mode: mode,
        duration: duration,
        cost: cost,
        instructions: _generateTransportInstructions(from, to, mode),
      ));
    }

    return segments;
  }

  String _generateTransportInstructions(
    ItineraryActivity from,
    ItineraryActivity to,
    TransportMode mode,
  ) {
    switch (mode) {
      case TransportMode.walking:
        return 'Walk to ${to.name} (${from.distanceTo(to).toStringAsFixed(1)}km)';
      case TransportMode.publicTransport:
        return 'Take public transport to ${to.name}';
      case TransportMode.taxi:
        return 'Take taxi to ${to.name}';
      case TransportMode.rental:
        return 'Drive to ${to.name}';
      case TransportMode.tour:
        return 'Tour transport to ${to.name}';
    }
  }

  Future<Map<String, dynamic>> _calculateItineraryMetrics(
    List<ItineraryDay> days,
    ItineraryOptimizationGoal goal,
  ) async {
    final totalActivities = days.fold(0, (sum, day) => sum + day.activities.length);
    final totalTransportTime = days.fold<Duration>(
      Duration.zero,
      (sum, day) => sum + day.transportSegments.fold<Duration>(
        Duration.zero,
        (segSum, segment) => segSum + segment.duration,
      ),
    );
    
    final categories = <String, int>{};
    for (final day in days) {
      for (final activity in day.activities) {
        categories[activity.category] = (categories[activity.category] ?? 0) + 1;
      }
    }

    final averageRating = days.isEmpty ? 0.0 : days
        .expand((day) => day.activities)
        .map((activity) => activity.rating)
        .fold<double>(0.0, (sum, rating) => sum + rating) / totalActivities;

    return {
      'totalActivities': totalActivities,
      'totalTransportTime': totalTransportTime.inMinutes,
      'categoryDistribution': categories,
      'averageRating': averageRating,
      'efficiencyScore': _calculateEfficiencyScore(days),
      'diversityScore': _calculateOverallDiversityScore(days),
      'pacingScore': _calculateOverallPacingScore(days),
    };
  }

  double _calculateEfficiencyScore(List<ItineraryDay> days) {
    if (days.isEmpty) return 0.0;
    
    double totalEfficiency = 0.0;
    for (final day in days) {
      final activityTime = day.activities.fold<Duration>(
        Duration.zero,
        (sum, activity) => sum + activity.estimatedDuration,
      );
      final transportTime = day.transportSegments.fold<Duration>(
        Duration.zero,
        (sum, segment) => sum + segment.duration,
      );
      
      final dayEfficiency = activityTime.inMinutes / 
          (activityTime.inMinutes + transportTime.inMinutes);
      totalEfficiency += dayEfficiency;
    }
    
    return totalEfficiency / days.length;
  }

  double _calculateOverallDiversityScore(List<ItineraryDay> days) {
    final allCategories = days
        .expand((day) => day.activities)
        .map((activity) => activity.category)
        .toSet();
    
    final totalActivities = days.fold(0, (sum, day) => sum + day.activities.length);
    return totalActivities > 0 ? allCategories.length / totalActivities : 0.0;
  }

  double _calculateOverallPacingScore(List<ItineraryDay> days) {
    if (days.isEmpty) return 0.0;
    
    return days.map((day) => day.pacingScore).fold<double>(0.0, (sum, score) => sum + score) / days.length;
  }

  double _calculateDayPacingScore(List<ItineraryActivity> activities, Duration totalDuration) {
    if (activities.isEmpty || totalDuration.inMinutes == 0) return 0.0;
    
    final activityMinutes = activities.fold<int>(
      0, 
      (sum, activity) => sum + activity.estimatedDuration.inMinutes,
    );
    return activityMinutes / totalDuration.inMinutes;
  }

  double _calculateDayDiversityScore(List<ItineraryActivity> activities) {
    if (activities.isEmpty) return 0.0;
    
    final categories = activities.map((activity) => activity.category).toSet();
    return categories.length / activities.length;
  }

  List<String> _generateHighlights(List<ItineraryDay> days) {
    final highlights = <String>[];
    
    // Top-rated activities
    final topActivities = days
        .expand((day) => day.activities)
        .where((activity) => activity.rating >= 4.0)
        .take(3)
        .toList();
    
    for (final activity in topActivities) {
      highlights.add('${activity.name} - Highly rated ${activity.category} experience');
    }

    // Unique categories
    final categories = days
        .expand((day) => day.activities)
        .map((activity) => activity.category)
        .toSet();
    
    if (categories.length >= 4) {
      highlights.add('Diverse experience covering ${categories.length} different activity types');
    }

    return highlights;
  }

  Future<List<String>> _generateRecommendations(
    List<ItineraryDay> days,
    ItineraryConstraints? constraints,
  ) async {
    final recommendations = <String>[];

    // Pacing recommendations
    final highPacingDays = days.where((day) => day.pacingScore > 0.8).length;
    if (highPacingDays > days.length * 0.5) {
      recommendations.add('Consider adding more buffer time between activities for a more relaxed pace');
    }

    // Budget recommendations
    final averageDailyCost = days.isEmpty ? 0.0 : 
        days.fold<double>(0.0, (sum, day) => sum + day.totalCost) / days.length;
    if (constraints != null && averageDailyCost > constraints.maxBudget * 0.8) {
      recommendations.add('Consider some free or low-cost alternatives to stay within budget');
    }

    // Transport recommendations
    final totalWalkingDistance = days
        .expand((day) => day.transportSegments)
        .where((segment) => segment.mode == TransportMode.walking)
        .fold<double>(0.0, (sum, segment) => sum + segment.from!.distanceTo(segment.to));
    
    if (totalWalkingDistance > 10) {
      recommendations.add('Consider using public transport for some longer distances');
    }

    return recommendations;
  }

  double _calculateFeasibilityScore(List<ItineraryDay> days, ItineraryConstraints? constraints) {
    double score = 1.0;

    for (final day in days) {
      // Check daily duration constraint
      if (constraints?.maxDailyDuration != null && 
          day.totalDuration > constraints!.maxDailyDuration) {
        score -= 0.2;
      }

      // Check pacing
      if (day.pacingScore > 0.9) {
        score -= 0.1; // Too packed
      } else if (day.pacingScore < 0.3) {
        score -= 0.1; // Too light
      }

      // Check transport feasibility
      for (final segment in day.transportSegments) {
        if (segment.mode == TransportMode.walking && 
            segment.from!.distanceTo(segment.to) > 2.0) {
          score -= 0.1; // Long walking distance
        }
      }
    }

    return max(0.0, score);
  }

  Future<ItineraryDay> _optimizeDayBasedOnFeedback(
    ItineraryDay day,
    List<String> feedback,
  ) async {
    // Analyze feedback and adjust the day accordingly
    // This is a simplified implementation
    return day;
  }

  Future<List<ItineraryModification>> _suggestWeatherBasedModifications(
    GeneratedItinerary itinerary,
    Map<String, dynamic> weatherData,
  ) async {
    // Weather-based modifications logic
    return [];
  }

  Future<List<ItineraryModification>> _suggestCrowdBasedModifications(
    GeneratedItinerary itinerary,
    Map<String, dynamic> crowdData,
  ) async {
    // Crowd-based modifications logic
    return [];
  }

  Future<List<ItineraryModification>> _suggestEventBasedModifications(
    GeneratedItinerary itinerary,
    Map<String, dynamic> eventData,
  ) async {
    // Event-based modifications logic
    return [];
  }

  String _generateId() {
    return 'itin_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }
}

// Supporting classes
class ItineraryModification {
  final String id;
  final String type;
  final String description;
  final int dayNumber;
  final String activityId;
  final Map<String, dynamic> changes;
  final String reason;

  const ItineraryModification({
    required this.id,
    required this.type,
    required this.description,
    required this.dayNumber,
    required this.activityId,
    required this.changes,
    required this.reason,
  });
}

extension GeneratedItineraryExtension on GeneratedItinerary {
  GeneratedItinerary copyWith({
    String? id,
    List<ItineraryDay>? days,
    double? totalCost,
    Duration? totalDuration,
    ItineraryOptimizationGoal? optimizationGoal,
    Map<String, dynamic>? metrics,
    List<String>? highlights,
    List<String>? recommendations,
    double? feasibilityScore,
    DateTime? generatedAt,
  }) {
    return GeneratedItinerary(
      id: id ?? this.id,
      days: days ?? this.days,
      totalCost: totalCost ?? this.totalCost,
      totalDuration: totalDuration ?? this.totalDuration,
      optimizationGoal: optimizationGoal ?? this.optimizationGoal,
      metrics: metrics ?? this.metrics,
      highlights: highlights ?? this.highlights,
      recommendations: recommendations ?? this.recommendations,
      feasibilityScore: feasibilityScore ?? this.feasibilityScore,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}