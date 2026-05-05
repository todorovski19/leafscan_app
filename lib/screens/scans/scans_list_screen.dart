import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ScansListScreen — reusable screen for All / Healthy / Ill scans
// lib/screens/scans/scans_list_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

enum ScanFilter { all, healthy, ill }

class ScansListScreen extends StatefulWidget {
  final ScanFilter filter;
  const ScansListScreen({super.key, required this.filter});

  @override
  State<ScansListScreen> createState() => _ScansListScreenState();
}

class _ScansListScreenState extends State<ScansListScreen> {
  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _orange      = Color(0xFFE8924A);
  static const Color _border      = Color(0xFF243028);

  static const List<_ScanRecord> _allScans = [
    _ScanRecord(plantName: 'Tomato Plant',  date: 'Mar 20, 2026', time: '10:30 AM', status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Rose Bush',     date: 'Mar 18, 2026', time: '2:15 PM',  status: 'Early Blight',   isHealthy: false),
    _ScanRecord(plantName: 'Cucumber',      date: 'Mar 15, 2026', time: '9:45 AM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Bell Pepper',   date: 'Mar 12, 2026', time: '11:20 AM', status: 'Powdery Mildew', isHealthy: false),
    _ScanRecord(plantName: 'Basil',         date: 'Feb 28, 2026', time: '3:00 PM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Sunflower',     date: 'Feb 14, 2026', time: '8:10 AM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Mint',          date: 'Jan 30, 2026', time: '1:45 PM',  status: 'Rust Disease',   isHealthy: false),
    _ScanRecord(plantName: 'Strawberry',    date: 'Jan 10, 2026', time: '10:00 AM', status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Lavender',      date: 'Jan 5, 2026',  time: '4:00 PM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Fern',          date: 'Dec 28, 2025', time: '11:00 AM', status: 'Root Rot',       isHealthy: false),
    _ScanRecord(plantName: 'Orchid',        date: 'Dec 15, 2025', time: '2:30 PM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Cactus',        date: 'Dec 10, 2025', time: '9:00 AM',  status: 'Healthy',        isHealthy: true),
    _ScanRecord(plantName: 'Aloe Vera',     date: 'Dec 3, 2025',  time: '3:45 PM',  status: 'Leaf Spot',      isHealthy: false),
    _ScanRecord(plantName: 'Peace Lily',    date: 'Nov 22, 2025', time: '10:15 AM', status: 'Healthy',        isHealthy: true),
  ];

  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  List<_ScanRecord> get _filtered {
    var scans = _allScans.toList();
    if (widget.filter == ScanFilter.healthy) scans = scans.where((s) => s.isHealthy).toList();
    if (widget.filter == ScanFilter.ill)     scans = scans.where((s) => !s.isHealthy).toList();
    if (_searchQuery.isNotEmpty) {
      scans = scans.where((s) => s.plantName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return scans;
  }

  String get _title {
    switch (widget.filter) {
      case ScanFilter.all:     return 'All Scans';
      case ScanFilter.healthy: return 'Healthy Plants';
      case ScanFilter.ill:     return 'Ill Plants';
    }
  }

  Color get _accentColor {
    switch (widget.filter) {
      case ScanFilter.all:     return _greenLight;
      case ScanFilter.healthy: return _greenLight;
      case ScanFilter.ill:     return _orange;
    }
  }

  IconData get _headerIcon {
    switch (widget.filter) {
      case ScanFilter.all:     return Icons.document_scanner_outlined;
      case ScanFilter.healthy: return Icons.favorite_rounded;
      case ScanFilter.ill:     return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scans = _filtered;
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context, scans.length),
          Expanded(
            child: scans.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: scans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _buildScanCard(scans[i]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, int count) {
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: _cardDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _border),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(_title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
                  const Spacer(),
                  // Count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: _accentColor.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(_headerIcon, color: _accentColor, size: 14),
                        const SizedBox(width: 5),
                        Text('$count', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _accentColor)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Search
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: _cardDark,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: _border, width: 1),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(fontSize: 14, color: _textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search plants...',
                    hintStyle: const TextStyle(color: _textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded, color: _textMuted, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                      onTap: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); },
                      child: const Icon(Icons.close_rounded, color: _textMuted, size: 18),
                    )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
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

  // ── Scan card ──────────────────────────────────────────────────────────────
  Widget _buildScanCard(_ScanRecord scan) {
    final Color accent = scan.isHealthy ? _green : _orange;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.13),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.25), width: 1),
            ),
            child: Icon(Icons.eco_rounded, color: scan.isHealthy ? _greenLight : _orange, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scan.plantName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scan.isHealthy ? _greenLight : _orange)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 11, color: _textMuted),
                  const SizedBox(width: 4),
                  Text('${scan.date} · ${scan.time}', style: const TextStyle(fontSize: 11, color: _textMuted)),
                ]),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: accent.withOpacity(0.25), width: 1),
                  ),
                  child: Text(scan.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scan.isHealthy ? _greenLight : _orange)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _textMuted, size: 20),
        ],
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: _accentColor.withOpacity(0.2)),
            ),
            child: Icon(Icons.search_off_rounded, color: _accentColor, size: 32),
          ),
          const SizedBox(height: 16),
          const Text('No plants found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary)),
          const SizedBox(height: 6),
          const Text('Try a different search', style: TextStyle(fontSize: 13, color: _textMuted)),
        ],
      ),
    );
  }
}

class _ScanRecord {
  final String plantName, date, time, status;
  final bool isHealthy;
  const _ScanRecord({required this.plantName, required this.date, required this.time, required this.status, required this.isHealthy});
}