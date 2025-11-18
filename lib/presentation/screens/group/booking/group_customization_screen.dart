import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/group_model.dart';

class GroupCustomizationScreen extends StatefulWidget {
  final String groupId;
  final String quotationId;

  const GroupCustomizationScreen({
    super.key,
    required this.groupId,
    required this.quotationId,
  });

  @override
  State<GroupCustomizationScreen> createState() => _GroupCustomizationScreenState();
}

class _GroupCustomizationScreenState extends State<GroupCustomizationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // State
  bool _isLoading = true;
  bool _isSaving = false;
  GroupQuotationModel? _quotation;
  List<GroupParticipantModel> _participants = [];
  Map<String, dynamic> _customizations = {};
  Map<String, List<String>> _roomAssignments = {};
  Map<String, String> _mealPreferences = {};
  List<CustomItineraryItem> _customItinerary = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Load from backend
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _quotation = _createMockQuotation();
        _participants = _createMockParticipants();
        _customizations = _createMockCustomizations();
        _roomAssignments = _createMockRoomAssignments();
        _mealPreferences = _createMockMealPreferences();
        _customItinerary = _createMockItinerary();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 상세 설정'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: AppColors.textLight 
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCustomizations,
          ),
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: _previewBooking,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.schedule), text: '일정'),
            Tab(icon: Icon(Icons.hotel), text: '숙박'),
            Tab(icon: Icon(Icons.restaurant), text: '식사'),
            Tab(icon: Icon(Icons.settings), text: '기타'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildQuotationSummary(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildItineraryTab(),
                      _buildAccommodationTab(),
                      _buildMealTab(),
                      _buildOtherSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildQuotationSummary() {
    if (_quotation == null) return const SizedBox.shrink();
    
    return Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _quotation!.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${_quotation!.participantCount}명 • ${_quotation!.duration}일',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(_quotation!.pricing.totalPrice),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '1인 ${_formatCurrency(_quotation!.pricing.totalPrice / _quotation!.participantCount)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            '일정 커스터마이징',
            '기본 일정을 수정하거나 새로운 활동을 추가할 수 있습니다',
          ),
          const SizedBox(height: 16),
          ..._customItinerary.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildItineraryItemCard(item, index);
          }).toList(),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              onPressed: _addItineraryItem,
              icon: const Icon(Icons.add),
              label: const Text('새 일정 추가'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryItemCard(CustomItineraryItem item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}일차',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        item.date,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('수정'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy),
                          SizedBox(width: 8),
                          Text('복제'),
                        ],
                      ),
                    ),
                    if (_customItinerary.length > 1)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppColors.danger ,
                            SizedBox(width: 8),
                            Text('삭제', style: TextStyle(color: AppColors.danger ),
                          ],
                        ),
                      ),
                  ],
                  onSelected: (value) => _handleItineraryAction(item, value as String, index),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...item.activities.map((activity) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getActivityIcon(activity.type),
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${activity.startTime} - ${activity.endTime}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          if (activity.description.isNotEmpty)
                            Text(
                              activity.description,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (activity.additionalCost > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${_formatCurrency(activity.additionalCost)}',
                          style: const TextStyle(
                            color: AppColors.warning 
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _addActivityToDay(index),
              icon: const Icon(Icons.add),
              label: const Text('활동 추가'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccommodationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            '숙박 배정',
            '참가자들의 룸메이트를 배정하고 특별 요청사항을 설정하세요',
          ),
          const SizedBox(height: 16),
          _buildRoomTypeSelection(),
          const SizedBox(height: 16),
          _buildRoomAssignmentOptions(),
          const SizedBox(height: 16),
          _buildRoomAssignmentList(),
          const SizedBox(height: 16),
          _buildSpecialRequests(),
        ],
      ),
    );
  }

  Widget _buildRoomTypeSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '객실 타입',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildRoomTypeChip('스탠다드 트윈', 2, 0),
                _buildRoomTypeChip('스탠다드 더블', 2, 10000),
                _buildRoomTypeChip('디럭스 트윈', 2, 20000),
                _buildRoomTypeChip('디럭스 더블', 2, 30000),
                _buildRoomTypeChip('싱글룸', 1, 15000),
                _buildRoomTypeChip('트리플룸', 3, -5000),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomTypeChip(String roomType, int capacity, double additionalCost) {
    final isSelected = _customizations['roomType'] == roomType;
    
    return InkWell(
      onTap: () {
        setState(() {
          _customizations['roomType'] = roomType;
          _customizations['roomCapacity'] = capacity;
          _customizations['roomAdditionalCost'] = additionalCost;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : AppColors.textDisabled,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              roomType,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
            ),
            Text(
              '$capacity명',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            if (additionalCost != 0)
              Text(
                '${additionalCost > 0 ? '+' : ''}${_formatCurrency(additionalCost)}',
                style: TextStyle(
                  fontSize: 12,
                  color: additionalCost > 0 ? AppColors.danger : AppColors.success 
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomAssignmentOptions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '배정 방식',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            RadioListTile<String>(
              title: const Text('자동 배정'),
              subtitle: const Text('시스템이 자동으로 룸메이트를 배정합니다'),
              value: 'auto',
              groupValue: _customizations['assignmentMethod'],
              onChanged: (value) {
                setState(() {
                  _customizations['assignmentMethod'] = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('부서별 배정'),
              subtitle: const Text('같은 부서끼리 배정합니다'),
              value: 'department',
              groupValue: _customizations['assignmentMethod'],
              onChanged: (value) {
                setState(() {
                  _customizations['assignmentMethod'] = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('수동 배정'),
              subtitle: const Text('직접 룸메이트를 지정합니다'),
              value: 'manual',
              groupValue: _customizations['assignmentMethod'],
              onChanged: (value) {
                setState(() {
                  _customizations['assignmentMethod'] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomAssignmentList() {
    if (_customizations['assignmentMethod'] != 'manual') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.info.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.info.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: AppColors.info ,
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _customizations['assignmentMethod'] == 'auto'
                    ? '체크인 시 자동으로 배정됩니다'
                    : '부서별로 자동 배정됩니다',
                style: TextStyle(color: AppColors.info ,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '룸 배정 현황',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _autoAssignRooms,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('자동 배정'),
                ),
                TextButton.icon(
                  onPressed: _shuffleRooms,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('셔플'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._roomAssignments.entries.map((entry) {
              final roomNumber = entry.key;
              final participants = entry.value;
              return _buildRoomCard(roomNumber, participants);
            }).toList(),
            const SizedBox(height: 8),
            Center(
              child: OutlinedButton.icon(
                onPressed: _addRoom,
                icon: const Icon(Icons.add),
                label: const Text('객실 추가'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(String roomNumber, List<String> participantIds) {
    final participants = _participants.where(
      (p) => participantIds.contains(p.id),
    ).toList();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.hotel, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  roomNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${participants.length}명',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showRoomOptions(roomNumber),
                ),
              ],
            ),
            if (participants.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: participants.map((participant) {
                  return Chip(
                    avatar: CircleAvatar(
                      backgroundColor: AppColors.textDisabled,
                      child: Text(participant.name[0]),
                    ),
                    label: Text(participant.name),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeFromRoom(roomNumber, participant.id),
                  );
                }).toList(),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.textDisabled,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Text(
                    '참가자를 드래그하여 배정하세요',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialRequests() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '특별 요청사항',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('금연실 요청'),
              subtitle: const Text('모든 객실을 금연실로 요청'),
              value: _customizations['nonSmoking'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['nonSmoking'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('높은 층 선호'),
              subtitle: const Text('가능한 높은 층 객실 요청'),
              value: _customizations['highFloor'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['highFloor'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('조용한 객실'),
              subtitle: const Text('엘리베이터, 아이스머신에서 멀리'),
              value: _customizations['quietRoom'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['quietRoom'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '기타 요청사항',
                hintText: '호텔에 전달할 특별 요청사항을 입력하세요',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _customizations['additionalRequests'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            '식사 옵션',
            '참가자별 식사 선호도와 알레르기 정보를 관리하세요',
          ),
          const SizedBox(height: 16),
          _buildMealPlanSelection(),
          const SizedBox(height: 16),
          _buildDietaryRestrictions(),
          const SizedBox(height: 16),
          _buildParticipantMealPreferences(),
        ],
      ),
    );
  }

  Widget _buildMealPlanSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '식사 플랜',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...{
              'none': {'label': '식사 미포함', 'cost': 0},
              'breakfast': {'label': '조식만', 'cost': 15000},
              'half': {'label': '조식 + 석식', 'cost': 35000},
              'full': {'label': '3식 포함', 'cost': 50000},
            }.entries.map((entry) {
              final isSelected = _customizations['mealPlan'] == entry.key;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _customizations['mealPlan'] = entry.key;
                      _customizations['mealCost'] = entry.value['cost'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).primaryColor
                            : AppColors.textDisabled,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: entry.key,
                          groupValue: _customizations['mealPlan'],
                          onChanged: (value) {
                            setState(() {
                              _customizations['mealPlan'] = value;
                              _customizations['mealCost'] = entry.value['cost'];
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            entry.value['label'] as String,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          entry.value['cost'] as int > 0
                              ? '+${_formatCurrency((entry.value['cost'] as int).toDouble())}'
                              : '무료',
                          style: TextStyle(
                            color: entry.value['cost'] as int > 0
                                ? AppColors.warning
                                : AppColors.success 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryRestrictions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '식이 제한사항',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '할랄', '코셔', '채식', '비건', '글루텐 프리', '유당불내증',
                '견과류 알레르기', '해산물 알레르기', '달걀 알레르기'
              ].map((restriction) {
                final isSelected = (_customizations['dietaryRestrictions'] as List<String>? ?? [])
                    .contains(restriction);
                return FilterChip(
                  label: Text(restriction),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      final restrictions = _customizations['dietaryRestrictions'] as List<String>? ?? [];
                      if (selected) {
                        restrictions.add(restriction);
                      } else {
                        restrictions.remove(restriction);
                      }
                      _customizations['dietaryRestrictions'] = restrictions;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '기타 식이 제한사항',
                hintText: '추가적인 식이 제한사항을 입력하세요',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _customizations['additionalDietaryInfo'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantMealPreferences() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '참가자별 식사 선호도',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _bulkUpdateMealPreferences,
                  icon: const Icon(Icons.edit),
                  label: const Text('일괄 수정'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _participants.length,
              itemBuilder: (context, index) {
                final participant = _participants[index];
                return _buildParticipantMealCard(participant);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantMealCard(GroupParticipantModel participant) {
    final preference = _mealPreferences[participant.id] ?? 'none';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(participant.name[0]),
        ),
        title: Text(participant.name),
        subtitle: Text(participant.email),
        trailing: DropdownButton<String>(
          value: preference,
          items: const [
            DropdownMenuItem(value: 'none', child: Text('제한 없음')),
            DropdownMenuItem(value: 'vegetarian', child: Text('채식')),
            DropdownMenuItem(value: 'vegan', child: Text('비건')),
            DropdownMenuItem(value: 'halal', child: Text('할랄')),
            DropdownMenuItem(value: 'kosher', child: Text('코셔')),
            DropdownMenuItem(value: 'gluten_free', child: Text('글루텐 프리')),
            DropdownMenuItem(value: 'allergy', child: Text('알레르기 있음')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _mealPreferences[participant.id] = value;
              });
              if (value == 'allergy') {
                _showAllergyDialog(participant);
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildOtherSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransportationSettings(),
          const SizedBox(height: 16),
          _buildInsuranceSettings(),
          const SizedBox(height: 16),
          _buildEmergencyContacts(),
          const SizedBox(height: 16),
          _buildAdditionalServices(),
        ],
      ),
    );
  }

  Widget _buildTransportationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '교통편 설정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('공항 픽업 서비스'),
              subtitle: const Text('도착 시 공항에서 호텔까지'),
              value: _customizations['airportPickup'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['airportPickup'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('공항 드롭오프 서비스'),
              subtitle: const Text('출발 시 호텔에서 공항까지'),
              value: _customizations['airportDropoff'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['airportDropoff'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('전용 버스 이용'),
              subtitle: const Text('일정 중 전용 버스 이용'),
              value: _customizations['privateBus'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['privateBus'] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '여행자 보험',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('기본 보험'),
              subtitle: const Text('기본적인 의료비 및 사고 보상'),
              value: 'basic',
              groupValue: _customizations['insuranceLevel'],
              onChanged: (value) {
                setState(() {
                  _customizations['insuranceLevel'] = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('종합 보험'),
              subtitle: const Text('의료비, 여행 취소, 수하물 분실 등 종합 보상'),
              value: 'comprehensive',
              groupValue: _customizations['insuranceLevel'],
              onChanged: (value) {
                setState(() {
                  _customizations['insuranceLevel'] = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('보험 미가입'),
              subtitle: const Text('별도 보험 없음'),
              value: 'none',
              groupValue: _customizations['insuranceLevel'],
              onChanged: (value) {
                setState(() {
                  _customizations['insuranceLevel'] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '비상 연락처',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addEmergencyContact,
                  icon: const Icon(Icons.add),
                  label: const Text('추가'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '현지 가이드 연락처',
                hintText: '+82 10-0000-0000',
                prefixIcon: Icon(Icons.contact_phone),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _customizations['guideContact'] = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '여행사 24시간 핫라인',
                hintText: '+82 2-0000-0000',
                prefixIcon: Icon(Icons.support_agent),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _customizations['hotlineContact'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalServices() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '부가 서비스',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('전문 가이드'),
              subtitle: const Text('현지 전문 가이드 동반'),
              value: _customizations['professionalGuide'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['professionalGuide'] = value;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('사진 촬영 서비스'),
              subtitle: const Text('전문 사진작가 동반'),
              value: _customizations['photographyService'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['photographyService'] = value;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Wi-Fi 포켓'),
              subtitle: const Text('휴대용 Wi-Fi 대여'),
              value: _customizations['pocketWifi'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['pocketWifi'] = value;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('짐 배송 서비스'),
              subtitle: const Text('공항-호텔 간 짐 배송'),
              value: _customizations['luggageService'] ?? false,
              onChanged: (value) {
                setState(() {
                  _customizations['luggageService'] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textLight 
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _saveDraft,
              child: const Text('임시저장'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : _proceedToDataEntry,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('참가자 정보 입력'),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatCurrency(double amount) {
    return '${(amount / 1000).toStringAsFixed(0)}K원';
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'sightseeing':
        return Icons.camera_alt;
      case 'meal':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_bus;
      case 'hotel':
        return Icons.hotel;
      case 'activity':
        return Icons.local_activity;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.place;
    }
  }

  // Mock data creators
  GroupQuotationModel _createMockQuotation() {
    return GroupQuotationModel(
      id: 'quotation_1',
      title: '제주도 3박4일 단체 여행',
      participantCount: 30,
      duration: 4,
      discountRate: 10.0,
      status: '승인됨',
      pricing: const GroupPricingModel(
        basePrice: 1500000.0,
        groupDiscount: 150000.0,
        totalDiscount: 200000.0,
        subtotal: 1300000.0,
        taxes: 130000.0,
        totalPrice: 1430000.0,
        currency: 'KRW',
        breakdown: {},
        appliedDiscounts: [],
      ),
    );
  }

  List<GroupParticipantModel> _createMockParticipants() {
    return List.generate(30, (index) {
      return GroupParticipantModel(
        id: 'participant_$index',
        bookingId: 'booking_1',
        memberId: 'member_$index',
        name: '참가자${index + 1}',
        email: 'participant${index + 1}@company.com',
        phone: '010-${1000 + index}-0000',
        personalInfo: {},
        preferences: {},
        requirements: {},
        roomAssignment: '',
        status: 'confirmed',
        registeredAt: DateTime.now(),
      );
    });
  }

  Map<String, dynamic> _createMockCustomizations() {
    return {
      'roomType': '스탠다드 트윈',
      'roomCapacity': 2,
      'roomAdditionalCost': 0.0,
      'assignmentMethod': 'auto',
      'mealPlan': 'breakfast',
      'mealCost': 15000,
      'dietaryRestrictions': <String>[],
      'insuranceLevel': 'basic',
      'airportPickup': true,
      'airportDropoff': true,
    };
  }

  Map<String, List<String>> _createMockRoomAssignments() {
    return {
      'Room 101': ['participant_0', 'participant_1'],
      'Room 102': ['participant_2', 'participant_3'],
      'Room 103': ['participant_4', 'participant_5'],
    };
  }

  Map<String, String> _createMockMealPreferences() {
    return {
      'participant_0': 'vegetarian',
      'participant_1': 'none',
      'participant_2': 'halal',
    };
  }

  List<CustomItineraryItem> _createMockItinerary() {
    return [
      CustomItineraryItem(
        date: '2024-03-01',
        activities: [
          ItineraryActivity(
            type: 'transportation',
            title: '김포공항 출발',
            startTime: '08:00',
            endTime: '09:30',
            description: '김포공항에서 제주공항으로 이동',
            additionalCost: 0,
          ),
          ItineraryActivity(
            type: 'hotel',
            title: '호텔 체크인',
            startTime: '11:00',
            endTime: '12:00',
            description: '제주 그랜드 호텔 체크인',
            additionalCost: 0,
          ),
          ItineraryActivity(
            type: 'meal',
            title: '점심 식사',
            startTime: '12:30',
            endTime: '14:00',
            description: '제주 흑돼지 맛집',
            additionalCost: 0,
          ),
          ItineraryActivity(
            type: 'sightseeing',
            title: '성산일출봉',
            startTime: '15:00',
            endTime: '17:00',
            description: '세계자연유산 성산일출봉 관람',
            additionalCost: 5000,
          ),
        ],
      ),
      CustomItineraryItem(
        date: '2024-03-02',
        activities: [
          ItineraryActivity(
            type: 'meal',
            title: '호텔 조식',
            startTime: '07:00',
            endTime: '09:00',
            description: '호텔 뷔페 조식',
            additionalCost: 0,
          ),
          ItineraryActivity(
            type: 'sightseeing',
            title: '한라산 국립공원',
            startTime: '09:30',
            endTime: '15:00',
            description: '한라산 어리목 탐방로 트레킹',
            additionalCost: 0,
          ),
        ],
      ),
    ];
  }

  // Action handlers
  void _handleItineraryAction(CustomItineraryItem item, String action, int index) {
    switch (action) {
      case 'edit':
        _editItineraryItem(item, index);
        break;
      case 'duplicate':
        _duplicateItineraryItem(item, index);
        break;
      case 'delete':
        _deleteItineraryItem(index);
        break;
    }
  }

  void _editItineraryItem(CustomItineraryItem item, int index) {
    // TODO: Show edit dialog
  }

  void _duplicateItineraryItem(CustomItineraryItem item, int index) {
    setState(() {
      _customItinerary.insert(index + 1, item);
    });
  }

  void _deleteItineraryItem(int index) {
    setState(() {
      _customItinerary.removeAt(index);
    });
  }

  void _addItineraryItem() {
    // TODO: Show add dialog
  }

  void _addActivityToDay(int dayIndex) {
    // TODO: Show activity selection dialog
  }

  void _autoAssignRooms() {
    // TODO: Implement auto room assignment
  }

  void _shuffleRooms() {
    // TODO: Implement room shuffling
  }

  void _addRoom() {
    // TODO: Add new room
  }

  void _showRoomOptions(String roomNumber) {
    // TODO: Show room options
  }

  void _removeFromRoom(String roomNumber, String participantId) {
    setState(() {
      _roomAssignments[roomNumber]?.remove(participantId);
    });
  }

  void _bulkUpdateMealPreferences() {
    // TODO: Show bulk update dialog
  }

  void _showAllergyDialog(GroupParticipantModel participant) {
    // TODO: Show allergy information dialog
  }

  void _addEmergencyContact() {
    // TODO: Show add emergency contact dialog
  }

  Future<void> _saveCustomizations() async {
    setState(() => _isSaving = true);

    try {
      // TODO: Save customizations to backend
      await Future.delayed(const Duration(seconds: 2));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('설정이 저장되었습니다'),
          backgroundColor: AppColors.success 
        ),
      );
    } catch (e) {
      _showErrorDialog('저장 중 오류가 발생했습니다: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _saveDraft() {
    // TODO: Save as draft
  }

  void _previewBooking() {
    // TODO: Show booking preview
  }

  void _proceedToDataEntry() {
    Navigator.pushNamed(
      context,
      '/group/booking/bulk-data-entry',
      arguments: {
        'groupId': widget.groupId,
        'quotationId': widget.quotationId,
        'customizations': _customizations,
      },
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

// Supporting classes
class CustomItineraryItem {
  final String date;
  final List<ItineraryActivity> activities;

  CustomItineraryItem({
    required this.date,
    required this.activities,
  });
}

class ItineraryActivity {
  final String type;
  final String title;
  final String startTime;
  final String endTime;
  final String description;
  final double additionalCost;

  ItineraryActivity({
    required this.type,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.additionalCost,
  });
}