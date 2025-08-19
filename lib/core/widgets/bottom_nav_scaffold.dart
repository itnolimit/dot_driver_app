import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';

class BottomNavScaffold extends StatelessWidget {
  final Widget child;

  const BottomNavScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _calculateSelectedIndex(context),
          onDestinationSelected: (index) => _onItemTapped(index, context),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E293B)
              : Colors.white,
          indicatorColor: AppColors.primaryColor.withOpacity(0.1),
          destinations: [
            NavigationDestination(
              icon: Icon(
                PhosphorIconsRegular.house,
                color: _getIconColor(context, 0),
              ),
              selectedIcon: Icon(
                PhosphorIconsFill.house,
                color: AppColors.primaryColor,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                PhosphorIconsRegular.files,
                color: _getIconColor(context, 1),
              ),
              selectedIcon: Icon(
                PhosphorIconsFill.files,
                color: AppColors.primaryColor,
              ),
              label: 'Documents',
            ),
            NavigationDestination(
              icon: Icon(
                PhosphorIconsRegular.briefcase,
                color: _getIconColor(context, 2),
              ),
              selectedIcon: Icon(
                PhosphorIconsFill.briefcase,
                color: AppColors.primaryColor,
              ),
              label: 'Applications',
            ),
            NavigationDestination(
              icon: Icon(
                PhosphorIconsRegular.user,
                color: _getIconColor(context, 3),
              ),
              selectedIcon: Icon(
                PhosphorIconsFill.user,
                color: AppColors.primaryColor,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(BuildContext context, int index) {
    return _calculateSelectedIndex(context) == index
        ? AppColors.primaryColor
        : AppColors.textHint;
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/documents')) return 1;
    if (location.startsWith('/applications')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/documents');
        break;
      case 2:
        context.go('/applications');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}