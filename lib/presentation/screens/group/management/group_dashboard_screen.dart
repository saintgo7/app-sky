import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../data/models/group_model.dart';

class GroupDashboardScreen extends StatefulWidget {
  final String groupId;

  const GroupDashboardScreen({super.key, required this.groupId});

  @override
  State<GroupDashboardScreen> createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // State
  GroupModel? _groupInfo;
  List<GroupBookingModel> _bookings = [];
  List<GroupMemberModel> _members = [];
  List<GroupExpenseModel> _expenses = [];
  List<GroupCommunicationModel> _communications = [];
  DashboardStatsModel _stats = const DashboardStatsModel();
  bool _isLoading = true;
  
  // Dashboard tabs
  int _selectedPeriod = 0; // 0: 이번 달, 1: 지난 3개월, 2: 올해
  String _selectedMetric = 'bookings'; // bookings, revenue, members, expenses

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _groupInfo = _createMockGroup();
        _bookings = _createMockBookings();
        _members = _createMockMembers();
        _expenses = _createMockExpenses();
        _communications = _createMockCommunications();
        _stats = _calculateStats();
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
        title: Text(_groupInfo?.name ?? '단체 대시보드'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: AppColors.textLight 
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_report',
                child: Row(
                  children: [
                    Icon(Icons.assessment),
                    SizedBox(width: 8),
                    Text('보고서 내보내기'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('대시보드 설정'),
                  ],
                ),
              ),
            ],
            onSelected: _handleMenuAction,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: '개요'),
            Tab(icon: Icon(Icons.business_center), text: '예약 관리'),
            Tab(icon: Icon(Icons.people), text: '멤버 현황'),
            Tab(icon: Icon(Icons.analytics), text: '분석'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildBookingsTab(),
                _buildMembersTab(),
                _buildAnalyticsTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickActions,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickStats(),
            const SizedBox(height: 16),
            _buildRecentActivities(),
            const SizedBox(height: 16),
            _buildUpcomingEvents(),
            const SizedBox(height: 16),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '빠른 통계',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('총 예약', '${_stats.totalBookings}건', Icons.business_center, AppColors.info ),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('활성 멤버', '${_stats.activeMembers}명', Icons.people, AppColors.success ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildStatCard('이번 달 매출', '${_formatCurrency(_stats.monthlyRevenue)}', Icons.attach_money, AppColors.warning ),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('대기 중', '${_stats.pendingTasks}개', Icons.pending, AppColors.danger ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 활동',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('전체 보기'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._getRecentActivities().take(5).map((activity) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: activity.color,
                  child: Icon(activity.icon, color: AppColors.textLight  size: 16),
                ),
                title: Text(activity.title, style: const TextStyle(fontSize: 14)),
                subtitle: Text(activity.subtitle, style: const TextStyle(fontSize: 12)),
                trailing: Text(
                  activity.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary 
                      ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '다가오는 일정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ..._getUpcomingEvents().take(3).map((event) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textDisabled),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: event.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            event.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          event.date,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          event.time,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '빠른 작업',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildActionButton('새 예약', Icons.add_business, () => _createNewBooking()),
                _buildActionButton('멤버 초대', Icons.person_add, () => _inviteMember()),
                _buildActionButton('공지사항', Icons.campaign, () => _createAnnouncement()),
                _buildActionButton('보고서', Icons.assessment, () => _generateReport()),
                _buildActionButton('설정', Icons.settings, () => _openSettings()),
                _buildActionButton('도움말', Icons.help, () => _showHelp()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textDisabled),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).primaryColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsTab() {
    final activeBookings = _bookings.where((b) => b.status != 'completed' && b.status != 'cancelled').toList();
    
    return Column(
      children: [
        _buildBookingsHeader(activeBookings.length),
        Expanded(
          child: activeBookings.isEmpty
              ? _buildEmptyBookings()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeBookings.length,
                  itemBuilder: (context, index) {
                    final booking = activeBookings[index];
                    return _buildBookingCard(booking);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBookingsHeader(int activeCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textLight 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '활성 예약 ($activeCount건)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          FilterChip(
            label: const Text('전체'),
            selected: true,
            onSelected: (_) {},
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _createNewBooking,
            icon: const Icon(Icons.add),
            label: const Text('새 예약'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBookings() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.business_center_outlined, size: 64, color: AppColors.textSecondary ,
          const SizedBox(height: 16),
          Text(
            '활성 예약이 없습니다',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 여행 예약을 생성해보세요',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary 
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _createNewBooking,
            icon: const Icon(Icons.add),
            label: const Text('새 예약 생성'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(GroupBookingModel booking) {
    final statusColor = _getBookingStatusColor(booking.status);
    final daysUntilTravel = booking.travelStartDate.difference(DateTime.now()).inDays;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.packageTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getBookingStatusLabel(booking.status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${booking.totalParticipants}명'),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${_formatDate(booking.travelStartDate)} - ${_formatDate(booking.travelEndDate)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.attach_money, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(_formatCurrency(booking.pricing.totalPrice)),
                const Spacer(),
                if (daysUntilTravel > 0)
                  Text(
                    'D-$daysUntilTravel',
                    style: TextStyle(
                      color: daysUntilTravel <= 7 ? AppColors.danger : AppColors.warning 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewBookingDetails(booking),
                    child: const Text('상세 보기'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _manageBooking(booking),
                    child: const Text('관리'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersTab() {
    return Column(
      children: [
        _buildMembersHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _members.length,
            itemBuilder: (context, index) {
              final member = _members[index];
              return _buildMemberSummaryCard(member);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMembersHeader() {
    final activeMembers = _members.where((m) => m.status == MemberStatus.active).length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textLight 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '멤버 현황',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text('활성: $activeMembers명 / 전체: ${_members.length}명'),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _inviteMember,
            icon: const Icon(Icons.person_add),
            label: const Text('초대'),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberSummaryCard(GroupMemberModel member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(member.role),
          child: Text(
            member.name.isNotEmpty ? member.name[0] : 'U',
            style: const TextStyle(color: AppColors.textLight  fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(member.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.email),
            Text('역할: ${_getRoleLabel(member.role)}'),
          ],
        ),
        trailing: _buildMemberStatusChip(member.status),
        onTap: () => _viewMemberDetails(member),
      ),
    );
  }

  Widget _buildMemberStatusChip(MemberStatus status) {
    Color color;
    String label;
    
    switch (status) {
      case MemberStatus.active:
        color = AppColors.success 
        label = '활성';
        break;
      case MemberStatus.inactive:
        color = AppColors.textSecondary 
        label = '비활성';
        break;
      case MemberStatus.suspended:
        color = AppColors.danger 
        label = '정지';
        break;
      case MemberStatus.pending:
        color = AppColors.warning 
        label = '대기';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          _buildMetricsChart(),
          const SizedBox(height: 16),
          _buildExpenseBreakdown(),
          const SizedBox(height: 16),
          _buildPerformanceMetrics(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '분석 기간',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ToggleButtons(
              isSelected: [_selectedPeriod == 0, _selectedPeriod == 1, _selectedPeriod == 2],
              onPressed: (index) {
                setState(() => _selectedPeriod = index);
              },
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('이번 달')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('지난 3개월')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('올해')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주요 지표 추이',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt() + 1}월');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateChartData(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
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

  Widget _buildExpenseBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '비용 분석',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _generatePieChartData(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '성과 지표',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow('평균 예약 금액', _formatCurrency(_stats.averageBookingAmount), '전월 대비 +12%', AppColors.success ,
            _buildMetricRow('예약 완료율', '${_stats.bookingCompletionRate.toStringAsFixed(1)}%', '전월 대비 +2.3%', AppColors.success ,
            _buildMetricRow('멤버 참여율', '${_stats.memberEngagementRate.toStringAsFixed(1)}%', '전월 대비 -1.2%', AppColors.danger ,
            _buildMetricRow('고객 만족도', '${_stats.customerSatisfactionScore}/5.0', '전월 대비 +0.2', AppColors.success ,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, String change, Color changeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: changeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatCurrency(double amount) {
    return '₩${(amount / 10000).toStringAsFixed(0)}만원';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  Color _getBookingStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.success 
      case 'pending':
        return AppColors.warning 
      case 'cancelled':
        return AppColors.danger 
      case 'completed':
        return AppColors.info 
      default:
        return AppColors.textSecondary 
    }
  }

  String _getBookingStatusLabel(String status) {
    switch (status) {
      case 'confirmed':
        return '확정';
      case 'pending':
        return '대기';
      case 'cancelled':
        return '취소';
      case 'completed':
        return '완료';
      default:
        return status;
    }
  }

  Color _getRoleColor(GroupRole role) {
    switch (role) {
      case GroupRole.admin:
        return AppColors.danger 
      case GroupRole.manager:
        return AppColors.warning 
      case GroupRole.coordinator:
        return AppColors.info 
      case GroupRole.member:
        return AppColors.success 
      case GroupRole.viewer:
        return AppColors.textSecondary 
    }
  }

  String _getRoleLabel(GroupRole role) {
    switch (role) {
      case GroupRole.admin:
        return '관리자';
      case GroupRole.manager:
        return '매니저';
      case GroupRole.coordinator:
        return '코디네이터';
      case GroupRole.member:
        return '멤버';
      case GroupRole.viewer:
        return '뷰어';
    }
  }

  List<ActivityModel> _getRecentActivities() {
    return [
      ActivityModel(
        title: '새로운 예약이 생성되었습니다',
        subtitle: '제주도 3박 4일 - 김철수',
        time: '10분 전',
        icon: Icons.business_center,
        color: AppColors.info 
      ),
      ActivityModel(
        title: '멤버가 초대를 수락했습니다',
        subtitle: '이영희 - 마케팅팀',
        time: '1시간 전',
        icon: Icons.person_add,
        color: AppColors.success 
      ),
      ActivityModel(
        title: '공지사항이 발송되었습니다',
        subtitle: '여행 준비물 안내',
        time: '2시간 전',
        icon: Icons.campaign,
        color: AppColors.warning 
      ),
    ];
  }

  List<EventModel> _getUpcomingEvents() {
    return [
      EventModel(
        title: '제주도 여행 출발',
        description: '32명 참가',
        date: '12/25',
        time: '07:00',
        color: AppColors.info 
      ),
      EventModel(
        title: '부산 여행 최종 점검',
        description: '문서 확인 필요',
        date: '12/28',
        time: '14:00',
        color: AppColors.warning 
      ),
      EventModel(
        title: '신규 멤버 오리엔테이션',
        description: '5명 참석 예정',
        date: '01/03',
        time: '10:00',
        color: AppColors.success 
      ),
    ];
  }

  List<FlSpot> _generateChartData() {
    return [
      const FlSpot(0, 3),
      const FlSpot(1, 1),
      const FlSpot(2, 4),
      const FlSpot(3, 3),
      const FlSpot(4, 2),
      const FlSpot(5, 5),
    ];
  }

  List<PieChartSectionData> _generatePieChartData() {
    return [
      PieChartSectionData(
        color: AppColors.info 
        value: 40,
        title: '숙박\n40%',
        radius: 80,
      ),
      PieChartSectionData(
        color: AppColors.danger 
        value: 30,
        title: '교통\n30%',
        radius: 80,
      ),
      PieChartSectionData(
        color: AppColors.success 
        value: 20,
        title: '식사\n20%',
        radius: 80,
      ),
      PieChartSectionData(
        color: AppColors.warning 
        value: 10,
        title: '기타\n10%',
        radius: 80,
      ),
    ];
  }

  DashboardStatsModel _calculateStats() {
    return DashboardStatsModel(
      totalBookings: _bookings.length,
      activeMembers: _members.where((m) => m.status == MemberStatus.active).length,
      monthlyRevenue: _bookings.fold<double>(0, (sum, booking) => sum + booking.pricing.totalPrice),
      pendingTasks: 5,
      averageBookingAmount: _bookings.isEmpty ? 0 : 
          _bookings.fold<double>(0, (sum, booking) => sum + booking.pricing.totalPrice) / _bookings.length,
      bookingCompletionRate: 85.5,
      memberEngagementRate: 72.3,
      customerSatisfactionScore: 4.2,
    );
  }

  // Action handlers
  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_report':
        _exportReport();
        break;
      case 'settings':
        _openDashboardSettings();
        break;
    }
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '빠른 작업',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              childAspectRatio: 1,
              children: [
                _buildActionButton('새 예약', Icons.add_business, _createNewBooking),
                _buildActionButton('멤버 초대', Icons.person_add, _inviteMember),
                _buildActionButton('공지사항', Icons.campaign, _createAnnouncement),
                _buildActionButton('보고서', Icons.assessment, _generateReport),
                _buildActionButton('설정', Icons.settings, _openSettings),
                _buildActionButton('도움말', Icons.help, _showHelp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications() {
    // TODO: Show notifications
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알림 기능 구현 예정')),
    );
  }

  void _createNewBooking() {
    Navigator.pushNamed(context, '/group/booking/quotation', arguments: widget.groupId);
  }

  void _inviteMember() {
    // TODO: Show invite member dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('멤버 초대 기능 구현 예정')),
    );
  }

  void _createAnnouncement() {
    // TODO: Show create announcement dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공지사항 작성 기능 구현 예정')),
    );
  }

  void _generateReport() {
    // TODO: Generate and download report
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('보고서 생성 기능 구현 예정')),
    );
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/group/settings', arguments: widget.groupId);
  }

  void _showHelp() {
    // TODO: Show help dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('도움말 기능 구현 예정')),
    );
  }

  void _exportReport() {
    // TODO: Export comprehensive report
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('보고서 내보내기 기능 구현 예정')),
    );
  }

  void _openDashboardSettings() {
    // TODO: Open dashboard settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('대시보드 설정 기능 구현 예정')),
    );
  }

  void _viewBookingDetails(GroupBookingModel booking) {
    // TODO: Navigate to booking details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('예약 상세 기능 구현 예정')),
    );
  }

  void _manageBooking(GroupBookingModel booking) {
    // TODO: Navigate to booking management
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('예약 관리 기능 구현 예정')),
    );
  }

  void _viewMemberDetails(GroupMemberModel member) {
    // TODO: Navigate to member details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('멤버 상세 기능 구현 예정')),
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

  // Mock data creators
  GroupModel _createMockGroup() {
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
      departmentIds: ['dept_1', 'dept_2'],
      createdAt: '2024-01-01',
      updatedAt: '2024-01-01',
      createdBy: 'admin',
    );
  }

  List<GroupBookingModel> _createMockBookings() {
    return [
      GroupBookingModel(
        id: 'booking_1',
        groupId: widget.groupId,
        packageId: 'package_1',
        packageTitle: '제주도 3박 4일 힐링 여행',
        travelStartDate: DateTime.now().add(const Duration(days: 10)),
        travelEndDate: DateTime.now().add(const Duration(days: 13)),
        totalParticipants: 32,
        participants: [],
        pricing: const GroupPricingModel(
          basePrice: 5000000,
          groupDiscount: 500000,
          totalDiscount: 500000,
          subtotal: 4500000,
          taxes: 450000,
          totalPrice: 4950000,
          currency: 'KRW',
          breakdown: {},
          appliedDiscounts: [],
        ),
        customizations: {},
        requirements: {},
        status: 'confirmed',
        createdBy: 'admin',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<GroupMemberModel> _createMockMembers() {
    return [
      const GroupMemberModel(
        id: 'member_1',
        groupId: 'group_1',
        userId: 'user_1',
        departmentId: 'dept_1',
        role: GroupRole.admin,
        status: MemberStatus.active,
        name: '김관리',
        email: 'admin@samsung.com',
        phone: '010-1111-1111',
        position: '여행팀장',
        permissions: {},
        personalInfo: {},
        joinedAt: '2024-01-01',
        invitedBy: 'system',
      ),
      const GroupMemberModel(
        id: 'member_2',
        groupId: 'group_1',
        userId: 'user_2',
        departmentId: 'dept_2',
        role: GroupRole.member,
        status: MemberStatus.active,
        name: '이직원',
        email: 'employee@samsung.com',
        phone: '010-2222-2222',
        position: '사원',
        permissions: {},
        personalInfo: {},
        joinedAt: '2024-01-02',
        invitedBy: 'member_1',
      ),
    ];
  }

  List<GroupExpenseModel> _createMockExpenses() {
    return [];
  }

  List<GroupCommunicationModel> _createMockCommunications() {
    return [];
  }
}

// Supporting data models
class DashboardStatsModel {
  final int totalBookings;
  final int activeMembers;
  final double monthlyRevenue;
  final int pendingTasks;
  final double averageBookingAmount;
  final double bookingCompletionRate;
  final double memberEngagementRate;
  final double customerSatisfactionScore;

  const DashboardStatsModel({
    this.totalBookings = 0,
    this.activeMembers = 0,
    this.monthlyRevenue = 0,
    this.pendingTasks = 0,
    this.averageBookingAmount = 0,
    this.bookingCompletionRate = 0,
    this.memberEngagementRate = 0,
    this.customerSatisfactionScore = 0,
  });
}

class ActivityModel {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  ActivityModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class EventModel {
  final String title;
  final String description;
  final String date;
  final String time;
  final Color color;

  EventModel({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.color,
  });
}