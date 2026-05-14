import 'package:flutter/material.dart';
import 'package:leafscan_app/services/api_service.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class PlantDetailScreen extends StatefulWidget {
  final int plantId;
  const PlantDetailScreen({super.key, required this.plantId});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  LeafColors get _c      => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark    => _c.cardBg;
  Color get _green       => _c.green;
  Color get _greenLight  => _c.greenLight;
  Color get _textPrimary => _c.textPrimary;
  Color get _textMuted   => _c.textMuted;
  Color get _orange      => _c.orange;
  Color get _border      => _c.border;
  Color get _red         => _c.red;

  Map<String, dynamic>? _plant;
  List<dynamic> _topDiseases = [];
  bool _isLoading = true;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadPlant();
  }

  Future<void> _loadPlant() async {
    setState(() => _isLoading = true);
    final plant    = await ApiService.getPlantById(widget.plantId);
    final diseases = await ApiService.getPlantTopDiseases(widget.plantId);
    if (!mounted) return;
    setState(() {
      _plant       = plant;
      _topDiseases = diseases;
      _isLoading   = false;
    });
  }

  Color _severityColor(String s) {
    switch (s.toUpperCase()) {
      case 'LOW':    return _greenLight;
      case 'MEDIUM': return _orange;
      case 'HIGH':   return _red;
      default:       return _textMuted;
    }
  }

  IconData _plantTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'FRUIT':     return Icons.local_florist_outlined;
      case 'VEGETABLE': return Icons.eco_outlined;
      case 'HERB':      return Icons.grass_outlined;
      case 'FLOWER':    return Icons.yard_outlined;
      case 'TREE':      return Icons.park_outlined;
      case 'CROP':      return Icons.agriculture_outlined;
      default:          return Icons.nature_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(backgroundColor: _bg, body: Center(child: CircularProgressIndicator(color: _green)));
    if (_plant == null) return Scaffold(backgroundColor: _bg, body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.error_outline_rounded, color: _red, size: 48),
        const SizedBox(height: 16),
        Text('Could not load plant info', style: TextStyle(color: _textPrimary, fontSize: 16)),
        const SizedBox(height: 20),
        TextButton(onPressed: _loadPlant, child: Text('Try again', style: TextStyle(color: _greenLight))),
      ]),
    ));

    final p              = _plant!;
    final name           = p['name']            ?? '';
    final scientificName = p['scientific_name'] ?? '';
    final type           = p['type']            ?? '';
    final desc           = p['description']     ?? '';
    final season         = p['growing_season']  ?? '—';
    final region         = p['growing_region']  ?? '—';

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: _cardDark,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: _bg.withOpacity(0.7), shape: BoxShape.circle),
                child: Icon(Icons.arrow_back_rounded, color: _textPrimary, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary)),
              background: Container(
                decoration: BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [_green.withOpacity(0.2), _cardDark],
                )),
                child: Center(child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: _green.withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: _green.withOpacity(0.3), width: 1)),
                  child: Icon(_plantTypeIcon(type), color: _greenLight, size: 38),
                )),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scientific name
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border, width: 1)),
                    child: Row(children: [
                      Icon(Icons.science_outlined, color: _textMuted, size: 16),
                      const SizedBox(width: 8),
                      Text(scientificName, style: TextStyle(fontSize: 13, color: _textMuted, fontStyle: FontStyle.italic)),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  // Badges
                  Row(children: [
                    Expanded(child: _badge(Icons.category_outlined, type, _greenLight)),
                    const SizedBox(width: 8),
                    Expanded(child: _badge(Icons.wb_sunny_outlined, season, _orange)),
                    const SizedBox(width: 8),
                    Expanded(child: _badge(Icons.location_on_outlined, region, _textMuted)),
                  ]),
                  const SizedBox(height: 24),
                  _section('Description', desc),
                  const SizedBox(height: 28),
                  // Top Diseases
                  if (_topDiseases.isNotEmpty) ...[
                    Row(children: [
                      Text('Top Diseases', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: _orange.withOpacity(0.13), borderRadius: BorderRadius.circular(50), border: Border.all(color: _orange.withOpacity(0.3), width: 1)),
                        child: Text('${_topDiseases.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFE8924A))),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    ..._topDiseases.asMap().entries.map((e) => _diseaseCard(e.value, e.key)),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2), width: 1)),
      child: Column(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _section(String title, String content) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
      const SizedBox(height: 10),
      Container(
        width: double.infinity, padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
        child: Text(content, style: TextStyle(fontSize: 14, color: _textMuted, height: 1.6)),
      ),
    ]);
  }

  Widget _diseaseCard(dynamic d, int index) {
    final isExpanded    = _expandedIndex == index;
    final name          = d['name']     ?? '';
    final severity      = d['severity'] ?? '';
    final category      = d['category'] ?? '';
    final severityColor = _severityColor(severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _cardDark, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isExpanded ? _orange.withOpacity(0.4) : _border, width: 1),
      ),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _expandedIndex = isExpanded ? null : index),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: _orange.withOpacity(0.13), borderRadius: BorderRadius.circular(10), border: Border.all(color: _orange.withOpacity(0.25), width: 1)),
                child: const Icon(Icons.coronavirus_outlined, color: Color(0xFFE8924A), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: severityColor.withOpacity(0.13), borderRadius: BorderRadius.circular(50), border: Border.all(color: severityColor.withOpacity(0.3), width: 1)),
                    child: Text(severity, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: severityColor)),
                  ),
                  const SizedBox(width: 6),
                  Text(category, style: TextStyle(fontSize: 11, color: _textMuted)),
                ]),
              ])),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.keyboard_arrow_down_rounded, color: _textMuted, size: 22),
              ),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(color: _border, height: 1),
              const SizedBox(height: 8),
              Text(d['description'] ?? '', style: TextStyle(fontSize: 13, color: _textMuted, height: 1.5)),
            ]),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ]),
    );
  }
}
