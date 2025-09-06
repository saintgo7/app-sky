import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../services/ai/profiling/user_preference_analyzer.dart';
import '../../../services/ai/profiling/travel_style_classifier.dart';
import '../../../services/ai/profiling/budget_analyzer.dart';
import '../../../data/models/booking_model.dart';

class TravelInsightScreen extends StatefulWidget {
  const TravelInsightScreen({super.key});

  @override
  State<TravelInsightScreen> createState() => _TravelInsightScreenState();
}

class _TravelInsightScreenState extends State<TravelInsightScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  bool _isLoading = true;
  UserPreferenceProfile? _userPreferences;
  TravelStyleProfile? _travelStyle;
  BudgetProfile? _budgetProfile;
  List<BookingModel> _bookingHistory = [];
  Map<String, dynamic> _insights = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    
    _loadInsights();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadInsights() async {
    setState(() => _isLoading = true);

    try {
      // Mock data loading - in real app, get from services
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _userPreferences = _createMockUserPreferences();
        _travelStyle = _createMockTravelStyle();
        _budgetProfile = _createMockBudgetProfile();
        _bookingHistory = _createMockBookingHistory();
        _insights = _generateInsights();
        _isLoading = false;
      });

      _fadeController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('인사이트를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text('여행 인사이트'),
              pinned: true,
              floating: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderBackground(),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.analytics), text: '개요'),
                  Tab(icon: Icon(Icons.person), text: '성향'),
                  Tab(icon: Icon(Icons.account_balance_wallet), text: '예산'),
                  Tab(icon: Icon(Icons.trending_up), text: '트렌드'),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadInsights,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: _shareInsights,
                ),
              ],
            ),
          ];
        },
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : FadeTransition(
                opacity: _fadeAnimation,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildPreferencesTab(),
                    _buildBudgetTab(),
                    _buildTrendsTab(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '당신의 여행 패턴',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (_userPreferences != null) ...[
              Text(
                '${_bookingHistory.length}번의 여행 분석 결과',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '신뢰도: ${(_userPreferences!.confidenceScore * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 24),
          _buildTravelFrequencyChart(),
          const SizedBox(height: 24),
          _buildDestinationChart(),
          const SizedBox(height: 24),
          _buildPersonalizedInsights(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            '총 여행 횟수',
            '${_bookingHistory.length}',
            Icons.flight_takeoff,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            '평균 여행 비용',
            '₩${_getAverageSpending().toStringAsFixed(0)}',
            Icons.attach_money,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            '선호 시즌',
            _getPreferredSeason(),
            Icons.wb_sunny,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelFrequencyChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '월별 여행 빈도',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(months[value.toInt()]);
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateMonthlyTravelData(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '선호 목적지',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _generateDestinationData(),
                  centerSpaceRadius: 60,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizedInsights() {
    final insights = _insights['personalizedInsights'] as List<String>? ?? [];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI 인사이트',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...insights.map((insight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insight,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesTab() {
    if (_userPreferences == null) {
      return const Center(child: Text('선호도 데이터가 없습니다'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreferenceChart('목적지 선호도', _userPreferences!.destinationPreferences),
          const SizedBox(height: 16),
          _buildPreferenceChart('활동 선호도', _userPreferences!.activityPreferences),
          const SizedBox(height: 16),
          _buildPreferenceChart('숙박 선호도', _userPreferences!.accommodationPreferences),
          const SizedBox(height: 16),
          _buildPreferenceChart('계절 선호도', _userPreferences!.seasonalPreferences),
        ],
      ),
    );
  }

  Widget _buildPreferenceChart(String title, Map<String, double> preferences) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...preferences.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text('${(entry.value * 100).toInt()}%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetTab() {
    if (_budgetProfile == null) {
      return const Center(child: Text('예산 데이터가 없습니다'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBudgetSummary(),
          const SizedBox(height: 16),
          _buildBudgetBreakdown(),
          const SizedBox(height: 16),
          _buildBudgetTrends(),
          const SizedBox(height: 16),
          _buildBudgetRecommendations(),
        ],
      ),
    );
  }

  Widget _buildBudgetSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildBudgetCard(
            '평균 일 예산',
            '₩${(_budgetProfile!.averageSpendingPerDay / 1000).toInt()}K',
            Icons.today,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildBudgetCard(
            '평균 총 예산',
            '₩${(_budgetProfile!.averageTotalSpending / 1000).toInt()}K',
            Icons.account_balance_wallet,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildBudgetCard(
            '예산 유연성',
            '${(_budgetProfile!.flexibility * 100).toInt()}%',
            Icons.trending_up,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '카테고리별 지출 비율',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _budgetProfile!.spendingByCategory.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value * 100,
                      title: '${(entry.value * 100).toInt()}%',
                      color: _getCategoryColor(entry.key),
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _budgetProfile!.spendingByCategory.entries.map((entry) {
                return Chip(
                  backgroundColor: _getCategoryColor(entry.key),
                  label: Text(
                    entry.key,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetTrends() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '예산 트렌드',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateBudgetTrendData(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetRecommendations() {
    final recommendations = [
      '다음 여행에서는 활동 예산을 10% 늘려보세요',
      '숙박비 절약을 위해 게스트하우스를 고려해보세요',
      '성수기를 피하면 30% 절약 가능합니다',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '예산 최적화 제안',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...recommendations.map((recommendation) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.savings,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTravelStyleEvolution(),
          const SizedBox(height: 16),
          _buildSeasonalTrends(),
          const SizedBox(height: 16),
          _buildFuturePredictions(),
        ],
      ),
    );
  }

  Widget _buildTravelStyleEvolution() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '여행 스타일 변화',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (_travelStyle != null) ...[
              ...TravelStyle.values.map((style) {
                final score = _travelStyle!.getStyleScore(style);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(style.name),
                          Text('${(score * 100).toInt()}%'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: score,
                        backgroundColor: Colors.grey.shade300,
                        color: _getStyleColor(style),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonalTrends() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '계절별 선호도 변화',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: _generateSeasonalData(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const seasons = ['봄', '여름', '가을', '겨울'];
                          if (value.toInt() >= 0 && value.toInt() < seasons.length) {
                            return Text(seasons[value.toInt()]);
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuturePredictions() {
    final predictions = [
      '향후 3개월 내 일본 여행 가능성: 75%',
      '다음 여행 예상 예산: ₩1,200,000',
      '추천 여행 시기: 2024년 4월',
      '예상 여행 스타일: 문화 + 휴양',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.crystal_ball,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI 예측',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...predictions.map((prediction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.purple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        prediction,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Helper methods for generating mock data and insights

  UserPreferenceProfile _createMockUserPreferences() {
    return UserPreferenceProfile(
      destinationPreferences: {
        '일본': 0.8,
        '태국': 0.6,
        '베트남': 0.4,
        '싱가포르': 0.3,
      },
      activityPreferences: {
        '문화탐방': 0.9,
        '맛집투어': 0.7,
        '쇼핑': 0.5,
        '자연관광': 0.4,
      },
      accommodationPreferences: {
        '호텔': 0.7,
        '리조트': 0.5,
        '게스트하우스': 0.3,
      },
      seasonalPreferences: {
        '봄': 0.8,
        '가을': 0.6,
        '겨울': 0.4,
        '여름': 0.3,
      },
      budgetPreferences: {
        '중급': 0.7,
        '고급': 0.5,
        '저예산': 0.3,
      },
      durationPreferences: {
        '3-4일': 0.8,
        '5-7일': 0.6,
        '1-2일': 0.3,
      },
      companionPreferences: {
        '커플': 0.8,
        '가족': 0.4,
        '혼자': 0.3,
      },
      lastUpdated: DateTime.now(),
      confidenceScore: 0.85,
    );
  }

  TravelStyleProfile _createMockTravelStyle() {
    return TravelStyleProfile(
      primaryStyle: TravelStyle.cultural,
      secondaryStyle: TravelStyle.luxury,
      styleScores: {
        TravelStyle.cultural: 0.8,
        TravelStyle.luxury: 0.6,
        TravelStyle.midRange: 0.4,
        TravelStyle.adventure: 0.3,
        TravelStyle.family: 0.2,
      },
      confidence: 0.85,
      styleCharacteristics: [
        'Cultural explorer',
        'Premium experiences preferred',
        'History and art enthusiast',
      ],
      analyzedAt: DateTime.now(),
    );
  }

  BudgetProfile _createMockBudgetProfile() {
    return BudgetProfile(
      primaryCategory: BudgetCategory.high,
      averageSpendingPerDay: 250000,
      averageTotalSpending: 1500000,
      spendingByCategory: {
        '숙박': 0.4,
        '교통': 0.25,
        '식사': 0.2,
        '활동': 0.1,
        '기타': 0.05,
      },
      rangePreference: const BudgetRangePreference(
        minBudget: 1000000,
        maxBudget: 2500000,
        preferredBudget: 1500000,
        currency: 'KRW',
        confidence: 0.8,
      ),
      patterns: [],
      flexibility: 0.3,
      analyzedAt: DateTime.now(),
      confidence: 0.8,
    );
  }

  List<BookingModel> _createMockBookingHistory() {
    // Return mock booking data
    return [];
  }

  Map<String, dynamic> _generateInsights() {
    return {
      'personalizedInsights': [
        '당신은 문화적 경험을 중시하는 여행자입니다',
        '봄과 가을에 여행하는 것을 선호합니다',
        '일본에 대한 관심도가 매우 높습니다',
        '평균보다 높은 예산을 책정하여 품질 높은 여행을 추구합니다',
        '3-4일 정도의 짧은 여행을 선호하는 경향이 있습니다',
      ],
    };
  }

  double _getAverageSpending() {
    return _budgetProfile?.averageTotalSpending ?? 0.0;
  }

  String _getPreferredSeason() {
    if (_userPreferences?.seasonalPreferences.isEmpty ?? true) return '봄';
    final topSeason = _userPreferences!.seasonalPreferences.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    return topSeason.key;
  }

  List<FlSpot> _generateMonthlyTravelData() {
    return [
      FlSpot(0, 1), FlSpot(1, 0), FlSpot(2, 2), FlSpot(3, 3),
      FlSpot(4, 1), FlSpot(5, 0), FlSpot(6, 1), FlSpot(7, 2),
      FlSpot(8, 1), FlSpot(9, 3), FlSpot(10, 2), FlSpot(11, 1),
    ];
  }

  List<PieChartSectionData> _generateDestinationData() {
    if (_userPreferences?.destinationPreferences.isEmpty ?? true) {
      return [];
    }
    
    return _userPreferences!.destinationPreferences.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value * 100,
        title: entry.key,
        color: _getDestinationColor(entry.key),
        radius: 80,
      );
    }).toList();
  }

  List<FlSpot> _generateBudgetTrendData() {
    return [
      FlSpot(0, 1000), FlSpot(1, 1200), FlSpot(2, 1500), FlSpot(3, 1300),
      FlSpot(4, 1800), FlSpot(5, 1600), FlSpot(6, 2000), FlSpot(7, 1900),
    ];
  }

  List<BarChartGroupData> _generateSeasonalData() {
    return [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.green)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3, color: Colors.red)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 6, color: Colors.orange)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4, color: Colors.blue)]),
    ];
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '숙박':
        return Colors.blue;
      case '교통':
        return Colors.green;
      case '식사':
        return Colors.orange;
      case '활동':
        return Colors.purple;
      case '기타':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getDestinationColor(String destination) {
    switch (destination) {
      case '일본':
        return Colors.red;
      case '태국':
        return Colors.blue;
      case '베트남':
        return Colors.green;
      case '싱가포르':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStyleColor(TravelStyle style) {
    switch (style) {
      case TravelStyle.luxury:
        return Colors.purple;
      case TravelStyle.cultural:
        return Colors.blue;
      case TravelStyle.adventure:
        return Colors.green;
      case TravelStyle.family:
        return Colors.orange;
      case TravelStyle.budget:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _shareInsights() {
    // TODO: Implement insights sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('인사이트 공유 기능 준비 중')),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}