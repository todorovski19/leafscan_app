import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ScanDetailScreen — shows full diagnosis details for a scan record
// Place in: lib/screens/history/scan_detail_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class ScanDetailScreen extends StatelessWidget {
  final ScanDetailData data;
  const ScanDetailScreen({super.key, required this.data});

  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _orange      = Color(0xFFE8924A);
  static const Color _border      = Color(0xFF243028);
  static const Color _orangeBg    = Color(0xFF2A1F15);

  Color get _accent => data.isHealthy ? _green : _orange;
  Color get _accentLight => data.isHealthy ? _greenLight : _orange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroImage(),
                  _buildDiagnosisHeader(),
                  const SizedBox(height: 12),
                  if (!data.isHealthy) ...[
                    _buildInfoSection(),
                    const SizedBox(height: 12),
                    _buildSeveritySection(),
                    const SizedBox(height: 12),
                    _buildTreatmentPlan(),
                    const SizedBox(height: 12),
                    _buildAdditionalTips(),
                  ] else ...[
                    _buildHealthySection(),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  // ── Hero image with back button overlay ───────────────────────────────────
  Widget _buildHeroImage() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          color: const Color(0xFF0D1510),
          child: data.imagePath != null
              ? Image.asset(data.imagePath!, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImagePlaceholder())
              : _buildImagePlaceholder(),
        ),
        // Gradient overlay bottom
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, _bg.withOpacity(0.9)],
              ),
            ),
          ),
        ),
        // Back button
        Positioned(
          top: 0, left: 0, right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Builder(builder: (ctx) => GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF0D1510),
      child: Center(
        child: Icon(Icons.eco_rounded, color: _green.withOpacity(0.3), size: 64),
      ),
    );
  }

  // ── Diagnosis header ───────────────────────────────────────────────────────
  Widget _buildDiagnosisHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: _cardDark,
        border: Border(bottom: BorderSide(color: _border, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status label
                Text(
                  data.isHealthy ? 'Healthy Plant' : 'Disease Detected',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _accentLight,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                // Plant name / disease name
                Text(
                  data.isHealthy ? data.plantName : data.diseaseName ?? data.plantName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _textPrimary),
                ),
                const SizedBox(height: 2),
                // Scientific name or subtitle
                if (data.scientificName != null)
                  Text(
                    data.scientificName!,
                    style: const TextStyle(fontSize: 13, color: _textMuted, fontStyle: FontStyle.italic),
                  ),
                const SizedBox(height: 8),
                // Date row
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 12, color: _textMuted),
                  const SizedBox(width: 5),
                  Text(
                    'Analyzed on ${data.date}',
                    style: const TextStyle(fontSize: 12, color: _textMuted),
                  ),
                ]),
              ],
            ),
          ),
          // Confidence badge
          if (data.confidence != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${data.confidence}%',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _accentLight),
                ),
                const Text('Confidence', style: TextStyle(fontSize: 11, color: _textMuted)),
              ],
            ),
        ],
      ),
    );
  }

  // ── What is [Disease] section ──────────────────────────────────────────────
  Widget _buildInfoSection() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.info_outline_rounded, color: _accentLight, size: 18),
            const SizedBox(width: 8),
            Text(
              'What is ${data.diseaseName ?? data.plantName}?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _accentLight),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            data.description ?? '',
            style: const TextStyle(fontSize: 13, color: _textMuted, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ── Severity bar ───────────────────────────────────────────────────────────
  Widget _buildSeveritySection() {
    final double fraction = _severityFraction(data.severity);
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Disease Severity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
              Text(
                data.severity ?? 'Unknown',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _accentLight),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 6,
            decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(50)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _severityFraction(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'low':      return 0.25;
      case 'moderate': return 0.65;
      case 'high':     return 0.85;
      case 'severe':   return 1.0;
      default:         return 0.5;
    }
  }

  // ── Treatment plan ─────────────────────────────────────────────────────────
  Widget _buildTreatmentPlan() {
    if (data.treatments == null || data.treatments!.isEmpty) return const SizedBox.shrink();
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Treatment Plan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
          const SizedBox(height: 12),
          ...data.treatments!.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _treatmentTile(t),
          )),
        ],
      ),
    );
  }

  Widget _treatmentTile(TreatmentStep step) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _green.withOpacity(0.13),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _green.withOpacity(0.25)),
            ),
            child: Icon(step.icon, color: _greenLight, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textPrimary)),
                const SizedBox(height: 2),
                Text(step.description, style: const TextStyle(fontSize: 12, color: _textMuted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Additional tips ────────────────────────────────────────────────────────
  Widget _buildAdditionalTips() {
    if (data.tips == null || data.tips!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _orangeBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _orange.withOpacity(0.25), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.tips_and_updates_outlined, color: _orange, size: 16),
              const SizedBox(width: 6),
              const Text('Additional Tips', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _orange)),
            ]),
            const SizedBox(height: 10),
            ...data.tips!.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 5, right: 8),
                      decoration: const BoxDecoration(color: _orange, shape: BoxShape.circle)),
                  Expanded(child: Text(tip, style: const TextStyle(fontSize: 12, color: Color(0xFF9A6030), height: 1.4))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  // ── Healthy state ──────────────────────────────────────────────────────────
  Widget _buildHealthySection() {
    return _sectionCard(
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: _green.withOpacity(0.13),
              shape: BoxShape.circle,
              border: Border.all(color: _green.withOpacity(0.25)),
            ),
            child: const Icon(Icons.favorite_rounded, color: _greenLight, size: 28),
          ),
          const SizedBox(height: 14),
          const Text('Plant is Healthy!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _greenLight)),
          const SizedBox(height: 6),
          const Text(
            'No signs of disease detected. Keep up the good care!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: _textMuted, height: 1.5),
          ),
          const SizedBox(height: 16),
          if (data.tips != null && data.tips!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Color(0xFF243028), height: 1),
                const SizedBox(height: 14),
                const Text('Care Tips', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _greenLight)),
                const SizedBox(height: 10),
                ...data.tips!.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 5, right: 8),
                          decoration: const BoxDecoration(color: _green, shape: BoxShape.circle)),
                      Expanded(child: Text(tip, style: const TextStyle(fontSize: 12, color: _textMuted, height: 1.4))),
                    ],
                  ),
                )),
              ],
            ),
        ],
      ),
    );
  }

  // ── Bottom action bar ──────────────────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: _cardDark,
        border: Border(top: BorderSide(color: _border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Save Report
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Report saved!'),
                    backgroundColor: _green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _border, width: 1),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_outlined, color: _textMuted, size: 18),
                      SizedBox(width: 6),
                      Text('Save Report', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textMuted)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Scan Another
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'Scan Another',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _sectionCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border, width: 1),
        ),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────

