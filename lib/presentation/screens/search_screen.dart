import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_router.dart';
import '../widgets/travel_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/bottom_navigation.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TravelScaffold(
      currentIndex: 1,
      body: Column(
        children: [
          // Search Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TravelSearchBar(
                  controller: _searchController,
                  hintText: '여행지, 호텔, 항공편 검색',
                  onChanged: (value) {
                    // Implement search logic
                  },
                  onSubmitted: () {
                    // Implement search submission
                  },
                ),
                const SizedBox(height: 16),

                // Tab Bar
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '전체'),
                    Tab(text: '항공편'),
                    Tab(text: '호텔'),
                    Tab(text: '패키지'),
                  ],
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllTab(),
                _buildFlightsTab(),
                _buildHotelsTab(),
                _buildPackagesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTab() {
    return CustomScrollView(
      slivers: [
        // Quick Search Suggestions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '빠른 검색',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                QuickSearchChips(
                  suggestions: const [
                    '서울', '도쿄', '방콕', '싱가포르', '발리', '파리', '런던', '뉴욕'
                  ],
                  onChipSelected: (destination) {
                    _searchController.text = destination;
                  },
                ),
              ],
            ),
          ),
        ),

        // Popular Destinations
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              '인기 여행지',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final destinations = [
                  {
                    'name': '서울',
                    'image': 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=400',
                    'country': '대한민국',
                    'rating': '4.8'
                  },
                  {
                    'name': '도쿄',
                    'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400',
                    'country': '일본',
                    'rating': '4.9'
                  },
                  {
                    'name': '방콕',
                    'image': 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=400',
                    'country': '태국',
                    'rating': '4.7'
                  },
                  {
                    'name': '싱가포르',
                    'image': 'https://images.unsplash.com/photo-1565967511849-1f6edcb15b3a?w=400',
                    'country': '싱가포르',
                    'rating': '4.8'
                  },
                  {
                    'name': '발리',
                    'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=400',
                    'country': '인도네시아',
                    'rating': '4.6'
                  },
                  {
                    'name': '파리',
                    'image': 'https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400',
                    'country': '프랑스',
                    'rating': '4.9'
                  },
                ];

                final destination = destinations[index % destinations.length];
                return DestinationCard(
                  imageUrl: destination['image']!,
                  title: destination['name']!,
                  subtitle: destination['country']!,
                  rating: destination['rating'],
                  onTap: () => AppRouter.goDestination('dest_${index + 1}'),
                );
              },
              childCount: 6,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildFlightsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FlightCard(
            airline: ['대한항공', '아시아나항공', '제주항공', '티웨이항공', '에어서울'][index % 5],
            flightNumber: 'KE${100 + index}',
            departureTime: '08:30',
            arrivalTime: '10:45',
            departureAirport: '서울(ICN)',
            arrivalAirport: '도쿄(NRT)',
            duration: '2시간 15분',
            price: '₩${150000 + (index * 50000)}',
            stops: index == 0 ? null : '직항',
            onTap: () => AppRouter.goFlight('flight_${index + 1}'),
          ),
        );
      },
    );
  }

  Widget _buildHotelsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) {
        final hotels = [
          {
            'name': '신라호텔 서울',
            'location': '서울 중구',
            'rating': '4.8',
            'price': '₩350,000',
            'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400'
          },
          {
            'name': '롯데호텔 서울',
            'location': '서울 중구',
            'rating': '4.7',
            'price': '₩280,000',
            'image': 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=400'
          },
          {
            'name': '워커힐호텔',
            'location': '서울 광진구',
            'rating': '4.6',
            'price': '₩220,000',
            'image': 'https://images.unsplash.com/photo-1582719471135-c3967ffb1c42?w=400'
          },
          {
            'name': '그랜드 하얏트 서울',
            'location': '서울 용산구',
            'rating': '4.9',
            'price': '₩400,000',
            'image': 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=400'
          },
          {
            'name': '파크 하얏트 서울',
            'location': '서울 강남구',
            'rating': '4.8',
            'price': '₩500,000',
            'image': 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=400'
          },
        ];

        final hotel = hotels[index];
        return TravelCard(
          onTap: () => AppRouter.goHotel('hotel_${index + 1}'),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(hotel['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel['name']!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hotel['location']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hotel['rating']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          hotel['price']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPackagesTab() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final packages = [
                  {
                    'title': '일본 도쿄 3박 4일',
                    'description': '도쿄 주요 관광지 + 온천 체험',
                    'price': '₩890,000',
                    'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400',
                    'duration': '3박 4일',
                    'includes': ['항공편', '호텔', '가이드', '식사']
                  },
                  {
                    'title': '태국 방콕 + 파타야 4박 5일',
                    'description': '방콕 문화 체험 + 파타야 휴양',
                    'price': '₩650,000',
                    'image': 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=400',
                    'duration': '4박 5일',
                    'includes': ['항공편', '호텔', '가이드', '쇼핑']
                  },
                  {
                    'title': '싱가포르 + 말레이시아 5박 6일',
                    'description': '두 나라를 한번에!',
                    'price': '₩750,000',
                    'image': 'https://images.unsplash.com/photo-1565967511849-1f6edcb15b3a?w=400',
                    'duration': '5박 6일',
                    'includes': ['항공편', '호텔', '가이드', '관광']
                  },
                ];

                final package = packages[index % packages.length];
                return TravelCard(
                  onTap: () => AppRouter.goDestination('package_${index + 1}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(package['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              package['duration']!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            package['price']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        package['title']!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package['description']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: (package['includes'] as List<String>).map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
              childCount: 3,
            ),
          ),
        ),
      ],
    );
  }
}
