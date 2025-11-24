import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_router.dart';
import '../widgets/travel_card.dart';
import '../widgets/bottom_navigation.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TravelScaffold(
      currentIndex: 3,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Profile Info
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.textLight.withOpacity(0.2),
                            border: Border.all(
                              color: AppColors.textLight,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.textLight,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '김철수',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'kim@example.com',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textLight.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '이메일 인증됨',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textLight.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Edit Button
                        IconButton(
                          onPressed: () {
                            // 프로필 편집
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Stats Cards
                    Row(
                      children: [
                        _buildStatCard(
                          context,
                          '총 예약',
                          '12',
                          Icons.book_online,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          context,
                          '완료된 여행',
                          '8',
                          Icons.check_circle,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          context,
                          '마일리지',
                          '45,000P',
                          Icons.stars,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '계정 설정',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMenuItem(
                    context,
                    '개인정보',
                    Icons.person_outline,
                    onTap: () {
                      // 개인정보 화면으로 이동
                    },
                  ),

                  _buildMenuItem(
                    context,
                    '결제 수단',
                    Icons.credit_card,
                    onTap: () {
                      // 결제 수단 관리 화면으로 이동
                    },
                  ),

                  _buildMenuItem(
                    context,
                    '여행 선호도',
                    Icons.favorite_outline,
                    onTap: () {
                      // 여행 선호도 설정 화면으로 이동
                    },
                  ),

                  const SizedBox(height: 24),

                  Text(
                    '서비스',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMenuItem(
                    context,
                    '고객 지원',
                    Icons.support_agent,
                    onTap: () {
                      // 고객 지원 화면으로 이동
                    },
                  ),

                  _buildMenuItem(
                    context,
                    '자주 묻는 질문',
                    Icons.help_outline,
                    onTap: () {
                      // FAQ 화면으로 이동
                    },
                  ),

                  _buildMenuItem(
                    context,
                    '약관 및 정책',
                    Icons.description,
                    onTap: () {
                      // 약관 및 정책 화면으로 이동
                    },
                  ),

                  const SizedBox(height: 24),

                  Text(
                    '앱 설정',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMenuItem(
                    context,
                    '알림 설정',
                    Icons.notifications_none,
                    onTap: () => AppRouter.goSettings(),
                  ),

                  _buildMenuItem(
                    context,
                    '언어 설정',
                    Icons.language,
                    trailing: const Text('한국어'),
                    onTap: () {
                      // 언어 설정 화면으로 이동
                    },
                  ),

                  _buildMenuItem(
                    context,
                    '다크 모드',
                    Icons.dark_mode,
                    trailing: Switch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (value) {
                        // 다크 모드 토글
                      },
                      activeColor: AppColors.primary,
                    ),
                    onTap: null,
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '버전 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.textLight.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.textLight,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textLight.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return TravelCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) trailing,
          if (onTap != null)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 로그아웃 로직
              AppRouter.goHome();
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
