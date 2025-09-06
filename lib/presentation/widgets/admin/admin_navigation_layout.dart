import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_auth_provider.dart';

class AdminNavigationLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String selectedRoute;

  const AdminNavigationLayout({
    Key? key,
    required this.child,
    required this.selectedRoute,
  }) : super(key: key);

  @override
  ConsumerState<AdminNavigationLayout> createState() => _AdminNavigationLayoutState();
}

class _AdminNavigationLayoutState extends ConsumerState<AdminNavigationLayout> {
  @override
  Widget build(BuildContext context) {
    final adminAuth = ref.watch(adminAuthProvider);
    final hasPermission = ref.read(adminAuthProvider.notifier).hasPermission;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 1200,
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedIndex: _getSelectedIndex(),
            onDestinationSelected: (index) => _navigateToRoute(index),
            labelType: NavigationRailLabelType.none,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'TravelMate',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Admin',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (adminAuth.user != null) ...[
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            adminAuth.user!.name[0].toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          adminAuth.user!.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          _getRoleDisplayName(adminAuth.user!.role),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => _handleLogout(),
                        tooltip: '로그아웃',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            destinations: [
              if (hasPermission(AdminPermissions.viewDashboard))
                const NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('대시보드'),
                ),
              if (hasPermission(AdminPermissions.manageProducts))
                const NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: Text('상품 관리'),
                ),
              if (hasPermission(AdminPermissions.manageCustomers))
                const NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('고객 관리'),
                ),
              if (hasPermission(AdminPermissions.viewAnalytics))
                const NavigationRailDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: Text('통계 분석'),
                ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex() {
    final routes = [
      '/admin/dashboard',
      '/admin/products',
      '/admin/customers',
      '/admin/analytics',
    ];
    final index = routes.indexOf(widget.selectedRoute);
    return index >= 0 ? index : 0;
  }

  void _navigateToRoute(int index) {
    final routes = [
      '/admin/dashboard',
      '/admin/products',
      '/admin/customers',
      '/admin/analytics',
    ];
    if (index < routes.length) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return '최고 관리자';
      case UserRole.admin:
        return '관리자';
      case UserRole.groupAdmin:
        return '그룹 관리자';
      default:
        return '사용자';
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(adminAuthProvider.notifier).logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
}