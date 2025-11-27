import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/travel_card.dart';

// Settings State
class SettingsState {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final String language;
  final bool darkMode;
  final bool locationServices;
  final String currency;
  final String distanceUnit;

  const SettingsState({
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.language = 'ko',
    this.darkMode = false,
    this.locationServices = true,
    this.currency = 'KRW',
    this.distanceUnit = 'km',
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    String? language,
    bool? darkMode,
    bool? locationServices,
    String? currency,
    String? distanceUnit,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      locationServices: locationServices ?? this.locationServices,
      currency: currency ?? this.currency,
      distanceUnit: distanceUnit ?? this.distanceUnit,
    );
  }
}

// Settings Notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleNotifications() {
    state = state.copyWith(
      notificationsEnabled: !state.notificationsEnabled,
    );
  }

  void toggleEmailNotifications() {
    state = state.copyWith(
      emailNotifications: !state.emailNotifications,
    );
  }

  void togglePushNotifications() {
    state = state.copyWith(
      pushNotifications: !state.pushNotifications,
    );
  }

  void toggleSmsNotifications() {
    state = state.copyWith(
      smsNotifications: !state.smsNotifications,
    );
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void toggleDarkMode() {
    state = state.copyWith(darkMode: !state.darkMode);
  }

  void toggleLocationServices() {
    state = state.copyWith(locationServices: !state.locationServices);
  }

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void setDistanceUnit(String unit) {
    state = state.copyWith(distanceUnit: unit);
  }
}

// Settings Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('설정'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSectionHeader('계정 설정'),
            _buildSettingItem(
              context,
              '프로필 정보',
              '개인정보 및 계정 설정',
              Icons.person_outline,
              onTap: () {
                // 프로필 설정 화면으로 이동
              },
            ),
            _buildSettingItem(
              context,
              '결제 수단',
              '신용카드 및 결제 정보',
              Icons.credit_card,
              onTap: () {
                // 결제 수단 화면으로 이동
              },
            ),
            _buildSettingItem(
              context,
              '여행 선호도',
              '관심 여행지 및 취향 설정',
              Icons.favorite_outline,
              onTap: () {
                // 여행 선호도 화면으로 이동
              },
            ),

            const SizedBox(height: 32),

            // Notification Settings
            _buildSectionHeader('알림 설정'),
            _buildSwitchItem(
              context,
              ref,
              '푸시 알림',
              '예약 변경 및 특별 혜택 알림',
              Icons.notifications_none,
              settings.pushNotifications,
              (value) => ref.read(settingsProvider.notifier).togglePushNotifications(),
            ),
            _buildSwitchItem(
              context,
              ref,
              '이메일 알림',
              '프로모션 및 뉴스레터',
              Icons.email_outlined,
              settings.emailNotifications,
              (value) => ref.read(settingsProvider.notifier).toggleEmailNotifications(),
            ),
            _buildSwitchItem(
              context,
              ref,
              'SMS 알림',
              '중요 예약 정보',
              Icons.sms_outlined,
              settings.smsNotifications,
              (value) => ref.read(settingsProvider.notifier).toggleSmsNotifications(),
            ),

            const SizedBox(height: 32),

            // App Settings
            _buildSectionHeader('앱 설정'),
            _buildSelectionItem(
              context,
              '언어',
              _getLanguageName(settings.language),
              Icons.language,
              onTap: () => _showLanguageDialog(context, ref),
            ),
            _buildSwitchItem(
              context,
              ref,
              '다크 모드',
              '어두운 테마 사용',
              Icons.dark_mode,
              settings.darkMode,
              (value) => ref.read(settingsProvider.notifier).toggleDarkMode(),
            ),
            _buildSelectionItem(
              context,
              '통화',
              settings.currency,
              Icons.attach_money,
              onTap: () => _showCurrencyDialog(context, ref),
            ),
            _buildSelectionItem(
              context,
              '거리 단위',
              settings.distanceUnit,
              Icons.straighten,
              onTap: () => _showDistanceUnitDialog(context, ref),
            ),

            const SizedBox(height: 32),

            // Privacy & Security
            _buildSectionHeader('개인정보 및 보안'),
            _buildSwitchItem(
              context,
              ref,
              '위치 서비스',
              '현재 위치 기반 추천',
              Icons.location_on_outlined,
              settings.locationServices,
              (value) => ref.read(settingsProvider.notifier).toggleLocationServices(),
            ),
            _buildSettingItem(
              context,
              '개인정보 처리방침',
              '데이터 수집 및 이용 약관',
              Icons.privacy_tip_outlined,
              onTap: () {
                // 개인정보 처리방침 화면으로 이동
              },
            ),
            _buildSettingItem(
              context,
              '이용약관',
              '서비스 이용 약관',
              Icons.description_outlined,
              onTap: () {
                // 이용약관 화면으로 이동
              },
            ),

            const SizedBox(height: 32),

            // Support
            _buildSectionHeader('고객 지원'),
            _buildSettingItem(
              context,
              '자주 묻는 질문',
              'FAQ 및 도움말',
              Icons.help_outline,
              onTap: () {
                // FAQ 화면으로 이동
              },
            ),
            _buildSettingItem(
              context,
              '고객 센터',
              '1:1 문의 및 실시간 채팅',
              Icons.support_agent,
              onTap: () {
                // 고객 센터 화면으로 이동
              },
            ),
            _buildSettingItem(
              context,
              '앱 버전',
              '1.0.0',
              Icons.info_outline,
              onTap: () {
                // 앱 정보 다이얼로그 표시
                _showAppInfoDialog(context);
              },
            ),

            const SizedBox(height: 32),

            // Reset Settings
            Center(
              child: TextButton(
                onPressed: () => _showResetDialog(context, ref),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
                child: const Text('설정 초기화'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return TravelCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildSwitchItem(
    BuildContext context,
    WidgetRef ref,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return TravelCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionItem(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return TravelCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'ko':
        return '한국어';
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      default:
        return '한국어';
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final languages = [
      {'code': 'ko', 'name': '한국어'},
      {'code': 'en', 'name': 'English'},
      {'code': 'zh', 'name': '中文'},
      {'code': 'ja', 'name': '日本語'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('언어 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return ListTile(
              title: Text(lang['name']!),
              onTap: () {
                ref.read(settingsProvider.notifier).setLanguage(lang['code']!);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, WidgetRef ref) {
    final currencies = ['KRW', 'USD', 'JPY', 'CNY', 'EUR'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('통화 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) {
            return ListTile(
              title: Text(currency),
              onTap: () {
                ref.read(settingsProvider.notifier).setCurrency(currency);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDistanceUnitDialog(BuildContext context, WidgetRef ref) {
    final units = ['km', 'mile'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('거리 단위 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: units.map((unit) {
            return ListTile(
              title: Text(unit),
              onTap: () {
                ref.read(settingsProvider.notifier).setDistanceUnit(unit);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('TravelMate'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('버전: 1.0.0'),
            SizedBox(height: 8),
            Text('AI 기반 여행사 플랫폼'),
            SizedBox(height: 8),
            Text('© 2024 TravelMate. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('설정 초기화'),
        content: const Text('모든 설정을 기본값으로 초기화하시겠습니까?'),
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
              // Reset settings to default
              ref.read(settingsProvider.notifier).state = const SettingsState();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('설정이 초기화되었습니다')),
              );
            },
            child: Text(
              '초기화',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
