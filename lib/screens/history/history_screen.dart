import 'package:flutter/material.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';
import 'package:leafscan_app/screens/disease/disease_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _orange      = Color(0xFFE8924A);
  static const Color _border      = Color(0xFF243028);

  static const List<_ScanRecord> _allScans = [
    _ScanRecord(plantName: 'Tomato Plant',  date: 'Mar 20, 2026', time: '10:30 AM', status: 'Healthy',        isHealthy: true,  diseaseId: null),
    _ScanRecord(plantName: 'Rose Bush',     date: 'Mar 18, 2026', time: '2:15 PM',  status: 'Early Blight',   isHealthy: false, diseaseId: 999),
    _ScanRecord(plantName: 'Cucumber',      date: 'Mar 15, 2026', time: '9:45 AM',  status: 'Healthy',        isHealthy: true,  diseaseId: null),
    _ScanRecord(plantName: 'Bell Pepper',   date: 'Mar 12, 2026', time: '11:20 AM', status: 'Powdery Mildew', isHealthy: false, diseaseId: 999),
    _ScanRecord(plantName: 'Basil',         date: 'Feb 28, 2026', time: '3:00 PM',  status: 'Healthy',        isHealthy: true,  diseaseId: null),
    _ScanRecord(plantName: 'Sunflower',     date: 'Feb 14, 2026', time: '8:10 AM',  status: 'Healthy',        isHealthy: true,  diseaseId: null),
    _ScanRecord(plantName: 'Mint',          date: 'Jan 30, 2026', time: '1:45 PM',  status: 'Rust Disease',   isHealthy: false, diseaseId: 999),
    _ScanRecord(plantName: 'Strawberry',    date: 'Jan 10, 2026', time: '10:00 AM', status: 'Healthy',        isHealthy: true,  diseaseId: null),
  ];

  static const List<_MonthData> _monthlyData = [
    _MonthData(month: 'Jan', count: 2),
    _MonthData(month: 'Feb', count: 3),
    _MonthData(month: 'Mar', count: 5),
  ];

  int _selectedFilter = 0;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  List<_ScanRecord> get _filteredScans {
    var scans = _allScans.toList();
    if (_selectedFilter == 1) scans = scans.where((s) => s.isHealthy).toList();
    if (_selectedFilter == 2) scans = scans.where((s) => !s.isHealthy).toList();
    if (_searchQuery.isNotEmpty) scans = scans.where((s) => s.plantName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    return scans;
  }

  int get _totalCount    => _allScans.length;
  int get _healthyCount  => _allScans.where((s) => s.isHealthy).length;
  int get _diseasedCount => _allScans.where((s) => !s.isHealthy).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
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
                      : _filteredScans.map((s) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildScanCard(s))),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A211D),
        border: Border(bottom: BorderSide(color: Color(0xFF243028), width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Scan History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textPrimary)),
              const SizedBox(height: 14),
              Container(
                height: 46,
                decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(50), border: Border.all(color: _border, width: 1)),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(fontSize: 14, color: _textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search plants...',
                    hintStyle: const TextStyle(color: _textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded, color: _textMuted, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(onTap: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); }, child: const Icon(Icons.close_rounded, color: _textMuted, size: 18))
                        : null,
                    border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13), filled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: _border, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Monthly Scans', style: TextStyle(fontSize: 12, color: _greenLight, fontWeight: FontWeight.w500)),
                Text('$_totalCount', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: _textPrimary, height: 1.1)),
              ]),
              Container(width: 36, height: 36, decoration: BoxDecoration(color: _green.withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: _green.withOpacity(0.3))),
                  child: const Icon(Icons.trending_up_rounded, color: _greenLight, size: 18)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _monthlyData.map((data) {
                final max = _monthlyData.map((d) => d.count).reduce((a, b) => a > b ? a : b);
                final h = max == 0 ? 0.0 : 65.0 * (data.count / max);
                return Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(height: h, decoration: BoxDecoration(color: _green.withOpacity(0.5), borderRadius: BorderRadius.circular(8), border: Border.all(color: _greenLight.withOpacity(0.3), width: 1))),
                    const SizedBox(height: 6),
                    Text(data.month, style: const TextStyle(fontSize: 12, color: _textMuted)),
                  ]),
                ));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(children: [
      _filterTab(0, 'All ($_totalCount)'), const SizedBox(width: 8),
      _filterTab(1, 'Healthy ($_healthyCount)'), const SizedBox(width: 8),
      _filterTab(2, 'Diseased ($_diseasedCount)'),
    ]);
  }

  Widget _filterTab(int index, String label) {
    final bool isActive = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _green.withOpacity(0.2) : _cardDark,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: isActive ? _green.withOpacity(0.6) : _border, width: 1),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? _greenLight : _textMuted)),
      ),
    );
  }

  Widget _buildScanCard(_ScanRecord scan) {
    final Color accent = scan.isHealthy ? _green : _orange;
    return GestureDetector(
      // ── ДОДАДЕНО: onTap за навигација ──────────────────────────────────────
      // Ако скенирањето е болесно и има diseaseId → оди на Disease Detail
      // Ако е здраво → засега ништо (подоцна: Scan Detail екран)
      onTap: !scan.isHealthy && scan.diseaseId != null
          ? () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DiseaseDetailScreen(diseaseId: scan.diseaseId!),
        ),
      )
          : null,
      // ───────────────────────────────────────────────────────────────────────
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: accent.withOpacity(0.13), borderRadius: BorderRadius.circular(14), border: Border.all(color: accent.withOpacity(0.25), width: 1)),
              child: Icon(Icons.eco_rounded, color: scan.isHealthy ? _greenLight : _orange, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(scan.plantName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scan.isHealthy ? _greenLight : _orange)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 11, color: _textMuted), const SizedBox(width: 4),
                Text('${scan.date} · ${scan.time}', style: const TextStyle(fontSize: 11, color: _textMuted)),
              ]),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: accent.withOpacity(0.13), borderRadius: BorderRadius.circular(50), border: Border.all(color: accent.withOpacity(0.25), width: 1)),
                child: Text(scan.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scan.isHealthy ? _greenLight : _orange)),
              ),
            ])),
            const Icon(Icons.chevron_right_rounded, color: _textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(child: Column(children: [
        Container(width: 64, height: 64, decoration: BoxDecoration(color: _green.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: _green.withOpacity(0.2))),
            child: const Icon(Icons.search_off_rounded, color: _greenLight, size: 30)),
        const SizedBox(height: 16),
        const Text('No plants found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary)),
        const SizedBox(height: 6),
        const Text('Try a different search or filter', style: TextStyle(fontSize: 13, color: _textMuted)),
      ])),
    );
  }
}

class _ScanRecord {
  final String plantName, date, time, status;
  final bool isHealthy;
  final int? diseaseId;

  const _ScanRecord({
    required this.plantName,
    required this.date,
    required this.time,
    required this.status,
    required this.isHealthy,
    required this.diseaseId,
  });
}

class _MonthData {
  final String month;
  final int count;
  const _MonthData({required this.month, required this.count});
}