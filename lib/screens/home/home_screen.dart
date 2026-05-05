import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';
import 'package:leafscan_app/screens/scans/scans_list_screen.dart';
import 'package:leafscan_app/screens/history/scan_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _orange      = Color(0xFFE8924A);
  static const Color _border      = Color(0xFF243028);

  static const List<_ScanItem> _recentScans = [
    _ScanItem(plantName: 'Tomato Plant',  date: 'Mar 20, 2026', status: 'Healthy',        isHealthy: true),
    _ScanItem(plantName: 'Rose Bush',     date: 'Mar 18, 2026', status: 'Early Blight',   isHealthy: false),
    _ScanItem(plantName: 'Cucumber',      date: 'Mar 15, 2026', status: 'Healthy',        isHealthy: true),
    _ScanItem(plantName: 'Bell Pepper',   date: 'Mar 12, 2026', status: 'Powdery Mildew', isHealthy: false),
  ];

  final PageController _pageCtrl = PageController(viewportFraction: 0.78);
  int _currentPage = 0;

  void _goTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildScanButton(context),
                    const SizedBox(height: 28),
                    _buildRecentScansHeader(context),
                    const SizedBox(height: 14),
                    _buildCarousel(),
                    const SizedBox(height: 12),
                    _buildCarouselDots(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => context.go(AppRouter.profile),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: _cardDark,
                shape: BoxShape.circle,
                border: Border.all(color: _green.withOpacity(0.4), width: 1.5),
              ),
              child: const Icon(Icons.person_rounded, color: _greenLight, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _statCard(
            value: '24', label: 'Total Scans', icon: Icons.document_scanner_outlined,
            valueColor: _textPrimary,
            onTap: () => _goTo(const ScansListScreen(filter: ScanFilter.all)),
          )),
          const SizedBox(width: 10),
          Expanded(child: _statCard(
            value: '18', label: 'Healthy', icon: Icons.favorite_rounded,
            valueColor: _greenLight,
            onTap: () => _goTo(const ScansListScreen(filter: ScanFilter.healthy)),
          )),
          const SizedBox(width: 10),
          Expanded(child: _statCard(
            value: '6', label: 'Issues', icon: Icons.warning_amber_rounded,
            valueColor: _orange,
            onTap: () => _goTo(const ScansListScreen(filter: ScanFilter.ill)),
          )),
        ],
      ),
    );
  }

  Widget _statCard({
    required String value,
    required String label,
    required IconData icon,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: valueColor, size: 18),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor, height: 1)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: _textMuted)),
          ],
        ),
      ),
    );
  }

  // ── Scan button ───────────────────────────────────────────────────────────
  Widget _buildScanButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.go(AppRouter.scan),
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: _cardDark,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _green.withOpacity(0.45), width: 1.5),
            boxShadow: [BoxShadow(color: _green.withOpacity(0.12), blurRadius: 32, spreadRadius: 4)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: _green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _greenLight.withOpacity(0.3), width: 1),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: _greenLight, size: 34),
              ),
              const SizedBox(height: 18),
              const Text('Scan Plant', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _textPrimary)),
              const SizedBox(height: 5),
              const Text('Take or upload a photo to diagnose', style: TextStyle(fontSize: 13, color: _textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Recent scans header ───────────────────────────────────────────────────
  Widget _buildRecentScansHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Recent Scans', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textPrimary)),
          GestureDetector(
            onTap: () => context.go(AppRouter.history),
            child: const Text('View All', style: TextStyle(fontSize: 13, color: _greenLight, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // ── Carousel ──────────────────────────────────────────────────────────────
  Widget _buildCarousel() {
    return SizedBox(
      height: 190,
      child: PageView.builder(
        controller: _pageCtrl,
        itemCount: _recentScans.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (ctx, i) {
          final scan = _recentScans[i];
          final bool isActive = i == _currentPage;
          final Color accent = scan.isHealthy ? _green : _orange;
          return GestureDetector(
            onTap: () => Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (_) => ScanDetailScreen(
                  data: sampleDetailFromRecord(
                    plantName: scan.plantName,
                    date: scan.date,
                    time: '—',
                    isHealthy: scan.isHealthy,
                    status: scan.status,
                  ),
                ),
              ),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: isActive ? 0 : 10),
              decoration: BoxDecoration(
                color: _cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isActive ? accent.withOpacity(0.45) : _border, width: 1.5),
                boxShadow: isActive ? [BoxShadow(color: accent.withOpacity(0.1), blurRadius: 16, spreadRadius: 2)] : [],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.13),
                        shape: BoxShape.circle,
                        border: Border.all(color: accent.withOpacity(0.28), width: 1),
                      ),
                      child: Icon(Icons.eco_rounded, color: scan.isHealthy ? _greenLight : _orange, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(scan.plantName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
                    const SizedBox(height: 2),
                    Text(scan.date, style: const TextStyle(fontSize: 11, color: _textMuted)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: accent.withOpacity(0.28), width: 1),
                      ),
                      child: Text(scan.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scan.isHealthy ? _greenLight : _orange)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Carousel dots ─────────────────────────────────────────────────────────
  Widget _buildCarouselDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_recentScans.length, (i) {
        final bool isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 5,
          height: 5,
          decoration: BoxDecoration(
            color: isActive ? _greenLight : _border,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _ScanItem {
  final String plantName, date, status;
  final bool isHealthy;
  const _ScanItem({required this.plantName, required this.date, required this.status, required this.isHealthy});
}