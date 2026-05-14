import 'package:flutter/material.dart';
import 'package:leafscan_app/screens/history/scan_detail_screen.dart';
import 'package:leafscan_app/services/api_service.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

enum ScanFilter { all, healthy, ill }

class ScansListScreen extends StatefulWidget {
  final ScanFilter filter;
  const ScansListScreen({super.key, required this.filter});

  @override
  State<ScansListScreen> createState() => _ScansListScreenState();
}

class _ScansListScreenState extends State<ScansListScreen> {
  LeafColors get _c     => LeafColors.of(context);
  Color get _bg         => _c.bg;
  Color get _cardDark   => _c.cardBg;
  Color get _green      => _c.green;
  Color get _greenLight => _c.greenLight;
  Color get _textPrimary=> _c.textPrimary;
  Color get _textMuted  => _c.textMuted;
  Color get _orange     => _c.orange;
  Color get _border     => _c.border;
  Color get _headerBg   => _c.headerBg;

  List<dynamic> _allScans = [];
  bool _loading = true;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _loadScans(); }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _loadScans() async {
    final data = await ApiService.getMyAnalyses();
    if (!mounted) return;
    setState(() { _allScans = data; _loading = false; });
  }

  List<dynamic> get _filtered {
    var list = _allScans.toList();
    if (widget.filter == ScanFilter.healthy) list = list.where((a) => a['result_label'] == 'HEALTHY').toList();
    if (widget.filter == ScanFilter.ill)     list = list.where((a) => a['result_label'] == 'INFECTED').toList();
    if (_searchQuery.isNotEmpty) {
      list = list.where((a) => (a['plant_name'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
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
                : _filtered.isEmpty
                ? _buildEmpty()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCard(_filtered[i]),
              ),
            ),
          ),
        ],
      ),
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
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(width: 38, height: 38,
                      decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                      child: Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20)),
                ),
                const SizedBox(width: 14),
                Text(_title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
              ]),
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

  Widget _buildCard(dynamic a) {
    final isHealthy  = a['result_label'] == 'HEALTHY';
    final plantName  = a['plant_name']   ?? 'Unknown Plant';
    final diseaseName= a['disease_name'] ?? '';
    final createdAt  = a['created_at']   ?? '';
    final date       = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
    final confidence = ((a['confidence'] as num? ?? 0) * 100).round();
    final plantId    = a['plant_id']    as int?;
    final diseaseId  = a['disease_id']  as int?;
    final Color accent = isHealthy ? _green : _orange;

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => ScanDetailScreen(
          data: ScanDetailData(
            plantName:   plantName,
            date:        date,
            time:        '',
            isHealthy:   isHealthy,
            diseaseName: isHealthy ? null : diseaseName,
            confidence:  confidence,
            plantId:     plantId,
            diseaseId:   isHealthy ? null : diseaseId,
          ),
        ),
      )),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
        child: Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: accent.withOpacity(0.13), borderRadius: BorderRadius.circular(13), border: Border.all(color: accent.withOpacity(0.25), width: 1)),
            child: Icon(Icons.eco_rounded, color: isHealthy ? _greenLight : _orange, size: 24),
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
              Text('$confidence%', style: TextStyle(fontSize: 11, color: _textMuted)),
            ]),
          ])),
          Icon(Icons.chevron_right_rounded, color: _textMuted, size: 20),
        ]),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 64, height: 64,
          decoration: BoxDecoration(color: _green.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: _green.withOpacity(0.2))),
          child: Icon(Icons.eco_outlined, color: _greenLight, size: 30)),
      const SizedBox(height: 16),
      Text('No scans found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary)),
      const SizedBox(height: 6),
      Text('Start scanning your plants!', style: TextStyle(fontSize: 13, color: _textMuted)),
    ]));
  }
}
