import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'flights';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '목적지, 호텔, 액티비티 검색...',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Tab Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTabChip('flights', '항공편', Icons.flight),
                  const SizedBox(width: 8),
                  _buildTabChip('hotels', '호텔', Icons.hotel),
                  const SizedBox(width: 8),
                  _buildTabChip('packages', '패키지', Icons.card_travel),
                  const SizedBox(width: 8),
                  _buildTabChip('activities', '액티비티', Icons.local_activity),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Results
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String value, String label, IconData icon) {
    final isSelected = _selectedTab == value;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedTab = value;
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.textDisabled),
            const SizedBox(height: 16),
            Text(
              '검색어를 입력하세요',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Mock search results
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForTab(),
                color: AppColors.primary,
              ),
            ),
            title: Text('검색 결과 ${index + 1}'),
            subtitle: Text('$_selectedTab 관련 정보'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to detail screen
            },
          ),
        );
      },
    );
  }

  IconData _getIconForTab() {
    switch (_selectedTab) {
      case 'flights':
        return Icons.flight;
      case 'hotels':
        return Icons.hotel;
      case 'packages':
        return Icons.card_travel;
      case 'activities':
        return Icons.local_activity;
      default:
        return Icons.search;
    }
  }
}
