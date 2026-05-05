import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const AppBottomNavBar({super.key, required this.currentIndex});

  static const Color _bg         = Color(0xFF1A211D);
  static const Color _border     = Color(0xFF243028);
  static const Color _green      = Color(0xFF5C9E78);
  static const Color _greenLight = Color(0xFF7CC49A);
  static const Color _textMuted  = Color(0xFF4A6055);

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
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(child: _navItem(context, 0, Icons.home_rounded, 'Home')),
              _scanCentreButton(context),
              Expanded(child: _navItem(context, 2, Icons.access_time_rounded, 'History')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, IconData icon, String label) {
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
              color: isActive ? _green.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isActive ? _greenLight : _textMuted, size: 22),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? _greenLight : _textMuted,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  Widget _scanCentreButton(BuildContext context) {
    final bool isActive = currentIndex == 1;
    return GestureDetector(
      onTap: () => _onTap(context, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 58, height: 58,
          decoration: BoxDecoration(
            color: isActive ? _green : _green.withOpacity(0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: _green.withOpacity(0.35), blurRadius: 16, spreadRadius: 2, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}