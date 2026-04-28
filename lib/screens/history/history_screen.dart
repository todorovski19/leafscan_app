import 'package:flutter/material.dart';
import 'package:leafscan_app/theme/app_theme.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HistoryScreen — scan history with search, filter and monthly chart
// Place in: lib/screens/history/history_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ── Mock scan data (replace with real backend/provider data) ───────────────
  static const List<_ScanRecord> _allScans = [
    _ScanRecord(plantName: 'Tomato Plant',  date: 'Mar 20, 2026', time: '10:30 AM', status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Rose Bush',     date: 'Mar 18, 2026', time: '2:15 PM',  status: 'Early Blight',   isHealthy: false),
    _ScanRecord(plantName: 'Cucumber',      date: 'Mar 15, 2026', time: '9:45 AM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Bell Pepper',   date: 'Mar 12, 2026', time: '11:20 AM', status: 'Powdery Mildew', isHealthy: false),
    _ScanRecord(plantName: 'Basil',         date: 'Feb 28, 2026', time: '3:00 PM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Sunflower',     date: 'Feb 14, 2026', time: '8:10 AM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Mint',          date: 'Jan 30, 2026', time: '1:45 PM',  status: 'Rust Disease',   isHealthy: false),
    _ScanRecord(plantName: 'Strawberry',    date: 'Jan 10, 2026', time: '10:00 AM', status: 'Healthy',        isHealthy: true),
  ];

  // Monthly scan counts for chart [Jan, Feb, Mar]
  static const List<_MonthData> _monthlyData = [
    _MonthData(month: 'Jan', count: 2),
    _MonthData(month: 'Feb', count: 3),
    _MonthData(month: 'Mar', count: 5),
  ];

  int _selectedFilter = 0; // 0=All, 1=Healthy, 2=Diseased
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_ScanRecord> get _filteredScans {
    List<_ScanRecord> scans = _allScans;

    // Apply filter tab
    if (_selectedFilter == 1) {
      scans = scans.where((s) => s.isHealthy).toList();
    } else if (_selectedFilter == 2) {
      scans = scans.where((s) => !s.isHealthy).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      scans = scans
          .where((s) => s.plantName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return scans;
  }

  int get _totalCount   => _allScans.length;
  int get _healthyCount => _allScans.where((s) => s.isHealthy).length;
  int get _diseasedCount => _allScans.where((s) => !s.isHealthy).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMonthlyChart(),
                  const SizedBox(height: 20),
                  _buildFilterTabs(),
                  const SizedBox(height: 16),
                  ..._filteredScans.isEmpty
                      ? [_buildEmptyState()]
                      : _filteredScans.map((scan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildScanCard(scan),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  // ── Header with gradient + search ─────────────────────────────────────────
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Scan History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3328),
                ),
              ),
              const SizedBox(height: 14),
              // Search bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Search plants...',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18),
                    )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    filled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Monthly bar chart ──────────────────────────────────────────────────────
  Widget _buildMonthlyChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Scans',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$_totalCount',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryMint.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Bar chart
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _monthlyData.map((data) {
                final maxCount = _monthlyData
                    .map((d) => d.count)
                    .reduce((a, b) => a > b ? a : b);
                final barHeight = maxCount == 0
                    ? 0.0
                    : 70.0 * (data.count / maxCount);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: AppColors.primaryMint.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data.month,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter tabs ────────────────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Row(
      children: [
        _filterTab(0, 'All ($_totalCount)'),
        const SizedBox(width: 10),
        _filterTab(1, 'Healthy ($_healthyCount)'),
        const SizedBox(width: 10),
        _filterTab(2, 'Diseased ($_diseasedCount)'),
      ],
    );
  }

  Widget _filterTab(int index, String label) {
    final bool isActive = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  // ── Scan card ──────────────────────────────────────────────────────────────
  Widget _buildScanCard(_ScanRecord scan) {
    return Container(
      width: double.infinity,
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
      child: Row(
        children: [
          // Plant icon thumbnail
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: scan.isHealthy
                  ? AppColors.primaryMint.withOpacity(0.3)
                  : const Color(0xFFF5E0CC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.eco_rounded,
              color: scan.isHealthy ? AppColors.primary : const Color(0xFFD4722A),
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.plantName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: scan.isHealthy ? AppColors.primary : const Color(0xFFD4722A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${scan.date} • ${scan.time}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scan.isHealthy
                        ? AppColors.primaryMint.withOpacity(0.3)
                        : const Color(0xFFF5E0CC),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    scan.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: scan.isHealthy ? AppColors.primary : const Color(0xFFD4722A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryMint.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'No plants found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different search or filter',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────
class _ScanRecord {
  final String plantName;
  final String date;
  final String time;
  final String status;
  final bool isHealthy;

  const _ScanRecord({
    required this.plantName,
    required this.date,
    required this.time,
    required this.status,
    required this.isHealthy,
  });
}

class _MonthData {
  final String month;
  final int count;

  const _MonthData({
    required this.month,
    required this.count,
  });
}