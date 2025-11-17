import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: authProvider.isAuthenticated
          ? _buildProfileContent(context, authProvider)
          : _buildLoginPrompt(context),
    );
  }

  Widget _buildProfileContent(BuildContext context, AuthProvider authProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Header
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    authProvider.userName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.userName ?? 'User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.userEmail ?? '',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Edit profile
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Menu Items
        const Text(
          '계정 설정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        _buildMenuItem(
          Icons.person,
          '개인정보',
          '이름, 이메일, 전화번호',
          () {},
        ),
        _buildMenuItem(
          Icons.notifications,
          '알림 설정',
          '푸시 알림, 이메일 알림',
          () {},
        ),
        _buildMenuItem(
          Icons.language,
          '언어',
          '한국어',
          () {},
        ),
        _buildMenuItem(
          Icons.security,
          '보안',
          '비밀번호 변경, 2단계 인증',
          () {},
        ),

        const SizedBox(height: 24),

        const Text(
          '기타',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        _buildMenuItem(
          Icons.help,
          '고객 지원',
          '자주 묻는 질문, 문의하기',
          () {},
        ),
        _buildMenuItem(
          Icons.privacy_tip,
          '개인정보 처리방침',
          '',
          () {},
        ),
        _buildMenuItem(
          Icons.description,
          '이용약관',
          '',
          () {},
        ),
        _buildMenuItem(
          Icons.info,
          '앱 정보',
          'Version 1.0.0',
          () {},
        ),

        const SizedBox(height: 24),

        // Logout Button
        ElevatedButton(
          onPressed: () async {
            await authProvider.logout();
            if (context.mounted) {
              context.go('/');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.danger,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('로그아웃'),
        ),

        const SizedBox(height: 16),

        // Delete Account Button
        TextButton(
          onPressed: () {
            _showDeleteAccountDialog(context);
          },
          child: const Text(
            '계정 삭제',
            style: TextStyle(color: AppColors.danger),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            '프로필을 확인하려면\n로그인이 필요합니다',
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
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go('/signup'),
            child: const Text('회원가입'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text(
          '정말로 계정을 삭제하시겠습니까?\n이 작업은 취소할 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete account logic
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
