import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';
import 'package:leafscan_app/screens/scans/scans_list_screen.dart';
import 'package:leafscan_app/screens/history/scan_detail_screen.dart';
import 'package:leafscan_app/services/api_service.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LeafColors get _c      => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark    => _c.cardBg;
  Color get _green       => _c.green;
  Color get _greenLight  => _c.greenLight;
  Color get _textPrimary => _c.textPrimary;
  Color get _textMuted   => _c.textMuted;
  Color get _orange      => _c.orange;
  Color get _border      => _c.border;

  List<dynamic> _recentScans = [];
  int  _totalScans   = 0;
  int  _healthyCount = 0;
  int  _issuesCount  = 0;
  bool _loading      = true;
  String _userName   = '';

  final PageController _pageCtrl = PageController(viewportFraction: 0.78);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  Future<void> _loadData() async {
    final me      = await ApiService.getMe();
    final recent  = await ApiService.getMyRecentAnalyses();
    final summary = await ApiService.getMySummary();
    if (!mounted) return;
    setState(() {
      _userName     = me?['full_name'] ?? me?['email'] ?? 'there';
      _recentScans  = recent;
      _totalScans   = summary?['total_scans']    ?? 0;
      _healthyCount = summary?['healthy_plants']  ?? 0;
      _issuesCount  = summary?['issues_found']    ?? 0;
      _loading      = false;
    });
  }

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
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: _green))
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildGreeting(),
                    const SizedBox(height: 16),
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildScanButton(context),
                    const SizedBox(height: 28),
                    _buildRecentScansHeader(context),
                    const SizedBox(height: 14),
                    _recentScans.isEmpty ? _buildEmptyRecent() : _buildCarousel(),
                    if (_recentScans.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildCarouselDots(),
                    ],
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
              child: Icon(Icons.person_rounded, color: _greenLight, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    final firstName = _userName.split(' ').first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hello, $firstName ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textPrimary)),
        const SizedBox(height: 4),
        Text('How are your plants today?', style: TextStyle(fontSize: 13, color: _textMuted)),
      ]),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Expanded(child: _statCard(value: '$_totalScans', label: 'Total Scans', icon: Icons.document_scanner_outlined, valueColor: _textPrimary,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScansListScreen(filter: ScanFilter.all))))),
        const SizedBox(width: 10),
        Expanded(child: _statCard(value: '$_healthyCount', label: 'Healthy', icon: Icons.favorite_rounded, valueColor: _greenLight,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScansListScreen(filter: ScanFilter.healthy))))),
        const SizedBox(width: 10),
        Expanded(child: _statCard(value: '$_issuesCount', label: 'Issues', icon: Icons.warning_amber_rounded, valueColor: _orange,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScansListScreen(filter: ScanFilter.ill))))),
      ]),
    );
  }

  Widget _statCard({required String value, required String label, required IconData icon, required Color valueColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: valueColor, size: 18),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor, height: 1)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: _textMuted)),
        ]),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.go(AppRouter.scan),
        child: Container(
          width: double.infinity, height: 200,
          decoration: BoxDecoration(
            color: _cardDark, borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _green.withOpacity(0.45), width: 1.5),
            boxShadow: [BoxShadow(color: _green.withOpacity(0.12), blurRadius: 32, spreadRadius: 4)],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: _green.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: _greenLight.withOpacity(0.3), width: 1)),
              child: Icon(Icons.camera_alt_rounded, color: _greenLight, size: 34),
            ),
            const SizedBox(height: 18),
            Text('Scan Plant', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 5),
            Text('Take or upload a photo to diagnose', style: TextStyle(fontSize: 13, color: _textMuted)),
          ]),
        ),
      ),
    );
  }

  Widget _buildRecentScansHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Recent Scans', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textPrimary)),
        GestureDetector(
          onTap: () => context.go(AppRouter.history),
          child: Text('View All', style: TextStyle(fontSize: 13, color: _greenLight, fontWeight: FontWeight.w500)),
        ),
      ]),
    );
  }

  Widget _buildEmptyRecent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: _border)),
        child: Column(children: [
          Icon(Icons.eco_outlined, color: _greenLight, size: 40),
          const SizedBox(height: 12),
          Text('No scans yet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary)),
          const SizedBox(height: 4),
          Text('Scan your first plant!', style: TextStyle(fontSize: 12, color: _textMuted)),
        ]),
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageCtrl,
        itemCount: _recentScans.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (ctx, i) {
          final a          = _recentScans[i];
          final isHealthy  = a['result_label'] == 'HEALTHY';
          final plantName  = a['plant_name'] ?? a['plant']?['name'] ?? 'Unknown';
          final diseaseName= a['disease_name'] ?? a['disease']?['name'] ?? '';
          final createdAt  = a['created_at'] ?? '';
          final date       = createdAt.length >= 10 ? createdAt.substring(0, 10) : '';
          final bool isActive = i == _currentPage;
          final Color accent  = isHealthy ? _green : _orange;

          return GestureDetector(
            onTap: () => context.push(AppRouter.result, extra: ScanDetailData(
              plantName:  plantName,
              date:       date,
              time:       '',
              isHealthy:  isHealthy,
              diseaseName: isHealthy ? null : diseaseName,
              plantId:    a['plant']?['id'] as int?,
              diseaseId:  a['disease']?['id'] as int?,
            )),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: isActive ? 0 : 10),
              decoration: BoxDecoration(
                color: _cardDark, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isActive ? accent.withOpacity(0.45) : _border, width: 1.5),
                boxShadow: isActive ? [BoxShadow(color: accent.withOpacity(0.1), blurRadius: 16, spreadRadius: 2)] : [],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(color: accent.withOpacity(0.13), shape: BoxShape.circle, border: Border.all(color: accent.withOpacity(0.28), width: 1)),
                    child: Icon(Icons.eco_rounded, color: isHealthy ? _greenLight : _orange, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(plantName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
                  const SizedBox(height: 2),
                  Text(date, style: TextStyle(fontSize: 11, color: _textMuted)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: accent.withOpacity(0.13), borderRadius: BorderRadius.circular(50), border: Border.all(color: accent.withOpacity(0.28), width: 1)),
                    child: Text(isHealthy ? 'Healthy' : diseaseName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isHealthy ? _greenLight : _orange)),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_recentScans.length, (i) {
        final bool isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 5, height: 5,
          decoration: BoxDecoration(color: isActive ? _greenLight : _border, borderRadius: BorderRadius.circular(3)),
        );
      }),
    );
  }
}
