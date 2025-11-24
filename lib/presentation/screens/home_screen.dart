import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/navigation/app_router.dart';
import '../widgets/travel_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TravelScaffold(
      currentIndex: 0,
      body: CustomScrollView(
        slivers: [
          // Hero Section with Search
          SliverToBoxAdapter(
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '안녕하세요!',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '어디로 여행가시나요?',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.textLight.withOpacity(0.2),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TravelSearchBar(
                        hintText: '여행지, 호텔, 항공편 검색',
                        onSubmitted: () => AppRouter.goSearch(),
                      ),
                    ),

                    // Quick Actions
                    const SizedBox(height: 16),
                    _QuickActions(),
                  ],
                ),
              ),
            ),
          ),

          // Popular Destinations
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '인기 여행지',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => AppRouter.goSearch(),
                    child: Text(
                      '더보기',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Destination Cards
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final destinations = [
                    {
                      'name': '서울',
                      'image': 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=400',
                      'rating': '4.8',
                      'price': '₩150,000~'
                    },
                    {
                      'name': '도쿄',
                      'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400',
                      'rating': '4.9',
                      'price': '₩250,000~'
                    },
                    {
                      'name': '방콕',
                      'image': 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=400',
                      'rating': '4.7',
                      'price': '₩200,000~'
                    },
                    {
                      'name': '싱가포르',
                      'image': 'https://images.unsplash.com/photo-1565967511849-1f6edcb15b3a?w=400',
                      'rating': '4.8',
                      'price': '₩300,000~'
                    },
                    {
                      'name': '발리',
                      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=400',
                      'rating': '4.6',
                      'price': '₩350,000~'
                    },
                  ];

                  final destination = destinations[index];
                  return DestinationCard(
                    imageUrl: destination['image']!,
                    title: destination['name']!,
                    subtitle: '최고의 여행지',
                    rating: destination['rating'],
                    price: destination['price'],
                    onTap: () => AppRouter.goDestination('dest_${index + 1}'),
                  );
                },
              ),
            ),
          ),

          // AI Travel Assistant
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TravelCard(
                gradient: AppColors.secondaryGradient,
                onTap: () => AppRouter.goAIChat(),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.textLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.smart_toy,
                        color: AppColors.textLight,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI 여행 도우미',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '맞춤형 여행 추천을 받아보세요',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textLight.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textLight.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Why Choose TravelMate
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'TravelMate를 선택하는 이유',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Feature Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _FeatureCard(
                  icon: Icons.verified_user,
                  iconColor: AppColors.success,
                  title: '안전하고 신뢰할 수 있는',
                  description: '고객님의 안전이 최우선입니다',
                ),
                const SizedBox(height: 12),
                _FeatureCard(
                  icon: Icons.support_agent,
                  iconColor: AppColors.primary,
                  title: '24시간 고객 지원',
                  description: '언제든지 도움을 드립니다',
                ),
                const SizedBox(height: 12),
                _FeatureCard(
                  icon: Icons.attach_money,
                  iconColor: AppColors.secondary,
                  title: '최고의 가격 보장',
                  description: '경쟁력 있는 가격을 제공합니다',
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuickActionButton(
            icon: Icons.flight,
            label: '항공편',
            color: AppColors.flight,
            onTap: () => AppRouter.goFlightSearch(),
          ),
          _QuickActionButton(
            icon: Icons.hotel,
            label: '호텔',
            color: AppColors.hotel,
            onTap: () => AppRouter.goHotelSearch(),
          ),
          _QuickActionButton(
            icon: Icons.tour,
            label: '패키지',
            color: AppColors.activity,
            onTap: () => AppRouter.goSearch(),
          ),
          _QuickActionButton(
            icon: Icons.directions_car,
            label: '렌터카',
            color: AppColors.transport,
            onTap: () => AppRouter.goSearch(),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
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
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return TravelCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}