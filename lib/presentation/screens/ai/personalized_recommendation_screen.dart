import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../services/ai/recommendation/recommendation_engine.dart';
import '../../../services/ai/profiling/user_preference_analyzer.dart';
import '../../../services/ai/profiling/travel_style_classifier.dart';
import '../../../services/ai/profiling/budget_analyzer.dart';
import '../../../data/models/ai_recommendation_model.dart';
import '../../../data/models/travel_package_model.dart';

class PersonalizedRecommendationScreen extends StatefulWidget {
  const PersonalizedRecommendationScreen({super.key});

  @override
  State<PersonalizedRecommendationScreen> createState() =>
      _PersonalizedRecommendationScreenState();
}

class _PersonalizedRecommendationScreenState
    extends State<PersonalizedRecommendationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  
  bool _isLoading = true;
  List<AIRecommendationModel> _recommendations = [];
  UserPreferenceProfile? _userProfile;
  TravelStyleProfile? _travelStyle;
  BudgetProfile? _budgetProfile;
  
  String _selectedStrategy = 'all';
  Map<String, bool> _filters = {
    'domestic': false,
    'international': false,
    'budget': false,
    'luxury': false,
    'family': false,
    'solo': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _loadRecommendations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRecommendations() async {
    setState(() => _isLoading = true);
    
    try {
      final recommendationEngine = context.read<RecommendationEngine>();
      
      // Create recommendation request
      final request = RecommendationRequest(
        userId: 'current_user_id', // Get from auth
        requestType: RecommendationType.comprehensive,
        contextParameters: {
          'strategy': _selectedStrategy,
          'filters': _filters,
        },
        maxResults: 20,
      );

      final result = await recommendationEngine.generateRecommendations(request);
      
      setState(() {
        _recommendations = result.recommendations;
        _userProfile = result.contextData['userProfile'] as UserPreferenceProfile?;
        _travelStyle = result.contextData['travelStyle'] as TravelStyleProfile?;
        _budgetProfile = result.contextData['budgetProfile'] as BudgetProfile?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('추천을 불러오는 중 오류가 발생했습니다: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text('맞춤 추천'),
              pinned: true,
              floating: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderBackground(),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.recommend), text: '전체'),
                  Tab(icon: Icon(Icons.trending_up), text: '인기'),
                  Tab(icon: Icon(Icons.new_releases), text: '신규'),
                  Tab(icon: Icon(Icons.star), text: '프리미엄'),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: _showFilterBottomSheet,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadRecommendations,
                ),
              ],
            ),
          ];
        },
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildAllRecommendations(),
                  _buildPopularRecommendations(),
                  _buildNewRecommendations(),
                  _buildPremiumRecommendations(),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/ai-consultation'),
        icon: const Icon(Icons.smart_toy),
        label: const Text('AI 컨설팅'),
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
            if (_userProfile != null) ...[
              Text(
                '당신을 위한 특별한 추천',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              _buildUserInsights(),
            ] else ...[
              Text(
                '개인화된 추천을 위해',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'AI 컨설팅을 시작해보세요',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textLight.withOpacity(0.7),
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserInsights() {
    final insights = <String>[];
    
    if (_travelStyle != null) {
      insights.add(_travelStyle!.primaryStyle.name);
    }
    
    if (_budgetProfile != null) {
      insights.add(_budgetProfile!.primaryCategory.name);
    }

    if (_userProfile != null && _userProfile!.destinationPreferences.isNotEmpty) {
      final topDestination = _userProfile!.destinationPreferences.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      insights.add(topDestination.key);
    }

    return Wrap(
      spacing: 8,
      children: insights.map((insight) {
        return Chip(
          label: Text(
            insight,
            style: const TextStyle(color: AppColors.textLight, fontSize: 12),
          ),
          backgroundColor: AppColors.textLight.withOpacity(0.2),
          side: BorderSide(color: AppColors.textLight.withOpacity(0.54)),
        );
      }).toList(),
    );
  }

  Widget _buildAllRecommendations() {
    if (_recommendations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.travel_explore, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text('추천할 여행이 없습니다'),
            SizedBox(height: 8),
            Text('필터를 조정하거나 AI 컨설팅을 이용해보세요'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRecommendations,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRecommendationStats(),
          const SizedBox(height: 16),
          ..._recommendations.map((recommendation) {
            return RecommendationCard(
              recommendation: recommendation,
              onTap: () => _navigateToPackageDetails(recommendation),
              onFavorite: () => _toggleFavorite(recommendation),
              onShare: () => _shareRecommendation(recommendation),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPopularRecommendations() {
    final popularRecs = _recommendations
        .where((rec) => rec.popularityScore > 0.7)
        .toList();
    
    return _buildRecommendationsList(popularRecs, '인기 추천이 없습니다');
  }

  Widget _buildNewRecommendations() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    final newRecs = _recommendations
        .where((rec) => rec.generatedAt.isAfter(thirtyDaysAgo))
        .toList();
    
    return _buildRecommendationsList(newRecs, '새로운 추천이 없습니다');
  }

  Widget _buildPremiumRecommendations() {
    final premiumRecs = _recommendations
        .where((rec) => rec.price > 500000)
        .toList();
    
    return _buildRecommendationsList(premiumRecs, '프리미엄 추천이 없습니다');
  }

  Widget _buildRecommendationsList(List<AIRecommendationModel> recommendations, String emptyMessage) {
    if (recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.travel_explore, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(emptyMessage),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: recommendations.map((recommendation) {
        return RecommendationCard(
          recommendation: recommendation,
          onTap: () => _navigateToPackageDetails(recommendation),
          onFavorite: () => _toggleFavorite(recommendation),
          onShare: () => _shareRecommendation(recommendation),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendationStats() {
    if (_recommendations.isEmpty) return const SizedBox.shrink();

    final totalRecommendations = _recommendations.length;
    final avgScore = _recommendations
        .map((r) => r.matchScore)
        .fold<double>(0.0, (sum, score) => sum + score) / totalRecommendations;
    final avgPrice = _recommendations
        .map((r) => r.price)
        .fold<double>(0.0, (sum, price) => sum + price) / totalRecommendations;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('총 추천', '$totalRecommendations개', Icons.recommend),
            _buildStatItem('평균 매치', '${(avgScore * 100).toInt()}%', Icons.percent),
            _buildStatItem('평균 가격', '₩${(avgPrice / 1000).toInt()}K', Icons.attach_money),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '필터 설정',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text('추천 전략', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('전체'),
                    selected: _selectedStrategy == 'all',
                    onSelected: (selected) {
                      setModalState(() => _selectedStrategy = 'all');
                    },
                  ),
                  ChoiceChip(
                    label: const Text('협업 필터링'),
                    selected: _selectedStrategy == 'collaborative',
                    onSelected: (selected) {
                      setModalState(() => _selectedStrategy = 'collaborative');
                    },
                  ),
                  ChoiceChip(
                    label: const Text('콘텐츠 기반'),
                    selected: _selectedStrategy == 'content',
                    onSelected: (selected) {
                      setModalState(() => _selectedStrategy = 'content');
                    },
                  ),
                  ChoiceChip(
                    label: const Text('인구통계학적'),
                    selected: _selectedStrategy == 'demographic',
                    onSelected: (selected) {
                      setModalState(() => _selectedStrategy = 'demographic');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('카테고리', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._filters.entries.map((entry) {
                return CheckboxListTile(
                  title: Text(_getFilterLabel(entry.key)),
                  value: entry.value,
                  onChanged: (value) {
                    setModalState(() => _filters[entry.key] = value ?? false);
                  },
                );
              }).toList(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedStrategy = 'all';
                          _filters.updateAll((key, value) => false);
                        });
                      },
                      child: const Text('초기화'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                        _loadRecommendations();
                      },
                      child: const Text('적용'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFilterLabel(String key) {
    switch (key) {
      case 'domestic':
        return '국내여행';
      case 'international':
        return '해외여행';
      case 'budget':
        return '저예산';
      case 'luxury':
        return '럭셔리';
      case 'family':
        return '가족여행';
      case 'solo':
        return '혼자여행';
      default:
        return key;
    }
  }

  void _navigateToPackageDetails(AIRecommendationModel recommendation) {
    Navigator.pushNamed(
      context,
      '/package-details',
      arguments: recommendation,
    );
  }

  void _toggleFavorite(AIRecommendationModel recommendation) {
    // TODO: Implement favorite toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${recommendation.packageTitle} 즐겨찾기에 추가했습니다'),
        action: SnackBarAction(
          label: '취소',
          onPressed: () {},
        ),
      ),
    );
  }

  void _shareRecommendation(AIRecommendationModel recommendation) {
    // TODO: Implement sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${recommendation.packageTitle} 공유 기능 준비 중'),
      ),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final AIRecommendationModel recommendation;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onTap,
    this.onFavorite,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    recommendation.packageImageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.textDisabled,
                        child: const Icon(Icons.image, size: 64),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary.withOpacity(0.54),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${(recommendation.matchScore * 100).toInt()}%',
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getReasonColor(recommendation.recommendationReason),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getReasonLabel(recommendation.recommendationReason),
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation.packageTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        recommendation.destination,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${recommendation.duration}일',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recommendation.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '₩${recommendation.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: onFavorite,
                        tooltip: '즐겨찾기',
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: onShare,
                        tooltip: '공유',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getReasonColor(RecommendationReason reason) {
    switch (reason) {
      case RecommendationReason.personalPreference:
        return AppColors.info;
      case RecommendationReason.similarUsers:
        return AppColors.success;
      case RecommendationReason.trending:
        return AppColors.warning;
      case RecommendationReason.newContent:
        return AppColors.primary;
      case RecommendationReason.priceMatch:
        return AppColors.danger;
      case RecommendationReason.locationBased:
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getReasonLabel(RecommendationReason reason) {
    switch (reason) {
      case RecommendationReason.personalPreference:
        return '취향 저격';
      case RecommendationReason.similarUsers:
        return '추천';
      case RecommendationReason.trending:
        return '인기';
      case RecommendationReason.newContent:
        return '신규';
      case RecommendationReason.priceMatch:
        return '가격';
      case RecommendationReason.locationBased:
        return '위치';
      default:
        return '일반';
    }
  }
}