class ScanDetailData {
  final String plantName;
  final String date;
  final String time;
  final bool isHealthy;
  final String? diseaseName;
  final String? scientificName;
  final int? confidence;
  final String? severity;
  final String? description;
  final String? imagePath;
  final List<TreatmentStep>? treatments;
  final List<String>? tips;

  const ScanDetailData({
    required this.plantName,
    required this.date,
    required this.time,
    required this.isHealthy,
    this.diseaseName,
    this.scientificName,
    this.confidence,
    this.severity,
    this.description,
    this.imagePath,
    this.treatments,
    this.tips,
  });
}

class TreatmentStep {
  final String title;
  final String description;
  final IconData icon;

  const TreatmentStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Sample data factory — maps the existing _ScanRecord fields to ScanDetailData
// ─────────────────────────────────────────────────────────────────────────────

ScanDetailData sampleDetailFromRecord({
  required String plantName,
  required String date,
  required String time,
  required bool isHealthy,
  required String status,
}) {
  if (isHealthy) {
    return ScanDetailData(
      plantName: plantName,
      date: date,
      time: time,
      isHealthy: true,
      confidence: 95,
      tips: [
        'Continue regular watering schedule',
        'Ensure adequate sunlight exposure daily',
        'Check for pests every 1–2 weeks',
        'Feed with balanced fertilizer monthly',
      ],
    );
  }

  // Map known diseases to detail data
  final Map<String, ScanDetailData Function()> diseaseMap = {
    'Early Blight': () => ScanDetailData(
      plantName: plantName, date: date, time: time, isHealthy: false,
      diseaseName: 'Early Blight',
      scientificName: 'Alternaria solani',
      confidence: 78,
      severity: 'Moderate',
      description:
      'Early blight is a common fungal disease that affects tomatoes and potatoes. '
          'It appears as dark brown spots with concentric rings on older leaves, '
          'which can lead to defoliation and reduced fruit production if left untreated.',
      treatments: const [
        TreatmentStep(title: 'Water Management',    description: 'Reduce watering frequency to prevent moisture buildup',    icon: Icons.water_drop_outlined),
        TreatmentStep(title: 'Sunlight Exposure',   description: 'Move to area with 6–8 hours of direct sunlight',           icon: Icons.wb_sunny_outlined),
        TreatmentStep(title: 'Temperature Control', description: 'Maintain temperature between 65–75°F (18–24°C)',           icon: Icons.thermostat_outlined),
      ],
      tips: [
        'Remove affected leaves immediately to prevent spreading',
        'Apply organic fungicide every 7–10 days',
        'Ensure proper air circulation around plants',
      ],
    ),
    'Powdery Mildew': () => ScanDetailData(
      plantName: plantName, date: date, time: time, isHealthy: false,
      diseaseName: 'Powdery Mildew',
      scientificName: 'Erysiphe spp.',
      confidence: 82,
      severity: 'Moderate',
      description:
      'Powdery mildew is a fungal disease that appears as white or grey powdery spots '
          'on leaf surfaces. It thrives in warm, dry conditions with high humidity at night.',
      treatments: const [
        TreatmentStep(title: 'Reduce Humidity',    description: 'Improve air circulation to lower humidity around leaves',   icon: Icons.air_outlined),
        TreatmentStep(title: 'Fungicide Spray',    description: 'Apply neem oil or potassium bicarbonate spray',             icon: Icons.science_outlined),
        TreatmentStep(title: 'Leaf Removal',       description: 'Remove and dispose of heavily infected leaves',             icon: Icons.eco_outlined),
      ],
      tips: [
        'Avoid overhead watering — water at the base',
        'Space plants further apart for better airflow',
        'Apply preventive spray early in the season',
      ],
    ),
    'Rust Disease': () => ScanDetailData(
      plantName: plantName, date: date, time: time, isHealthy: false,
      diseaseName: 'Rust Disease',
      scientificName: 'Puccinia spp.',
      confidence: 74,
      severity: 'High',
      description:
      'Rust disease is a fungal infection causing orange or brown pustules on leaf undersides. '
          'It spreads rapidly in moist, cool conditions and can severely weaken the plant.',
      treatments: const [
        TreatmentStep(title: 'Remove Infected Parts', description: 'Prune and destroy all infected foliage immediately',    icon: Icons.content_cut_outlined),
        TreatmentStep(title: 'Fungicide Treatment',   description: 'Apply copper-based fungicide every 7 days',             icon: Icons.science_outlined),
        TreatmentStep(title: 'Avoid Wetting Leaves',  description: 'Water only the soil — keep foliage dry',               icon: Icons.water_drop_outlined),
      ],
      tips: [
        'Disinfect pruning tools after use',
        'Do not compost infected plant material',
        'Mulch around the base to reduce soil splash',
      ],
    ),
  };

  return diseaseMap[status]?.call() ?? ScanDetailData(
    plantName: plantName, date: date, time: time, isHealthy: false,
    diseaseName: status,
    confidence: 70,
    severity: 'Moderate',
    description: 'A plant disease was detected. Please consult a local plant specialist for further advice.',
    treatments: const [
      TreatmentStep(title: 'Isolate Plant',     description: 'Move away from other plants to prevent spreading',  icon: Icons.format_align_center_outlined),
      TreatmentStep(title: 'Consult Expert',    description: 'Contact a local plant health specialist',           icon: Icons.person_search_outlined),
    ],
    tips: ['Monitor the plant daily for changes', 'Avoid over-watering'],
  );
}