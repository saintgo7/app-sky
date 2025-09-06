import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_dashboard_provider.dart';
import '../../providers/admin_auth_provider.dart';
import '../../widgets/admin/admin_navigation_layout.dart';
import '../../widgets/admin/permission_guard.dart';
import '../../../data/models/admin_dashboard_model.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdminNavigationLayout(
      selectedRoute: '/admin/dashboard',
      child: PermissionGuard(
        permission: AdminPermissions.viewDashboard,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('관리자 대시보드'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.read(adminDashboardProvider.notifier).refreshDashboardData();
                },
                tooltip: '새로고침',
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: ref.watch(adminDashboardProvider).when(
            data: (dashboardData) => _buildDashboard(context, dashboardData),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '데이터를 불러올 수 없습니다',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      ref.read(adminDashboardProvider.notifier).loadDashboardData();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AdminDashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Cards Row
          _buildStatisticsCards(context, data),
          const SizedBox(height: 24),
          
          // Charts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildRevenueChart(context, data.revenueStats),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildAIPerformanceCard(context, data.aiStats),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Tables Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildRecentBookingsTable(context, data.recentBookings),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildPendingInquiriesTable(context, data.pendingInquiries),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(BuildContext context, AdminDashboardData data) {
    final stats = [
      _StatCard(
        title: '오늘 예약',
        value: data.bookingStats.todayBookings.toString(),
        subtitle: '전일 대비 ${data.bookingStats.bookingGrowthRate > 0 ? '+' : ''}${data.bookingStats.bookingGrowthRate.toStringAsFixed(1)}%',
        icon: Icons.calendar_today,
        color: Colors.blue,
        trend: data.bookingStats.bookingGrowthRate,
      ),
      _StatCard(
        title: '오늘 매출',
        value: NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(data.revenueStats.todayRevenue),
        subtitle: '전일 대비 ${data.revenueStats.revenueGrowthRate > 0 ? '+' : ''}${data.revenueStats.revenueGrowthRate.toStringAsFixed(1)}%',
        icon: Icons.attach_money,
        color: Colors.green,
        trend: data.revenueStats.revenueGrowthRate,
      ),
      _StatCard(
        title: '신규 고객',
        value: data.customerStats.newCustomersToday.toString(),
        subtitle: '총 ${NumberFormat('#,###').format(data.customerStats.totalCustomers)}명',
        icon: Icons.person_add,
        color: Colors.orange,
        trend: data.customerStats.customerGrowthRate,
      ),
      _StatCard(
        title: 'AI 전환율',
        value: '${data.aiStats.conversionRate.toStringAsFixed(1)}%',
        subtitle: '${NumberFormat('#,###').format(data.aiStats.acceptedRecommendations)} / ${NumberFormat('#,###').format(data.aiStats.totalRecommendations)}',
        icon: Icons.psychology,
        color: Colors.purple,
        trend: 0,
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: stats.map((stat) => SizedBox(
        width: MediaQuery.of(context).size.width > 1400 
          ? (MediaQuery.of(context).size.width - 48 - 48) / 4 
          : (MediaQuery.of(context).size.width - 48 - 16) / 2,
        child: stat,
      )).toList(),
    );
  }

  Widget _buildRevenueChart(BuildContext context, RevenueStatistics revenueStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '매출 추이',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < revenueStats.dailyRevenue.length) {
                            final date = revenueStats.dailyRevenue[value.toInt()].date;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('MM/dd').format(date),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1000000,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000000).toStringAsFixed(0)}M',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: revenueStats.dailyRevenue.length - 1.0,
                  minY: 0,
                  maxY: revenueStats.dailyRevenue.map((e) => e.revenue).reduce((a, b) => a > b ? a : b) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: revenueStats.dailyRevenue.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.revenue);
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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

  Widget _buildAIPerformanceCard(BuildContext context, AIRecommendationStats aiStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI 추천 성과',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            _buildMetricRow(
              context,
              '전환율',
              '${aiStats.conversionRate.toStringAsFixed(1)}%',
              Icons.trending_up,
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              context,
              '평균 주문 금액',
              NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(aiStats.averageOrderValue),
              Icons.payments,
              Colors.blue,
            ),
            const SizedBox(height: 24),
            Text(
              '카테고리별 추천',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...aiStats.recommendationsByCategory.entries.map((entry) {
              final total = aiStats.recommendationsByCategory.values.reduce((a, b) => a + b);
              final percentage = (entry.value / total * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text('$percentage%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / total,
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
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

  Widget _buildMetricRow(BuildContext context, String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBookingsTable(BuildContext context, List<RecentBooking> bookings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 예약',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to bookings
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('전체 보기'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('고객명')),
                  DataColumn(label: Text('상품')),
                  DataColumn(label: Text('금액')),
                  DataColumn(label: Text('상태')),
                  DataColumn(label: Text('날짜')),
                ],
                rows: bookings.take(5).map((booking) {
                  return DataRow(cells: [
                    DataCell(Text(booking.customerName)),
                    DataCell(Text(booking.productName)),
                    DataCell(Text(NumberFormat.currency(
                      locale: 'ko_KR',
                      symbol: '₩',
                    ).format(booking.amount))),
                    DataCell(_buildStatusChip(context, booking.status)),
                    DataCell(Text(DateFormat('MM/dd HH:mm').format(booking.createdAt))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingInquiriesTable(BuildContext context, List<CustomerInquiry> inquiries) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '고객 문의',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to inquiries
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('전체 보기'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('고객명')),
                  DataColumn(label: Text('제목')),
                  DataColumn(label: Text('우선순위')),
                  DataColumn(label: Text('날짜')),
                ],
                rows: inquiries.where((i) => !i.isResolved).take(5).map((inquiry) {
                  return DataRow(cells: [
                    DataCell(Text(inquiry.customerName)),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          inquiry.subject,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(_buildPriorityChip(context, inquiry.priority)),
                    DataCell(Text(DateFormat('MM/dd HH:mm').format(inquiry.createdAt))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color color;
    String label;
    
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = Colors.green;
        label = '확정';
        break;
      case 'pending':
        color = Colors.orange;
        label = '대기중';
        break;
      case 'cancelled':
        color = Colors.red;
        label = '취소';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildPriorityChip(BuildContext context, String priority) {
    Color color;
    String label;
    
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        label = '높음';
        break;
      case 'medium':
        color = Colors.orange;
        label = '보통';
        break;
      case 'low':
        color = Colors.blue;
        label = '낮음';
        break;
      default:
        color = Colors.grey;
        label = priority;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double trend;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                if (trend != 0)
                  Icon(
                    trend > 0 ? Icons.trending_up : Icons.trending_down,
                    color: trend > 0 ? Colors.green : Colors.red,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}