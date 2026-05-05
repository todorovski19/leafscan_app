import 'package:flutter/material.dart';
import 'package:leafscan_app/models/disease_model.dart';
import 'package:leafscan_app/models/treatment_model.dart';
import 'package:leafscan_app/models/plant_simple_model.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final int diseaseId;

  const DiseaseDetailScreen({super.key, required this.diseaseId});

  @override
  State<DiseaseDetailScreen> createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
  // ── Бои (исти со останатите екрани во апликацијата) ───────────────────────
  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _orange      = Color(0xFFE8924A);
  static const Color _border      = Color(0xFF243028);
  static const Color _red         = Color(0xFFE05252);

  // ── State ─────────────────────────────────────────────────────────────────
  DiseaseModel? _disease;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDisease();
  }

  // ── Вчитување податоци ────────────────────────────────────────────────────
  // МОМЕНТАЛНО: враќа лажни податоци по 500ms (симулира мрежен повик)
  // ПОДОЦНА: замени со → GET /api/diseases/{widget.diseaseId}/
  Future<void> _loadDisease() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _disease   = DiseaseModel.mock; // ← замени со вистински API повик
        _isLoading = false;
      });
    }
  }

  // ── Боја според severity ──────────────────────────────────────────────────
  Color _severityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'LOW':    return _greenLight;
      case 'MEDIUM': return _orange;
      case 'HIGH':   return _red;
      default:       return _textMuted;
    }
  }

  // ── Икона според тип на третман ───────────────────────────────────────────
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

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _isLoading
          ? _buildLoader()
          : _disease == null
              ? _buildError()
              : _buildContent(_disease!),
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF5C9E78)),
    );
  }

  // ── Error (ако API не врати ништо) ────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFE05252), size: 48),
          const SizedBox(height: 16),
          const Text('Could not load disease info',
              style: TextStyle(color: Color(0xFFF0EDE6), fontSize: 16)),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _loadDisease();
            },
            child: const Text('Try again',
                style: TextStyle(color: Color(0xFF7CC49A))),
          ),
        ],
      ),
    );
  }

  // ── Главна содржина ───────────────────────────────────────────────────────
  Widget _buildContent(DiseaseModel disease) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(disease),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBadgesRow(disease),
                const SizedBox(height: 24),
                _buildSection('Description', disease.description),
                const SizedBox(height: 20),
                _buildSection('Symptoms', disease.symptoms),
                const SizedBox(height: 28),
                _buildTreatmentsSection(disease.treatments),
                const SizedBox(height: 28),
                _buildTopPlantsSection(disease.topPlants),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── App bar со слика или боја ─────────────────────────────────────────────
  Widget _buildAppBar(DiseaseModel disease) {
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
          child: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFFF0EDE6), size: 20),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          disease.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF0EDE6),
          ),
        ),
        background: disease.image != null
            // Кога backend врати слика — прикажи ја
            // ПОДОЦНА: Image.network(disease.image!)
            ? Container(
                decoration: BoxDecoration(
                  color: _cardDark,
                  border: Border(
                      bottom: BorderSide(color: _border, width: 1)),
                ),
                child: const Center(
                  child: Icon(Icons.image_outlined,
                      color: Color(0xFF7A9080), size: 64),
                ),
              )
            // Нема слика — прикажи икона и gradient
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _orange.withOpacity(0.15),
                      _cardDark,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _orange.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: _orange.withOpacity(0.3), width: 1),
                    ),
                    child: const Icon(Icons.coronavirus_outlined,
                        color: Color(0xFFE8924A), size: 38),
                  ),
                ),
              ),
      ),
    );
  }

  // ── Severity + Category badges ────────────────────────────────────────────
  Widget _buildBadgesRow(DiseaseModel disease) {
    final severityColor = _severityColor(disease.severity);
    return Row(
      children: [
        // Severity badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.13),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: severityColor.withOpacity(0.35), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: severityColor, size: 13),
              const SizedBox(width: 5),
              Text(
                disease.severity,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: severityColor),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border:
                Border.all(color: _green.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.category_outlined, color: _greenLight, size: 13),
              const SizedBox(width: 5),
              Text(
                disease.category,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7CC49A)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Секција (Description / Symptoms) ─────────────────────────────────────
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF0EDE6),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border, width: 1),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7A9080),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // ── Treatments секција ────────────────────────────────────────────────────
  Widget _buildTreatmentsSection(List<TreatmentModel> treatments) {
    // Групирај по тип
    final mechanical = treatments.where((t) => t.type == 'MECHANICAL').toList();
    final organic    = treatments.where((t) => t.type == 'ORGANIC').toList();
    final chemical   = treatments.where((t) => t.type == 'CHEMICAL').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Treatments',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF0EDE6)),
        ),
        const SizedBox(height: 12),
        if (mechanical.isNotEmpty) ...[
          _treatmentGroupLabel('MECHANICAL', _textMuted),
          const SizedBox(height: 8),
          ...mechanical.map((t) => _buildTreatmentCard(t)),
          const SizedBox(height: 14),
        ],
        if (organic.isNotEmpty) ...[
          _treatmentGroupLabel('ORGANIC', _greenLight),
          const SizedBox(height: 8),
          ...organic.map((t) => _buildTreatmentCard(t)),
          const SizedBox(height: 14),
        ],
        if (chemical.isNotEmpty) ...[
          _treatmentGroupLabel('CHEMICAL', _orange),
          const SizedBox(height: 8),
          ...chemical.map((t) => _buildTreatmentCard(t)),
        ],
      ],
    );
  }

  Widget _treatmentGroupLabel(String label, Color color) {
    return Row(
      children: [
        Container(width: 3, height: 14, color: color,
            margin: const EdgeInsets.only(right: 8)),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildTreatmentCard(TreatmentModel treatment) {
    final color = _treatmentColor(treatment.type);
    final icon  = _treatmentIcon(treatment.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(treatment.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF0EDE6))),
                const SizedBox(height: 4),
                Text(treatment.description,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A9080),
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Plants секција ────────────────────────────────────────────────────
  Widget _buildTopPlantsSection(List<PlantSimpleModel> plants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Most Affected Plants',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF0EDE6)),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: plants.map((plant) => _buildPlantChip(plant)).toList(),
        ),
      ],
    );
  }

  Widget _buildPlantChip(PlantSimpleModel plant) {
    return GestureDetector(
      // TODO: Кога Plant Detail екранот е готов, навигирај вака:
      // Navigator.push(context, MaterialPageRoute(
      //   builder: (_) => PlantDetailScreen(plantId: plant.id),
      // ));
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: _border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco_rounded, color: _greenLight, size: 14),
            const SizedBox(width: 6),
            Text(
              plant.name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF0EDE6)),
            ),
          ],
        ),
      ),
    );
  }
}
