import 'package:flutter/material.dart';
import 'package:leafscan_app/models/disease_model.dart';
import 'package:leafscan_app/models/treatment_model.dart';
import 'package:leafscan_app/models/plant_simple_model.dart';
import 'package:leafscan_app/screens/plant/plant_detail_screen.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final int diseaseId;
  const DiseaseDetailScreen({super.key, required this.diseaseId});

  @override
  State<DiseaseDetailScreen> createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
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

  DiseaseModel? _disease;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDisease();
  }

  Future<void> _loadDisease() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _disease   = DiseaseModel.mock;
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

  Widget _buildLoader() => const Center(
    child: CircularProgressIndicator(color: Color(0xFF5C9E78)),
  );

  Widget _buildError() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline_rounded, color: Color(0xFFE05252), size: 48),
        const SizedBox(height: 16),
        Text('Could not load disease info',
            style: TextStyle(color: _textPrimary, fontSize: 16)),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () { setState(() => _isLoading = true); _loadDisease(); },
          child: const Text('Try again',
              style: TextStyle(color: Color(0xFF7CC49A))),
        ),
      ],
    ),
  );

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
          child: Icon(Icons.arrow_back_rounded,
              color: _textPrimary, size: 20),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(disease.name,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: _textPrimary)),
        background: disease.image != null
            ? Container(
            color: _cardDark,
            child: Center(child: Icon(Icons.image_outlined,
                color: _textMuted, size: 64)))
            : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_orange.withOpacity(0.15), _cardDark],
            ),
          ),
          child: Center(
            child: Container(
              width: 80, height: 80,
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

  Widget _buildBadgesRow(DiseaseModel disease) {
    final severityColor = _severityColor(disease.severity);
    return Row(
      children: [
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
              Text(disease.severity,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: severityColor)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: _green.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.category_outlined, color: _greenLight, size: 13),
              const SizedBox(width: 5),
              Text(disease.category,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: Color(0xFF7CC49A))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
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
              style: TextStyle(fontSize: 14, color: _textMuted,
                  height: 1.6)),
        ),
      ],
    );
  }

  Widget _buildTreatmentsSection(List<TreatmentModel> treatments) {
    final mechanical = treatments.where((t) => t.type == 'MECHANICAL').toList();
    final organic    = treatments.where((t) => t.type == 'ORGANIC').toList();
    final chemical   = treatments.where((t) => t.type == 'CHEMICAL').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Treatments',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                color: _textPrimary)),
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
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                color: color, letterSpacing: 0.5)),
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
            width: 36, height: 36,
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                        color: _textPrimary)),
                const SizedBox(height: 4),
                Text(treatment.description,
                    style: TextStyle(fontSize: 12, color: _textMuted,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPlantsSection(List<PlantSimpleModel> plants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Most Affected Plants',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                color: _textPrimary)),
        const SizedBox(height: 12),
        ...plants.map((plant) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildPlantRow(plant),
        )),
      ],
    );
  }

  Widget _buildPlantRow(PlantSimpleModel plant) {
    return Row(
      children: [
        Container(
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
              Text(plant.name,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: _textPrimary)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlantDetailScreen(plantId: plant.id),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: _green.withOpacity(0.13),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: _green.withOpacity(0.35), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Learn More',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _greenLight)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, color: _greenLight, size: 13),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
