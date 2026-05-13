import 'package:flutter/material.dart';
import 'package:leafscan_app/screens/history/scan_detail_screen.dart';
import 'package:leafscan_app/services/api_service.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark    => _c.cardBg;
  Color get _green       => _c.green;
  Color get _greenLight  => _c.greenLight;
  Color get _textPrimary => _c.textPrimary;
  Color get _textMuted   => _c.textMuted;
  Color get _orange      => _c.orange;
  Color get _border      => _c.border;
  Color get _headerBg    => _c.headerBg;

  List<dynamic> _analyses = [];
  bool _loading = true;
  int _selectedFilter = 0;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAnalyses();
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _loadAnalyses() async {
    final data = await ApiService.getMyAnalyses();
    if (!mounted) return;
    setState(() { _analyses = data; _loading = false; });
  }

  List<dynamic> get _filtered {
    var list = _analyses.toList();
    if (_selectedFilter == 1) list = list.where((a) => a['result_label'] == 'HEALTHY').toList();
    if (_selectedFilter == 2) list = list.where((a) => a['result_label'] == 'INFECTED').toList();
    if (_searchQuery.isNotEmpty) {
      list = list.where((a) => (a['plant']?['name'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  int get _totalCount    => _analyses.length;
  int get _healthyCount  => _analyses.where((a) => a['result_label'] == 'HEALTHY').length;
  int get _diseasedCount => _analyses.where((a) => a['result_label'] == 'INFECTED').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: _green))
                : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  _buildFilterTabs(),
                  const SizedBox(height: 16),
                  ..._filtered.isEmpty
                      ? [_buildEmptyState()]
                      : _filtered.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildScanCard(a),
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

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(color: _headerBg, border: Border(bottom: BorderSide(color: _border, width: 1))),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Scan History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textPrimary)),
              const SizedBox(height: 14),
              Container(
                height: 46,
                decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(50), border: Border.all(color: _border, width: 1)),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: TextStyle(fontSize: 14, color: _textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search plants...',
                    hintStyle: TextStyle(color: _textMuted, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: _textMuted, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(onTap: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); }, child: Icon(Icons.close_rounded, color: _textMuted, size: 18))
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

  Widget _buildStatsRow() {
    return Row(children: [
      _statChip('Total', '$_totalCount',    _greenLight),
      const SizedBox(width: 10),
      _statChip('Healthy',  '$_healthyCount',  _greenLight),
      const SizedBox(width: 10),
      _statChip('Infected', '$_diseasedCount', _orange),
    ]);
  }

  Widget _statChip(String label, String value, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: _textMuted)),
      ]),
    ));
  }

  Widget _buildFilterTabs() {
    return Row(children: [
      _filterTab(0, 'All ($_totalCount)'), const SizedBox(width: 8),
      _filterTab(1, '✅ Healthy'), const SizedBox(width: 8),
      _filterTab(2, '⚠️ Infected'),
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

  Widget _buildScanCard(dynamic analysis) {
    final isHealthy  = analysis['result_label'] == 'HEALTHY';
    final plantName  = analysis['plant']?['name'] ?? 'Unknown Plant';
    final diseaseName= analysis['disease']?['name'] ?? '';
    final confidence = analysis['confidence'] ?? 0;
    final createdAt  = analysis['created_at'] ?? '';
    final date       = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
    final Color accent = isHealthy ? _green : _orange;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ScanDetailScreen(
          data: sampleDetailFromRecord(
            plantName: plantName,
            date: date,
            time: '',
            isHealthy: isHealthy,
            status: isHealthy ? 'Healthy' : diseaseName,
          ),
        ),
      )),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: accent.withOpacity(0.13), borderRadius: BorderRadius.circular(14), border: Border.all(color: accent.withOpacity(0.25), width: 1)),
              child: Icon(Icons.eco_rounded, color: isHealthy ? _greenLight : _orange, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(plantName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isHealthy ? _greenLight : _orange)),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.calendar_today_outlined, size: 11, color: _textMuted),
                const SizedBox(width: 4),
                Text(date, style: TextStyle(fontSize: 11, color: _textMuted)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: accent.withOpacity(0.13), borderRadius: BorderRadius.circular(50), border: Border.all(color: accent.withOpacity(0.25), width: 1)),
                  child: Text(isHealthy ? 'Healthy' : diseaseName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isHealthy ? _greenLight : _orange)),
                ),
                const SizedBox(width: 8),
                Text('${confidence}%', style: TextStyle(fontSize: 11, color: _textMuted)),
              ]),
            ])),
            Icon(Icons.chevron_right_rounded, color: _textMuted, size: 20),
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
            child: Icon(Icons.history_rounded, color: _greenLight, size: 30)),
        const SizedBox(height: 16),
        Text('No scans yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary)),
        const SizedBox(height: 6),
        Text('Start scanning your plants!', style: TextStyle(fontSize: 13, color: _textMuted)),
      ])),
    );
  }
}
