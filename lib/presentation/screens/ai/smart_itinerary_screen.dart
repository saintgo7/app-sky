import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../services/ai/recommendation/itinerary_generator.dart';
import '../../../services/ai/profiling/user_preference_analyzer.dart';
import '../../../services/ai/profiling/travel_style_classifier.dart';
import '../../../services/ai/profiling/budget_analyzer.dart';

class SmartItineraryScreen extends StatefulWidget {
  final String? destination;
  final DateTime? startDate;
  final int? durationDays;

  const SmartItineraryScreen({
    super.key,
    this.destination,
    this.startDate,
    this.durationDays,
  });

  @override
  State<SmartItineraryScreen> createState() => _SmartItineraryScreenState();
}

class _SmartItineraryScreenState extends State<SmartItineraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  
  // Form data
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  DateTime? _selectedDate;
  int _duration = 3;
  int _travelers = 2;
  ItineraryOptimizationGoal _goal = ItineraryOptimizationGoal.balanced;
  
  // State
  bool _isGenerating = false;
  GeneratedItinerary? _currentItinerary;
  List<GeneratedItinerary> _alternatives = [];
  
  // Animation controllers
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    // Initialize with provided data
    if (widget.destination != null) {
      _destinationController.text = widget.destination!;
    }
    if (widget.startDate != null) {
      _selectedDate = widget.startDate;
    }
    if (widget.durationDays != null) {
      _duration = widget.durationDays!;
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _tabController.dispose();
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text('AI 일정 생성'),
              pinned: true,
              floating: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
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
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.edit), text: '설정'),
                  Tab(icon: Icon(Icons.schedule), text: '일정'),
                ],
              ),
              actions: [
                if (_currentItinerary != null)
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareItinerary,
                  ),
              ],
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSetupTab(),
            _buildItineraryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDestinationSection(),
            const SizedBox(height: 24),
            _buildDateSection(),
            const SizedBox(height: 24),
            _buildDurationSection(),
            const SizedBox(height: 24),
            _buildTravelersSection(),
            const SizedBox(height: 24),
            _buildGoalSection(),
            const SizedBox(height: 32),
            _buildGenerateButton(),
            if (_alternatives.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildAlternativesSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '여행 목적지',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: '목적지',
                hintText: '예: 제주도, 일본, 태국 등',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '목적지를 입력해주세요';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '여행 날짜',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: '출발일',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _selectedDate != null
                      ? DateFormat('yyyy년 M월 d일').format(_selectedDate!)
                      : '날짜를 선택하세요',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '여행 기간',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _duration.toDouble(),
                    min: 1,
                    max: 14,
                    divisions: 13,
                    label: '$_duration일',
                    onChanged: (value) {
                      setState(() => _duration = value.toInt());
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$_duration일',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '여행 인원',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: _travelers > 1 ? () => setState(() => _travelers--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Expanded(
                  child: Text(
                    '$_travelers명',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: _travelers < 10 ? () => setState(() => _travelers++) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '최적화 목표',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ItineraryOptimizationGoal.values.map((goal) {
                return ChoiceChip(
                  label: Text(_getGoalLabel(goal)),
                  selected: _goal == goal,
                  onSelected: (selected) {
                    if (selected) setState(() => _goal = goal);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isGenerating ? null : _generateItinerary,
        icon: _isGenerating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.auto_fix_high),
        label: Text(_isGenerating ? '생성 중...' : 'AI 일정 생성'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAlternativesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '다른 옵션들',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _alternatives.length,
                itemBuilder: (context, index) {
                  final alternative = _alternatives[index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      child: InkWell(
                        onTap: () => _selectAlternative(alternative),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGoalLabel(alternative.optimizationGoal),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${alternative.totalActivities}개 활동',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '₩${(alternative.totalCost / 1000).toInt()}K',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const Spacer(),
                              LinearProgressIndicator(
                                value: alternative.feasibilityScore,
                                backgroundColor: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '실현가능성 ${(alternative.feasibilityScore * 100).toInt()}%',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryTab() {
    if (_currentItinerary == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('아직 생성된 일정이 없습니다'),
            SizedBox(height: 8),
            Text('설정 탭에서 일정을 생성해주세요'),
          ],
        ),
      );
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          _buildItineraryHeader(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _currentItinerary!.days.length,
              itemBuilder: (context, index) {
                return _buildDayItinerary(_currentItinerary!.days[index]);
              },
            ),
          ),
          _buildItineraryNavigation(),
        ],
      ),
    );
  }

  Widget _buildItineraryHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _destinationController.text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(_currentItinerary!.feasibilityScore * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildItineraryMetric(
                '총 비용',
                '₩${(_currentItinerary!.totalCost / 1000).toInt()}K',
                Icons.attach_money,
              ),
              _buildItineraryMetric(
                '활동 수',
                '${_currentItinerary!.totalActivities}개',
                Icons.local_activity,
              ),
              _buildItineraryMetric(
                '평균 점수',
                '${(_currentItinerary!.metrics['averageRating'] * 10).toInt() / 10}',
                Icons.star,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItinerary(ItineraryDay day) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.dayNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('M월 d일 (E)', 'ko_KR').format(day.date),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            day.theme,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₩${(day.totalCost / 1000).toInt()}K',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${day.totalDuration.inHours}시간',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...day.activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          return Column(
            children: [
              ActivityCard(
                activity: activity,
                onTap: () => _showActivityDetails(activity),
              ),
              if (index < day.transportSegments.length) ...[
                const SizedBox(height: 8),
                TransportCard(segment: day.transportSegments[index]),
                const SizedBox(height: 8),
              ],
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildItineraryNavigation() {
    if (_currentItinerary == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _currentItinerary!.days.asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  return GestureDetector(
                    onTap: () => _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Day ${day.dayNumber}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.small(
            onPressed: _optimizeItinerary,
            tooltip: '일정 최적화',
            child: const Icon(Icons.tune),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _generateItinerary() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필수 항목을 입력해주세요')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final itineraryGenerator = context.read<ItineraryGenerator>();
      
      // Generate main itinerary
      final itinerary = await itineraryGenerator.generateItinerary(
        destination: _destinationController.text,
        startDate: _selectedDate!,
        durationDays: _duration,
        travelers: _travelers,
        goal: _goal,
      );

      // Generate alternatives
      final alternatives = await itineraryGenerator.generateAlternatives(
        destination: _destinationController.text,
        startDate: _selectedDate!,
        durationDays: _duration,
        travelers: _travelers,
        alternativeCount: 3,
      );

      setState(() {
        _currentItinerary = itinerary;
        _alternatives = alternatives;
      });

      _slideController.forward();
      _tabController.animateTo(1);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일정 생성 실패: $e')),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  void _selectAlternative(GeneratedItinerary alternative) {
    setState(() => _currentItinerary = alternative);
    _slideController.reset();
    _slideController.forward();
  }

  Future<void> _optimizeItinerary() async {
    if (_currentItinerary == null) return;

    // TODO: Show optimization options dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 최적화'),
        content: const Text('어떤 방식으로 최적화하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement optimization
            },
            child: const Text('최적화'),
          ),
        ],
      ),
    );
  }

  void _shareItinerary() {
    // TODO: Implement sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('일정 공유 기능 준비 중')),
    );
  }

  void _showActivityDetails(ItineraryActivity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ActivityDetailsSheet(activity: activity),
    );
  }

  String _getGoalLabel(ItineraryOptimizationGoal goal) {
    switch (goal) {
      case ItineraryOptimizationGoal.timeOptimized:
        return '시간 최적화';
      case ItineraryOptimizationGoal.costOptimized:
        return '비용 최적화';
      case ItineraryOptimizationGoal.experienceOptimized:
        return '경험 최적화';
      case ItineraryOptimizationGoal.balanced:
        return '균형잡힌';
      case ItineraryOptimizationGoal.cultural:
        return '문화 중심';
      case ItineraryOptimizationGoal.adventure:
        return '모험 중심';
      case ItineraryOptimizationGoal.relaxation:
        return '휴식 중심';
    }
  }
}

class ActivityCard extends StatelessWidget {
  final ItineraryActivity activity;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getCategoryColor(activity.category),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(activity.category),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${activity.estimatedDuration.inHours}시간 ${activity.estimatedDuration.inMinutes % 60}분',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          '₩${activity.cost.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cultural':
        return Colors.purple;
      case 'culinary':
        return Colors.orange;
      case 'adventure':
        return Colors.green;
      case 'wellness':
        return Colors.blue;
      case 'shopping':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cultural':
        return Icons.museum;
      case 'culinary':
        return Icons.restaurant;
      case 'adventure':
        return Icons.hiking;
      case 'wellness':
        return Icons.spa;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.place;
    }
  }
}

class TransportCard extends StatelessWidget {
  final TransportSegment segment;

  const TransportCard({
    super.key,
    required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            _getTransportIcon(segment.mode),
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.instructions,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${segment.duration.inMinutes}분 • ₩${segment.cost.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTransportIcon(TransportMode mode) {
    switch (mode) {
      case TransportMode.walking:
        return Icons.directions_walk;
      case TransportMode.publicTransport:
        return Icons.directions_transit;
      case TransportMode.taxi:
        return Icons.local_taxi;
      case TransportMode.rental:
        return Icons.directions_car;
      case TransportMode.tour:
        return Icons.tour;
    }
  }
}

class ActivityDetailsSheet extends StatelessWidget {
  final ItineraryActivity activity;

  const ActivityDetailsSheet({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                activity.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                activity.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              _buildDetailItem(
                Icons.access_time,
                '예상 소요시간',
                '${activity.estimatedDuration.inHours}시간 ${activity.estimatedDuration.inMinutes % 60}분',
              ),
              _buildDetailItem(
                Icons.attach_money,
                '비용',
                '₩${activity.cost.toStringAsFixed(0)}',
              ),
              _buildDetailItem(
                Icons.star,
                '평점',
                '${activity.rating} (${activity.reviewCount}개 리뷰)',
              ),
              _buildDetailItem(
                Icons.category,
                '카테고리',
                activity.category,
              ),
              if (activity.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '태그',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: activity.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}