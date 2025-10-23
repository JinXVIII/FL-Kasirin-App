import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../cores/constants/colors.dart';
import '../../cores/routes/app_router.dart';
import '../../cores/themes/text_styles.dart';

import '../providers/auth_provider.dart';

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

  /// Shows a loading dialog during logout process
  Widget _buildLoadingDialog() {
    return const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text("Sedang logout..."),
        ],
      ),
    );
  }

  /// Shows confirmation dialog before logout
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
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

  /// Handles the logout process with loading indicator
  Future<void> _logout(BuildContext context) async {
    // Store navigator and router references before showing dialog
    final navigator = Navigator.of(context);
    final goRouter = GoRouter.of(context);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildLoadingDialog(),
    );

    try {
      // Perform logout through AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
    } catch (e) {
      // Handle any potential errors during logout
      debugPrint('Logout error: $e');
    } finally {
      // Always close the dialog and navigate
      if (navigator.canPop()) {
        navigator.pop();
      }
      goRouter.pushReplacement('/login');
    }
  }

  /// Builds a menu item with active state styling
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
          Navigator.pop(context);
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
          _buildUserHeader(),

          // Menu items
          _buildMenuItems(context),

          // Logout button at the bottom
          const Spacer(),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  /// Builds the user profile header section
  Widget _buildUserHeader() {
    return UserAccountsDrawerHeader(
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
          style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
        ),
      ),
      decoration: const BoxDecoration(color: AppColors.primary),
    );
  }

  /// Builds the menu items section
  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.dashboard_outlined,
        'title': 'Dashboard',
        'route': '/dashboard',
        'onTap': () {}, // Already on dashboard
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Pengaturan',
        'route': '/edit-profile',
        'onTap': () => context.pushNamed(RouteConstants.editProfile),
      },
      {
        'icon': Icons.star_outlined,
        'title': 'Fitur PRO',
        'route': '/pro-features',
        'onTap': () {}, // TODO: Navigate to PRO features screen
      },
    ];

    return Column(
      children: menuItems.map((item) {
        return _buildMenuItem(
          context: context,
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          route: item['route'] as String,
          onTap: item['onTap'] as VoidCallback,
        );
      }).toList(),
    );
  }

  /// Builds the logout button section
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
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
    );
  }
}
