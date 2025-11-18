import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class PackageDetailsScreen extends StatelessWidget {
  final String? packageId;

  const PackageDetailsScreen({super.key, this.packageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('패키지 상세'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_travel,
              size: 80,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: 24),
            Text(
              '패키지 상세 정보',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              packageId != null ? 'Package ID: $packageId' : '패키지 정보 없음',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              '이 기능은 준비 중입니다',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('뒤로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}
