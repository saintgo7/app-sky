import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 내역'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: authProvider.isAuthenticated
          ? _buildBookingList()
          : _buildLoginPrompt(context),
    );
  }

  Widget _buildBookingList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Card
        Card(
          color: AppColors.primaryLight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '예약 요약',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('진행 중', '2', Icons.schedule),
                    _buildSummaryItem('완료', '5', Icons.check_circle),
                    _buildSummaryItem('취소', '1', Icons.cancel),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Booking List Header
        const Text(
          '예약 목록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Mock Bookings
        _buildBookingCard(
          '서울 → 도쿄',
          '2024년 12월 25일',
          '항공편',
          Icons.flight,
          '진행 중',
          AppColors.info,
        ),
        _buildBookingCard(
          '힐튼 도쿄',
          '2024년 12월 25일 - 12월 28일',
          '호텔',
          Icons.hotel,
          '진행 중',
          AppColors.info,
        ),
        _buildBookingCard(
          '후지산 투어',
          '2024년 12월 26일',
          '액티비티',
          Icons.local_activity,
          '완료',
          AppColors.success,
        ),
        _buildBookingCard(
          '방콕 패키지',
          '2024년 11월 15일',
          '패키지',
          Icons.card_travel,
          '완료',
          AppColors.success,
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(
    String title,
    String date,
    String type,
    IconData icon,
    String status,
    Color statusColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login,
            size: 80,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            '예약 내역을 확인하려면\n로그인이 필요합니다',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }
}
