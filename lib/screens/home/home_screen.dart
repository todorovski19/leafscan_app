import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/theme/app_theme.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomeScreen — main dashboard after login
// Place in: lib/screens/home/home_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _userName = 'Sarah Johnson';

  static const List<_ScanItem> _recentScans = [
    _ScanItem(
      plantName: 'Tomato Plant',
      date: 'Mar 20, 2026',
      status: 'Healthy',
      isHealthy: true,
      imageAsset: null,
    ),
    _ScanItem(
      plantName: 'Rose Bush',
      date: 'Mar 18, 2026',
      status: 'Early Blight',
      isHealthy: false,
      imageAsset: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildScanCta(context),
            const SizedBox(height: 28),
            _buildWhySection(),
            const SizedBox(height: 28),
            _buildRecentScans(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA8D5B5), Color(0xFF7CC49A)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.eco_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2E5C40),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '$_userName 👋',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A3328),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_outlined, color: Color(0xFF2E5C40), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildStatsCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statItem('Total Scans', '24', AppColors.textDark),
          _statDivider(),
          _statItem('Healthy\nPlants', '18', AppColors.primary),
          _statDivider(),
          _statItem('Issues Found', '6', const Color(0xFFE8924A)),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: valueColor,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _statDivider() => Container(
    width: 1,
    height: 40,
    color: AppColors.border,
  );

  // ── Scan Plant CTA ─────────────────────────────────────────────────────────
  Widget _buildScanCta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () => context.go(AppRouter.scan),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF8EC4A4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan Plant',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Take or upload a photo',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Why Use PlantCare AI ───────────────────────────────────────────────────
  Widget _buildWhySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Use PlantCare AI?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _featureCard(
                  icon: Icons.shield_outlined,
                  title: 'Early\nDetection',
                  subtitle: 'Catch diseases before they spread',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _featureCard(
                  icon: Icons.trending_up_rounded,
                  title: 'Track\nProgress',
                  subtitle: 'Monitor plant health over time',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _featureCard(
                  icon: Icons.menu_book_outlined,
                  title: 'Learn\nMore',
                  subtitle: 'Access treatment guides',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryMint.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent Scans ───────────────────────────────────────────────────────────
  Widget _buildRecentScans() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Scans',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: navigate to history
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._recentScans.map((scan) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _scanCard(scan),
          )),
        ],
      ),
    );
  }

  Widget _scanCard(_ScanItem scan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryMint.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.eco, color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: 10),
          Text(
            scan.plantName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            scan.date,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: scan.isHealthy
                  ? AppColors.primaryMint.withOpacity(0.4)
                  : const Color(0xFFF5E0CC),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              scan.status,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: scan.isHealthy
                    ? AppColors.primary
                    : const Color(0xFFD4722A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────
class _ScanItem {
  final String plantName;
  final String date;
  final String status;
  final bool isHealthy;
  final String? imageAsset;

  const _ScanItem({
    required this.plantName,
    required this.date,
    required this.status,
    required this.isHealthy,
    required this.imageAsset,
  });
}