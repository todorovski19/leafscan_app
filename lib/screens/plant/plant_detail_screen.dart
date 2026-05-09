import 'package:flutter/material.dart';
import 'package:leafscan_app/models/plant_model.dart';
import 'package:leafscan_app/models/treatment_model.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class PlantDetailScreen extends StatefulWidget {
  final int plantId;
  const PlantDetailScreen({super.key, required this.plantId});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark          => _c.cardBg;
  Color get _green          => _c.green;
  Color get _greenLight          => _c.greenLight;
  Color get _textPrimary          => _c.textPrimary;
  Color get _textMuted          => _c.textMuted;
  Color get _orange          => _c.orange;
  Color get _border          => _c.border;
  Color get _red          => _c.red;
  Color get _headerBg    => _c.headerBg;

  PlantModel? _plant;
  bool _isLoading = true;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadPlant();
  }

  Future<void> _loadPlant() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _plant     = PlantModel.mock;
        _isLoading = false;
      });
    }
  }

  Color _severityColor(String severity) {
    switch (severity.toUpperCase()) {
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

  IconData _plantTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'FRUIT':      return Icons.local_florist_outlined;
      case 'VEGETABLE':  return Icons.eco_outlined;
      case 'HERB':       return Icons.grass_outlined;
      case 'FLOWER':     return Icons.yard_outlined;
      case 'TREE':       return Icons.park_outlined;
      case 'CROP':       return Icons.agriculture_outlined;
      default:           return Icons.nature_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _isLoading
          ? _buildLoader()
          : _plant == null
              ? _buildError()
              : _buildContent(_plant!),
    );
  }

  Widget _buildLoader() => const Center(
    child: CircularProgressIndicator(color: Color(0xFF5C9E78)),
  );

  Widget _buildError() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline_rounded, color: Color(0xFFE05252), size: 48),
        const SizedBox(height: 16),
        Text('Could not load plant info',
            style: TextStyle(color: _textPrimary, fontSize: 16)),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () { setState(() => _isLoading = true); _loadPlant(); },
          child: const Text('Try again', style: TextStyle(color: Color(0xFF7CC49A))),
        ),
      ],
    ),
  );

  Widget _buildContent(PlantModel plant) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(plant),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Scientific name
                _buildScientificName(plant),
                const SizedBox(height: 12),
                // Info badges — Type, Season, Region
                _buildInfoBadges(plant),
                const SizedBox(height: 24),
                // Description
                _buildSection('Description', plant.description),
                const SizedBox(height: 28),
                // Top diseases со expandable третмани
                _buildTopDiseasesSection(plant),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── App bar ───────────────────────────────────────────────────────────────
  Widget _buildAppBar(PlantModel plant) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: _cardDark,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _bg.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_rounded,
              color: _textPrimary, size: 20),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(plant.name,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: _textPrimary)),
        background: plant.image != null
            ? Container(color: _cardDark,
                child: Center(child: Icon(Icons.image_outlined,
                    color: _textMuted, size: 64)))
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_green.withOpacity(0.2), _cardDark],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: _green.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: _green.withOpacity(0.3), width: 1),
                    ),
                    child: Icon(_plantTypeIcon(plant.type),
                        color: _greenLight, size: 38),
                  ),
                ),
              ),
      ),
    );
  }

  // ── Scientific name ───────────────────────────────────────────────────────
  Widget _buildScientificName(PlantModel plant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, color: _textMuted, size: 16),
          const SizedBox(width: 8),
          Text(plant.scientificName,
              style: TextStyle(
                  fontSize: 13, color: _textMuted,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  // ── Info badges ───────────────────────────────────────────────────────────
  Widget _buildInfoBadges(PlantModel plant) {
    return Row(
      children: [
        Expanded(child: _badge(Icons.category_outlined, plant.type, _greenLight)),
        const SizedBox(width: 8),
        Expanded(child: _badge(Icons.wb_sunny_outlined, plant.growingSeason, _orange)),
        const SizedBox(width: 8),
        Expanded(child: _badge(Icons.location_on_outlined, plant.growingRegion, _textMuted)),
      ],
    );
  }

  Widget _badge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 5),
          Text(label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  // ── Description  ───────────────────────────────────────────────────
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700,
                color: _textPrimary)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border, width: 1),
          ),
          child: Text(content,
              style: TextStyle(
                  fontSize: 14, color: _textMuted, height: 1.6)),
        ),
      ],
    );
  }

  // ── Top Diseases  ────────────────────────────
  Widget _buildTopDiseasesSection(PlantModel plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Top Diseases',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: _textPrimary)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _orange.withOpacity(0.13),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: _orange.withOpacity(0.3), width: 1),
              ),
              child: Text('${plant.topDiseases.length}',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: Color(0xFFE8924A))),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...plant.topDiseases.asMap().entries.map((entry) {
          final index   = entry.key;
          final disease = entry.value;
          final isExpanded = _expandedIndex == index;
          return _buildDiseaseCard(disease, index, isExpanded);
        }),
      ],
    );
  }

  Widget _buildDiseaseCard(DiseaseSimpleModel disease, int index, bool isExpanded) {
    final severityColor = _severityColor(disease.severity);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? _orange.withOpacity(0.4) : _border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() =>
                _expandedIndex = isExpanded ? null : index),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: _orange.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _orange.withOpacity(0.25), width: 1),
                    ),
                    child: const Icon(Icons.coronavirus_outlined,
                        color: Color(0xFFE8924A), size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Ime + severity
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(disease.name,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600,
                                color: _textPrimary)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: severityColor.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: severityColor.withOpacity(0.3),
                                    width: 1),
                              ),
                              child: Text(disease.severity,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: severityColor)),
                            ),
                            const SizedBox(width: 6),
                            Text(disease.category,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: _textMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: _textMuted, size: 22),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: disease.treatments.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Text('No treatments available.',
                        style: TextStyle(
                            fontSize: 13, color: _textMuted)),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: _border, height: 1),
                        const SizedBox(height: 12),
                        Text('Treatments',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _textMuted,
                                letterSpacing: 0.4)),
                        const SizedBox(height: 10),
                        ...disease.treatments.map(
                            (t) => _buildTreatmentRow(t)),
                      ],
                    ),
                  ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentRow(TreatmentModel treatment) {
    final color = _treatmentColor(treatment.type);
    final icon  = _treatmentIcon(treatment.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(treatment.name,
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: _textPrimary)),
                const SizedBox(height: 3),
                Text(treatment.description,
                    style: TextStyle(
                        fontSize: 12, color: _textMuted,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
