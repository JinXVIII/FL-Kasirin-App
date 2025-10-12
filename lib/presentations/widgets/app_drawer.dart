import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cores/constants/colors.dart';
import '../../cores/themes/text_styles.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    this.currentRoute = '/dashboard',
  });

  final String userName;
  final String userEmail;
  final String currentRoute;

  Future<void> _logout(BuildContext context) async {
    // Clear any stored data (e.g., authentication tokens)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to login screen
    if (context.mounted) {
      context.pushReplacement('/login');
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Keluar', style: AppTextStyles.heading3),
        content: Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text(
              'Batal',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _logout(context);
            },
            child: Text(
              'Keluar',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required VoidCallback onTap,
  }) {
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withAlpha(40) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.black.withAlpha(100),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isActive
                ? AppColors.primary
                : AppColors.black.withAlpha(100),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // Close drawer
          onTap();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // User profile header
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: AppTextStyles.heading3.copyWith(color: AppColors.white),
            ),
            accountEmail: Text(
              userEmail,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.white,
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
          ),

          // Menu items with active container
          _buildMenuItem(
            context: context,
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            route: '/dashboard',
            onTap: () {
              // Already on dashboard, no need to navigate
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            route: '/settings',
            onTap: () {
              // TODO: Navigate to settings screen
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.star_outlined,
            title: 'Fitur PRO',
            route: '/pro-features',
            onTap: () {
              // TODO: Navigate to PRO features screen
            },
          ),

          const Spacer(), // Push logout button to bottom
          // Logout button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close drawer
                  _showLogoutConfirmation(context);
                },
                child: Text(
                  'Keluar',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
