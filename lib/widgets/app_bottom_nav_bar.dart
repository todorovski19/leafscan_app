import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const AppBottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0: context.go(AppRouter.home);    break;
      case 1: context.go(AppRouter.scan);    break;
      case 2: context.go(AppRouter.history); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = LeafColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.bg,
        border: Border(top: BorderSide(color: c.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(child: _navItem(context, c, 0, Icons.home_rounded, 'Home')),
              _scanCentreButton(context, c),
              Expanded(child: _navItem(context, c, 2, Icons.access_time_rounded, 'History')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, LeafColors c, int index, IconData icon, String label) {
    final bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(context, index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isActive ? c.green.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isActive ? c.greenLight : c.textMuted, size: 22),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? c.greenLight : c.textMuted,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  Widget _scanCentreButton(BuildContext context, LeafColors c) {
    final bool isActive = currentIndex == 1;
    return GestureDetector(
      onTap: () => _onTap(context, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 58, height: 58,
          decoration: BoxDecoration(
            color: isActive ? c.green : c.green.withOpacity(0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: c.green.withOpacity(0.35), blurRadius: 16, spreadRadius: 2, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
