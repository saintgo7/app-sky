import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_router.dart';

class TravelBottomNavigation extends StatefulWidget {
  final int currentIndex;

  const TravelBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  State<TravelBottomNavigation> createState() => _TravelBottomNavigationState();
}

class _TravelBottomNavigationState extends State<TravelBottomNavigation> {
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        AppRouter.goHome();
        break;
      case 1:
        AppRouter.goSearch();
        break;
      case 2:
        AppRouter.goBookings();
        break;
      case 3:
        AppRouter.goProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: '예약',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}

class TravelScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBottomNavigation;
  final int currentIndex;

  const TravelScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showBottomNavigation = true,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNavigation
          ? TravelBottomNavigation(currentIndex: currentIndex)
          : null,
    );
  }
}
