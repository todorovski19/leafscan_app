import 'package:flutter/material.dart';
import 'package:leafscan_app/screens/plant/plant_detail_screen.dart';
import 'package:leafscan_app/services/api_service.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final int diseaseId;
  const DiseaseDetailScreen({super.key, required this.diseaseId});

  @override
  State<DiseaseDetailScreen> createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
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

  Map<String, dynamic>? _disease;
  List<dynamic> _treatments = [];
  List<dynamic> _topPlants  = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDisease();
  }

  Future<void> _loadDisease() async {
    setState(() => _isLoading = true);
    final disease    = await ApiService.getDiseaseById(widget.diseaseId);
    final treatments = await ApiService.getDiseaseTreatments(widget.diseaseId);
    if (!mounted) return;
    setState(() {
      _disease    = disease;
      _treatments = treatments;
      _isLoading  = false;
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

  IconData _treatmentIcon(String type) {
    switch (type.toUpperCase()) {
      case 'MECHANICAL': return Icons.build_outlined;
      case 'ORGANIC':    return Icons.eco_outlined;
      case 'CHEMICAL':   return Icons.science_outlined;
      default:           return Icons.healing_outlined;
    }
  }

  Color _treatmentColor(String type) {
    switch (type.toUpperCase()) {
      case 'MECHANICAL': return _textMuted;
      case 'ORGANIC':    return _greenLight;
      case 'CHEMICAL':   return _orange;
      default:           return _textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(backgroundColor: _bg, body: Center(child: CircularProgressIndicator(color: _green)));
    if (_disease == null) return Scaffold(backgroundColor: _bg, body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.error_outline_rounded, color: _red, size: 48),
        const SizedBox(height: 16),
        Text('Could not load disease info', style: TextStyle(color: _textPrimary, fontSize: 16)),
        const SizedBox(height: 20),
        TextButton(onPressed: _loadDisease, child: Text('Try again', style: TextStyle(color: _greenLight))),
      ]),
    ));

    final d        = _disease!;
    final name     = d['name']        ?? '';
    final category = d['category']    ?? '';
    final severity = d['severity']    ?? '';
    final desc     = d['description'] ?? '';
    final symptoms = d['symptomes']   ?? d['symptoms'] ?? '';

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
                  colors: [_orange.withOpacity(0.15), _cardDark],
                )),
                child: Center(child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: _orange.withOpacity(0.15), shape: BoxShape.circle, border: Border.all(color: _orange.withOpacity(0.3), width: 1)),
                  child: const Icon(Icons.coronavirus_outlined, color: Color(0xFFE8924A), size: 38),
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
                  // Badges
                  Row(children: [
                    _badge(severity, _severityColor(severity), Icons.warning_amber_rounded),
                    const SizedBox(width: 10),
                    _badge(category, _greenLight, Icons.category_outlined),
                  ]),
                  const SizedBox(height: 24),
                  _section('Description', desc),
                  const SizedBox(height: 20),
                  if (symptoms.isNotEmpty) ...[
                    _section('Symptoms', symptoms),
                    const SizedBox(height: 28),
                  ],
                  // Treatments
                  if (_treatments.isNotEmpty) ...[
                    Text('Treatments', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
                    const SizedBox(height: 12),
                    ..._treatments.map((t) => _treatmentCard(t)),
                    const SizedBox(height: 28),
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

  Widget _badge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
          child: Text(content, style: TextStyle(fontSize: 14, color: _textMuted, height: 1.6)),
        ),
      ],
    );
  }

  Widget _treatmentCard(dynamic t) {
    final type  = t['type']        ?? 'OTHER';
    final name  = t['name']        ?? '';
    final desc  = t['description'] ?? '';
    final color = _treatmentColor(type);
    final icon  = _treatmentIcon(type);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border, width: 1)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.13), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 12, color: _textMuted, height: 1.5)),
        ])),
      ]),
    );
  }
}
