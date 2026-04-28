import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/theme/app_theme.dart';
import 'package:leafscan_app/router/app_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppBottomNavBar — shared bottom navigation bar
// Place in: lib/widgets/app_bottom_nav_bar.dart
// ─────────────────────────────────────────────────────────────────────────────

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go(AppRouter.home);
        break;
      case 1:
        context.go(AppRouter.scan);
        break;
      case 2:
        context.go(AppRouter.history);
        break;
      case 3:
        context.go(AppRouter.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, 0, Icons.home_rounded, Icons.home_outlined, 'Home'),
              _navItem(context, 1, Icons.camera_alt_rounded, Icons.camera_alt_outlined, 'Scan'),
              _navItem(context, 2, Icons.access_time_rounded, Icons.access_time_outlined, 'History'),
              _navItem(context, 3, Icons.person_rounded, Icons.person_outlined, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(context, index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}