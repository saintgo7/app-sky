import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/group_model.dart';
import '../../../../data/models/travel_package_model.dart';

class GroupQuotationScreen extends StatefulWidget {
  final String groupId;
  final String? packageId;

  const GroupQuotationScreen({
    super.key,
    required this.groupId,
    this.packageId,
  });

  @override
  State<GroupQuotationScreen> createState() => _GroupQuotationScreenState();
}

class _GroupQuotationScreenState extends State<GroupQuotationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _participantCountController = TextEditingController();
  final _budgetController = TextEditingController();
  
  // State
  bool _isLoading = false;
  bool _isGeneratingQuotation = false;
  GroupModel? _groupInfo;
  List<TravelPackageModel> _availablePackages = [];
  List<GroupQuotationModel> _quotations = [];
  
  // Form data
  DateTime? _startDate;
  DateTime? _endDate;
  int _participantCount = 20;
  double? _targetBudget;
  String _destination = '';
  List<String> _selectedActivities = [];
  Map<String, dynamic> _requirements = {};
  Map<String, dynamic> _preferences = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _participantCountController.text = _participantCount.toString();
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _participantCountController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Load from backend
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _groupInfo = _createMockGroupInfo();
        _availablePackages = _createMockPackages();
        _isLoading = false;
      });
      
      if (widget.packageId != null) {
        final package = _availablePackages.firstWhere(
          (p) => p.id == widget.packageId,
          orElse: () => _availablePackages.first,
        );
        _selectPackage(package);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단체 견적 요청'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: AppColors.textLight 
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDraft,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: '기본 설정'),
            Tab(icon: Icon(Icons.travel_explore), text: '패키지 선택'),
            Tab(icon: Icon(Icons.receipt), text: '견적서'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicSettingsTab(),
                  _buildPackageSelectionTab(),
                  _buildQuotationTab(),
                ],
              ),
            ),
    );
  }

  Widget _buildBasicSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupInfoCard(),
          const SizedBox(height: 16),
          _buildBasicRequirementsCard(),
          const SizedBox(height: 16),
          _buildDateSelectionCard(),
          const SizedBox(height: 16),
          _buildParticipantCountCard(),
          const SizedBox(height: 16),
          _buildBudgetCard(),
          const SizedBox(height: 16),
          _buildRequirementsCard(),
        ],
      ),
    );
  }

  Widget _buildGroupInfoCard() {
    if (_groupInfo == null) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getGroupTypeIcon(_groupInfo!.type),
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _groupInfo!.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getGroupTypeLabel(_groupInfo!.type),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
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
                Icon(Icons.person, size: 16, color: AppColors.textSecondary ,
                const SizedBox(width: 4),
                Text(
                  _groupInfo!.contactPerson,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.email, size: 16, color: AppColors.textSecondary ,
                const SizedBox(width: 4),
                Text(
                  _groupInfo!.contactEmail,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicRequirementsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기본 요구사항',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '희망 여행지 *',
                hintText: '예: 제주도, 일본, 동남아시아',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _destination = value,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '여행지를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              '희망 활동 (복수 선택 가능)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                '관광', '문화체험', '자연탐방', '휴양', '모험', '맛집탐방',
                '쇼핑', '교육', '팀빌딩', '워크샵'
              ].map((activity) {
                return FilterChip(
                  label: Text(activity),
                  selected: _selectedActivities.contains(activity),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedActivities.add(activity);
                      } else {
                        _selectedActivities.remove(activity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '여행 일정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectStartDate(),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '출발일 *',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _startDate != null
                            ? DateFormat('yyyy-MM-dd').format(_startDate!)
                            : '날짜를 선택하세요',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectEndDate(),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '복귀일 *',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _endDate != null
                            ? DateFormat('yyyy-MM-dd').format(_endDate!)
                            : '날짜를 선택하세요',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_startDate != null && _endDate != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '총 ${_endDate!.difference(_startDate!).inDays + 1}일 여행',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantCountCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '참가 인원',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _participantCountController,
                    decoration: const InputDecoration(
                      labelText: '총 인원 *',
                      hintText: '예: 50',
                      prefixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(),
                      suffix: Text('명'),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      final count = int.tryParse(value) ?? 0;
                      setState(() => _participantCount = count);
                    },
                    validator: (value) {
                      final count = int.tryParse(value ?? '') ?? 0;
                      if (count < 10) {
                        return '최소 10명 이상이어야 합니다';
                      }
                      if (count > 1000) {
                        return '최대 1000명까지 가능합니다';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDiscountInfo(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGroupSizeRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountInfo() {
    final discountRate = _calculateGroupDiscountRate(_participantCount);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: discountRate > 0 ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: discountRate > 0 ? AppColors.success : AppColors.textDisabled,
        ),
      ),
      child: Column(
        children: [
          Icon(
            discountRate > 0 ? Icons.discount : Icons.info,
            color: discountRate > 0 ? AppColors.success : AppColors.textSecondary 
          ),
          const SizedBox(height: 4),
          Text(
            '단체 할인',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            discountRate > 0 ? '${discountRate.toInt()}%' : '없음',
            style: TextStyle(
              color: discountRate > 0 ? AppColors.success : AppColors.textSecondary 
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSizeRecommendations() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.info  size: 20),
              const SizedBox(width: 8),
              Text(
                '인원수별 혜택',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.info 
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...{
            20: '• 20명 이상: 5% 할인',
            30: '• 30명 이상: 10% 할인 + 무료 가이드',
            50: '• 50명 이상: 15% 할인 + 전용 버스',
            100: '• 100명 이상: 20% 할인 + 맞춤 일정',
          }.entries.map((entry) {
            final isActive = _participantCount >= entry.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                entry.value,
                style: TextStyle(
                  color: isActive ? AppColors.info : AppColors.textSecondary 
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBudgetCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '예산 설정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: '1인당 예산 (선택사항)',
                hintText: '예: 500000',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
                suffix: Text('원'),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                _targetBudget = double.tryParse(value);
              },
            ),
            const SizedBox(height: 16),
            _buildBudgetRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetRecommendations() {
    final recommendations = {
      '경제형': {'min': 200000, 'max': 500000, 'description': '기본적인 숙박과 식사'},
      '표준형': {'min': 500000, 'max': 1000000, 'description': '편안한 숙박과 다양한 활동'},
      '프리미엄': {'min': 1000000, 'max': 2000000, 'description': '고급 숙박과 특별한 경험'},
      '럭셔리': {'min': 2000000, 'max': 5000000, 'description': '최고급 서비스와 VIP 대우'},
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '예산별 추천',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        ...recommendations.entries.map((entry) {
          final isSelected = _targetBudget != null &&
              _targetBudget! >= entry.value['min'] as double &&
              _targetBudget! <= entry.value['max'] as double;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).primaryColor
                    : AppColors.textDisabled,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Theme.of(context).primaryColor : null,
                        ),
                      ),
                      Text(
                        '${_formatCurrency(entry.value['min'] as double)} - ${_formatCurrency(entry.value['max'] as double)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isSelected ? Theme.of(context).primaryColor : AppColors.textSecondary 
                            ),
                      ),
                      Text(
                        entry.value['description'] as String,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildRequirementsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '특별 요구사항',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('휠체어 접근성'),
              subtitle: const Text('휠체어 이용 가능한 시설'),
              value: _requirements['wheelchair'] ?? false,
              onChanged: (value) {
                setState(() {
                  _requirements['wheelchair'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('할랄 식단'),
              subtitle: const Text('무슬림 식단 요구사항'),
              value: _requirements['halal'] ?? false,
              onChanged: (value) {
                setState(() {
                  _requirements['halal'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('채식 식단'),
              subtitle: const Text('채식주의자 식단'),
              value: _requirements['vegetarian'] ?? false,
              onChanged: (value) {
                setState(() {
                  _requirements['vegetarian'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('알레르기 대응'),
              subtitle: const Text('음식 알레르기 정보 필요'),
              value: _requirements['allergy'] ?? false,
              onChanged: (value) {
                setState(() {
                  _requirements['allergy'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '기타 요구사항',
                hintText: '추가 요청사항이 있으시면 자세히 적어주세요',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _requirements['additional'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageSelectionTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(color: AppColors.textDisabled),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isGeneratingQuotation ? null : _generateQuotations,
                  icon: _isGeneratingQuotation
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_fix_high),
                  label: Text(_isGeneratingQuotation ? '견적 생성 중...' : 'AI 맞춤 견적 생성'),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: _showPackageFilters,
                icon: const Icon(Icons.filter_list),
                label: const Text('필터'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _availablePackages.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.travel_explore, size: 64, color: AppColors.textSecondary ,
                      SizedBox(height: 16),
                      Text('사용 가능한 패키지가 없습니다'),
                      SizedBox(height: 8),
                      Text('조건을 변경하거나 AI 견적 생성을 이용해보세요'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _availablePackages.length,
                  itemBuilder: (context, index) {
                    final package = _availablePackages[index];
                    return _buildPackageCard(package);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPackageCard(TravelPackageModel package) {
    final groupPrice = _calculateGroupPrice(package);
    final discountRate = _calculateGroupDiscountRate(_participantCount);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  package.mainImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.textDisabled,
                      child: const Icon(Icons.image, size: 64),
                    );
                  },
                ),
              ),
              if (discountRate > 0)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.danger 
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${discountRate.toInt()}% 할인',
                      style: const TextStyle(
                        color: AppColors.textLight 
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${package.duration}일',
                    style: const TextStyle(
                      color: AppColors.textLight 
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
                  package.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: AppColors.textSecondary ,
                    const SizedBox(width: 4),
                    Text(
                      package.destination,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary 
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  package.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (discountRate > 0) ...[
                            Text(
                              '개별: ${_formatCurrency(package.pricing.basePrice)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.textSecondary 
                                  ),
                            ),
                          ],
                          Text(
                            '1인: ${_formatCurrency(groupPrice.perPerson)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '총액: ${_formatCurrency(groupPrice.totalPrice)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectPackage(package),
                      child: const Text('선택'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationTab() {
    if (_quotations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 64, color: AppColors.textSecondary ,
            const SizedBox(height: 16),
            const Text('생성된 견적서가 없습니다'),
            const SizedBox(height: 8),
            const Text('패키지를 선택하거나 AI 견적 생성을 이용해보세요'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.travel_explore),
              label: const Text('패키지 선택하기'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _quotations.length,
      itemBuilder: (context, index) {
        final quotation = _quotations[index];
        return _buildQuotationCard(quotation);
      },
    );
  }

  Widget _buildQuotationCard(GroupQuotationModel quotation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    quotation.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getQuotationStatusColor(quotation.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    quotation.status,
                    style: const TextStyle(
                      color: AppColors.textLight 
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildQuotationSummary(quotation),
            const SizedBox(height: 16),
            _buildPricingBreakdown(quotation.pricing),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showQuotationDetails(quotation),
                    icon: const Icon(Icons.visibility),
                    label: const Text('상세보기'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _downloadQuotation(quotation),
                    icon: const Icon(Icons.download),
                    label: const Text('다운로드'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _proceedToBooking(quotation),
                    icon: const Icon(Icons.check),
                    label: const Text('예약진행'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotationSummary(GroupQuotationModel quotation) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem('참가자', '${quotation.participantCount}명', Icons.people),
          ),
          Expanded(
            child: _buildSummaryItem('기간', '${quotation.duration}일', Icons.schedule),
          ),
          Expanded(
            child: _buildSummaryItem('할인율', '${quotation.discountRate}%', Icons.discount),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildPricingBreakdown(GroupPricingModel pricing) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textDisabled),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildPriceRow('기본 요금', pricing.basePrice, false),
          if (pricing.groupDiscount > 0)
            _buildPriceRow('단체 할인', -pricing.groupDiscount, false, isDiscount: true),
          if (pricing.totalDiscount > pricing.groupDiscount)
            _buildPriceRow('추가 할인', -(pricing.totalDiscount - pricing.groupDiscount), false, isDiscount: true),
          _buildPriceRow('소계', pricing.subtotal, false),
          _buildPriceRow('세금/수수료', pricing.taxes, false),
          const Divider(),
          _buildPriceRow('총 금액', pricing.totalPrice, true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, bool isTotal, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}${_formatCurrency(amount.abs())}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount ? AppColors.danger : (isTotal ? Theme.of(context).primaryColor : null),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  double _calculateGroupDiscountRate(int participantCount) {
    if (participantCount >= 100) return 20.0;
    if (participantCount >= 50) return 15.0;
    if (participantCount >= 30) return 10.0;
    if (participantCount >= 20) return 5.0;
    return 0.0;
  }

  GroupPriceResult _calculateGroupPrice(TravelPackageModel package) {
    final basePrice = package.pricing.basePrice;
    final discountRate = _calculateGroupDiscountRate(_participantCount);
    final discountAmount = basePrice * (discountRate / 100);
    final perPersonPrice = basePrice - discountAmount;
    final totalPrice = perPersonPrice * _participantCount;
    
    return GroupPriceResult(
      perPerson: perPersonPrice,
      totalPrice: totalPrice,
      discountAmount: discountAmount * _participantCount,
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat('#,###').format(amount) + '원';
  }

  IconData _getGroupTypeIcon(GroupType type) {
    switch (type) {
      case GroupType.corporate:
        return Icons.business;
      case GroupType.government:
        return Icons.account_balance;
      case GroupType.school:
      case GroupType.university:
        return Icons.school;
      case GroupType.ngo:
        return Icons.volunteer_activism;
    }
  }

  String _getGroupTypeLabel(GroupType type) {
    switch (type) {
      case GroupType.corporate:
        return '기업';
      case GroupType.government:
        return '관공서';
      case GroupType.school:
        return '초중고';
      case GroupType.university:
        return '대학교';
      case GroupType.ngo:
        return '비영리단체';
    }
  }

  Color _getQuotationStatusColor(String status) {
    switch (status) {
      case '생성됨':
        return AppColors.info 
      case '검토중':
        return AppColors.warning 
      case '승인됨':
        return AppColors.success 
      case '거절됨':
        return AppColors.danger 
      default:
        return AppColors.textSecondary 
    }
  }

  // Mock data creators
  GroupModel _createMockGroupInfo() {
    return const GroupModel(
      id: 'group_1',
      name: '삼성전자',
      description: '글로벌 기술 선도기업',
      type: GroupType.corporate,
      status: GroupStatus.active,
      organizationNumber: '124-81-00998',
      address: '경기도 수원시 영통구 삼성로 129',
      contactPerson: '김여행',
      contactPhone: '010-1234-5678',
      contactEmail: 'travel@samsung.com',
      settings: {},
      departmentIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: 'admin',
    );
  }

  List<TravelPackageModel> _createMockPackages() {
    // Return mock travel packages
    return [];
  }

  // Action methods
  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _startDate = date;
        if (_endDate != null && _endDate!.isBefore(date)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 출발일을 선택해주세요')),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(const Duration(days: 3)),
      firstDate: _startDate!.add(const Duration(days: 1)),
      lastDate: _startDate!.add(const Duration(days: 30)),
    );
    
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  Future<void> _generateQuotations() async {
    if (!_formKey.currentState!.validate() || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필수 정보를 입력해주세요')),
      );
      return;
    }

    setState(() => _isGeneratingQuotation = true);

    try {
      // TODO: Generate quotations using AI
      await Future.delayed(const Duration(seconds: 3));
      
      setState(() {
        _quotations = _createMockQuotations();
        _isGeneratingQuotation = false;
      });

      _tabController.animateTo(2);
    } catch (e) {
      setState(() => _isGeneratingQuotation = false);
      _showErrorDialog('견적 생성 중 오류가 발생했습니다: $e');
    }
  }

  List<GroupQuotationModel> _createMockQuotations() {
    // Return mock quotations
    return [];
  }

  void _selectPackage(TravelPackageModel package) {
    // TODO: Generate quotation for selected package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${package.title} 패키지가 선택되었습니다')),
    );
  }

  void _showPackageFilters() {
    // TODO: Show package filters dialog
  }

  void _showQuotationDetails(GroupQuotationModel quotation) {
    // TODO: Show quotation details
  }

  void _downloadQuotation(GroupQuotationModel quotation) {
    // TODO: Download quotation as PDF
  }

  void _proceedToBooking(GroupQuotationModel quotation) {
    // TODO: Navigate to booking customization screen
    Navigator.pushNamed(
      context,
      '/group/booking/customization',
      arguments: {
        'groupId': widget.groupId,
        'quotationId': quotation.id,
      },
    );
  }

  void _saveDraft() {
    // TODO: Save current form as draft
  }

  void _showHelp() {
    // TODO: Show help dialog
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

// Supporting classes
class GroupPriceResult {
  final double perPerson;
  final double totalPrice;
  final double discountAmount;

  GroupPriceResult({
    required this.perPerson,
    required this.totalPrice,
    required this.discountAmount,
  });
}

class GroupQuotationModel {
  final String id;
  final String title;
  final int participantCount;
  final int duration;
  final double discountRate;
  final String status;
  final GroupPricingModel pricing;

  GroupQuotationModel({
    required this.id,
    required this.title,
    required this.participantCount,
    required this.duration,
    required this.discountRate,
    required this.status,
    required this.pricing,
  });
}