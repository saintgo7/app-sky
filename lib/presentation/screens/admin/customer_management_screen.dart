import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/admin_auth_provider.dart';
import '../../widgets/admin/admin_navigation_layout.dart';
import '../../widgets/admin/permission_guard.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/booking_model.dart';
import '../../providers/customer_management_provider.dart';

class CustomerManagementScreen extends ConsumerStatefulWidget {
  const CustomerManagementScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends ConsumerState<CustomerManagementScreen> {
  final _searchController = TextEditingController();
  String? _selectedType;
  String? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminNavigationLayout(
      selectedRoute: '/admin/customers',
      child: PermissionGuard(
        permission: AdminPermissions.manageCustomers,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('고객 관리'),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => _exportCustomerData(context),
                tooltip: '고객 데이터 내보내기',
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Column(
            children: [
              _buildSearchBar(context),
              Expanded(
                child: ref.watch(customersProvider).when(
                  data: (customers) => _buildCustomersList(context, customers),
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
                        Text('오류: $error'),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => ref.refresh(customersProvider),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '이름, 이메일, 전화번호로 검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                ref.read(customerSearchProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: '고객 유형',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('전체')),
                const DropdownMenuItem(value: 'normal', child: Text('일반')),
                const DropdownMenuItem(value: 'vip', child: Text('VIP')),
                const DropdownMenuItem(value: 'corporate', child: Text('기업')),
                const DropdownMenuItem(value: 'government', child: Text('정부')),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value);
                ref.read(customerTypeFilterProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: '상태',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('전체')),
                const DropdownMenuItem(value: 'active', child: Text('활성')),
                const DropdownMenuItem(value: 'blacklist', child: Text('블랙리스트')),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value);
                ref.read(customerStatusFilterProvider.notifier).state = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersList(BuildContext context, List<UserModel> customers) {
    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '고객이 없습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => _showCustomerDetails(context, customer),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          customer.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  customer.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(width: 8),
                                if (customer.isVip ?? false)
                                  _buildVipBadge(context),
                                if (customer.isBlacklisted ?? false)
                                  _buildBlacklistBadge(context),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              customer.email,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (customer.phone != null)
                              Text(
                                customer.phone!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '가입일',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(customer.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        '총 예약',
                        '${customer.totalBookings ?? 0}건',
                        Icons.calendar_today,
                      ),
                      _buildStatItem(
                        context,
                        '총 구매액',
                        NumberFormat.currency(
                          locale: 'ko_KR',
                          symbol: '₩',
                        ).format(customer.totalSpent ?? 0),
                        Icons.attach_money,
                      ),
                      _buildStatItem(
                        context,
                        '마지막 활동',
                        customer.lastActivityAt != null
                            ? DateFormat('MM/dd').format(customer.lastActivityAt!)
                            : '-',
                        Icons.access_time,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _showBookingHistory(context, customer),
                        icon: const Icon(Icons.history),
                        label: const Text('예약 이력'),
                      ),
                      const SizedBox(width: 8),
                      if (!(customer.isVip ?? false))
                        OutlinedButton.icon(
                          onPressed: () => _toggleVipStatus(context, customer),
                          icon: const Icon(Icons.star_outline),
                          label: const Text('VIP 지정'),
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: () => _toggleVipStatus(context, customer),
                          icon: const Icon(Icons.star),
                          label: const Text('VIP 해제'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.amber,
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (!(customer.isBlacklisted ?? false))
                        OutlinedButton.icon(
                          onPressed: () => _toggleBlacklistStatus(context, customer),
                          icon: const Icon(Icons.block),
                          label: const Text('블랙리스트'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.error,
                          ),
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: () => _toggleBlacklistStatus(context, customer),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('블랙리스트 해제'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:  AppColors.success 
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVipBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: Colors.amber),
          SizedBox(width: 4),
          Text(
            'VIP',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlacklistBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.error),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.block,
            size: 14,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 4),
          Text(
            '차단',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _showCustomerDetails(BuildContext context, UserModel customer) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 800),
          child: CustomerDetailDialog(customer: customer),
        ),
      ),
    );
  }

  Future<void> _showBookingHistory(BuildContext context, UserModel customer) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 800,
          constraints: const BoxConstraints(maxHeight: 600),
          child: BookingHistoryDialog(customer: customer),
        ),
      ),
    );
  }

  Future<void> _toggleVipStatus(BuildContext context, UserModel customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer.isVip ?? false ? 'VIP 해제' : 'VIP 지정'),
        content: Text(
          customer.isVip ?? false
              ? '${customer.name}님의 VIP 상태를 해제하시겠습니까?'
              : '${customer.name}님을 VIP로 지정하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('확인'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(customerManagementProvider.notifier).updateVipStatus(
          customer.id,
          !(customer.isVip ?? false),
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                customer.isVip ?? false
                    ? 'VIP 상태가 해제되었습니다'
                    : 'VIP로 지정되었습니다',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('오류가 발생했습니다: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _toggleBlacklistStatus(BuildContext context, UserModel customer) async {
    if (customer.isBlacklisted ?? false) {
      // Remove from blacklist
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('블랙리스트 해제'),
          content: Text('${customer.name}님을 블랙리스트에서 해제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('해제'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        try {
          await ref.read(customerManagementProvider.notifier).removeFromBlacklist(customer.id);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('블랙리스트에서 해제되었습니다')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('오류가 발생했습니다: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      }
    } else {
      // Add to blacklist
      String? reason;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('블랙리스트 등록'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${customer.name}님을 블랙리스트에 등록하시겠습니까?'),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '사유',
                    hintText: '블랙리스트 등록 사유를 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) => reason = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('등록'),
              ),
            ],
          );
        },
      );

      if (confirmed == true && reason != null && reason!.isNotEmpty) {
        try {
          await ref.read(customerManagementProvider.notifier).addToBlacklist(
            customer.id,
            reason!,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('블랙리스트에 등록되었습니다')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('오류가 발생했습니다: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> _exportCustomerData(BuildContext context) async {
    // Implementation for exporting customer data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('고객 데이터 내보내기 기능 구현 예정')),
    );
  }
}

// Customer detail dialog
class CustomerDetailDialog extends ConsumerWidget {
  final UserModel customer;

  const CustomerDetailDialog({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${customer.name} 고객 정보'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer information sections
            _buildSection(
              context,
              '기본 정보',
              Column(
                children: [
                  _buildInfoRow('이름', customer.name),
                  _buildInfoRow('이메일', customer.email),
                  if (customer.phone != null)
                    _buildInfoRow('전화번호', customer.phone!),
                  _buildInfoRow('가입일', DateFormat('yyyy-MM-dd HH:mm').format(customer.createdAt)),
                  _buildInfoRow('회원 유형', _getUserTypeLabel(customer.role)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '활동 통계',
              Column(
                children: [
                  _buildInfoRow('총 예약', '${customer.totalBookings ?? 0}건'),
                  _buildInfoRow(
                    '총 구매액',
                    NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(customer.totalSpent ?? 0),
                  ),
                  if (customer.lastActivityAt != null)
                    _buildInfoRow(
                      '마지막 활동',
                      DateFormat('yyyy-MM-dd HH:mm').format(customer.lastActivityAt!),
                    ),
                ],
              ),
            ),
            if (customer.corporateName != null) ...[
              const SizedBox(height: 24),
              _buildSection(
                context,
                '기업 정보',
                Column(
                  children: [
                    _buildInfoRow('기업명', customer.corporateName!),
                    if (customer.department != null)
                      _buildInfoRow('부서', customer.department!),
                    if (customer.position != null)
                      _buildInfoRow('직책', customer.position!),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color:  AppColors.textSecondary 
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getUserTypeLabel(UserRole role) {
    switch (role) {
      case UserRole.user:
        return '일반 회원';
      case UserRole.groupAdmin:
        return '그룹 관리자';
      case UserRole.admin:
        return '관리자';
      case UserRole.superAdmin:
        return '최고 관리자';
    }
  }
}

// Booking history dialog
class BookingHistoryDialog extends ConsumerWidget {
  final UserModel customer;

  const BookingHistoryDialog({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${customer.name} 예약 이력'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ref.watch(customerBookingsProvider(customer.id)).when(
        data: (bookings) => _buildBookingsList(context, bookings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류: $error'),
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return const Center(
        child: Text('예약 이력이 없습니다'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(booking.status).withOpacity(0.2),
              child: Icon(
                _getStatusIcon(booking.status),
                color: _getStatusColor(booking.status),
              ),
            ),
            title: Text(booking.packageName ?? '상품명 없음'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('yyyy-MM-dd HH:mm').format(booking.createdAt)),
                Text(
                  NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(booking.totalAmount),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Chip(
              label: Text(_getStatusLabel(booking.status)),
              backgroundColor: _getStatusColor(booking.status).withOpacity(0.1),
              labelStyle: TextStyle(
                color: _getStatusColor(booking.status),
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return  AppColors.success 
      case 'pending':
        return  AppColors.warning 
      case 'cancelled':
        return  AppColors.danger 
      case 'completed':
        return  AppColors.info 
      default:
        return  AppColors.textSecondary 
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return '확정';
      case 'pending':
        return '대기중';
      case 'cancelled':
        return '취소';
      case 'completed':
        return '완료';
      default:
        return status;
    }
  }
}