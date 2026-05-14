import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/screens/disease/disease_detail_screen.dart';
import 'package:leafscan_app/screens/plant/plant_detail_screen.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class ScanDetailScreen extends StatefulWidget {
  final ScanDetailData data;
  const ScanDetailScreen({super.key, required this.data});

  @override
  State<ScanDetailScreen> createState() => _ScanDetailScreenState();
}

class _ScanDetailScreenState extends State<ScanDetailScreen> {
  ScanDetailData get data => widget.data;

  LeafColors get _c      => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark    => _c.cardBg;
  Color get _green       => _c.green;
  Color get _greenLight  => _c.greenLight;
  Color get _textPrimary => _c.textPrimary;
  Color get _textMuted   => _c.textMuted;
  Color get _orange      => _c.orange;
  Color get _border      => _c.border;
  Color get _orangeBg    => _c.orange.withOpacity(0.12);

  Color get _accent      => data.isHealthy ? _green : _orange;
  Color get _accentLight => data.isHealthy ? _greenLight : _orange;

  bool _savingPdf = false;

  // ── PDF Generation ─────────────────────────────────────────────────────────
  Future<void> _saveReport() async {
    setState(() => _savingPdf = true);
    try {
      final pdf = pw.Document();

      // Colors
      final green  = PdfColor.fromHex('#5C9E78');
      final orange = PdfColor.fromHex('#E8924A');
      final accent = data.isHealthy ? green : orange;
      final gray   = PdfColors.grey700;
      final lightGray = PdfColors.grey200;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (ctx) => [
            // ── Header ──────────────────────────────────────────────────────
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: data.isHealthy ? PdfColor.fromHex('#E8F5EE') : PdfColor.fromHex('#FFF3EB'),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('LeafScan AI — Plant Analysis Report',
                          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: accent)),
                      pw.SizedBox(height: 4),
                      pw.Text('Generated on ${DateTime.now().toString().substring(0, 10)}',
                          style: pw.TextStyle(fontSize: 11, color: gray)),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: accent,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      data.isHealthy ? 'HEALTHY' : 'INFECTED',
                      style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // ── Plant Info ───────────────────────────────────────────────────
            pw.Text('Plant Information',
                style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: lightGray, width: 1),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                children: [
                  _pdfRow('Plant Name',    data.plantName,            accent),
                  _pdfRow('Analysis Date', data.date,                 gray),
                  _pdfRow('Analysis Time', data.time.isNotEmpty ? data.time : '—', gray),
                  _pdfRow('Confidence',    '${data.confidence ?? 0}%', accent),
                  _pdfRow('Status',        data.isHealthy ? 'Healthy' : 'Disease Detected', accent),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // ── Disease Info ─────────────────────────────────────────────────
            if (!data.isHealthy) ...[
              pw.Text('Disease Information',
                  style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: lightGray, width: 1),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    _pdfRow('Disease Name', data.diseaseName ?? '—', orange),
                    _pdfRow('Severity',     data.severity    ?? '—', orange),
                    if (data.description != null) ...[
                      pw.SizedBox(height: 8),
                      pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text('Description:',
                            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: gray)),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(data.description!,
                          style: pw.TextStyle(fontSize: 11, color: PdfColors.grey800, lineSpacing: 3)),
                    ],
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // ── Treatments ─────────────────────────────────────────────────
              if (data.treatments != null && data.treatments!.isNotEmpty) ...[
                pw.Text('Treatment Plan',
                    style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                ...data.treatments!.map((t) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F0FAF4'),
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: PdfColor.fromHex('#C8E6D4'), width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(t.title,
                          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: green)),
                      pw.SizedBox(height: 3),
                      pw.Text(t.description,
                          style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700, lineSpacing: 2)),
                    ],
                  ),
                )),
                pw.SizedBox(height: 20),
              ],
            ],

            // ── Tips ──────────────────────────────────────────────────────────
            if (data.tips != null && data.tips!.isNotEmpty) ...[
              pw.Text(data.isHealthy ? 'Care Tips' : 'Additional Tips',
                  style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: data.isHealthy ? PdfColor.fromHex('#F0FAF4') : PdfColor.fromHex('#FFF3EB'),
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: data.isHealthy ? PdfColor.fromHex('#C8E6D4') : PdfColor.fromHex('#FFDEC8'), width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: data.tips!.map((tip) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('* ', style: pw.TextStyle(fontSize: 12, color: accent, fontWeight: pw.FontWeight.bold)),
                        pw.Expanded(child: pw.Text(tip, style: pw.TextStyle(fontSize: 11, color: PdfColors.grey800, lineSpacing: 2))),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],

            pw.SizedBox(height: 30),

            // ── Footer ────────────────────────────────────────────────────────
            pw.Divider(color: lightGray),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'Generated by LeafScan AI • ${DateTime.now().toString().substring(0, 16)}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
              ),
            ),
          ],
        ),
      );

      // Save or Share
      final bytes = await pdf.save();

      if (kIsWeb) {
        await Printing.layoutPdf(onLayout: (_) async => bytes);
      } else {
        // Save to temp and share
        final dir  = await getTemporaryDirectory();
        final file = File('${dir.path}/leafscan_report_${data.date}.pdf');
        await file.writeAsBytes(bytes);
        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'LeafScan AI Report — ${data.plantName}',
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Report ready!'),
          backgroundColor: _green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } catch (e) {
      debugPrint('PDF error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to generate report: $e'),
          backgroundColor: _orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } finally {
      if (mounted) setState(() => _savingPdf = false);
    }
  }

  pw.Widget _pdfRow(String label, String value, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600)),
          pw.Text(value, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: color)),
        ],
      ),
    );
  }

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
                  _buildHeroImage(context),
                  _buildDiagnosisHeader(context),
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

  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity, height: 220,
          color: const Color(0xFF0D1510),
          child: data.imagePath != null
              ? Image.asset(data.imagePath!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildImagePlaceholder())
              : _buildImagePlaceholder(),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, _bg.withOpacity(0.9)],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0, left: 0, right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.canPop(context) ? Navigator.pop(context) : context.go(AppRouter.home),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text('Back', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
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
      child: Center(child: Icon(Icons.eco_rounded, color: _green.withOpacity(0.3), size: 64)),
    );
  }

  Widget _buildDiagnosisHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(color: _cardDark, border: Border(bottom: BorderSide(color: _border, width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.isHealthy ? 'Healthy Plant' : 'Disease Detected',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _accentLight, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(data.plantName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _textPrimary)),
                    if (data.scientificName != null) ...[
                      const SizedBox(height: 2),
                      Text(data.scientificName!, style: TextStyle(fontSize: 13, color: _textMuted, fontStyle: FontStyle.italic)),
                    ],
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: _textMuted),
                      const SizedBox(width: 5),
                      Text('Analyzed on ${data.date}', style: TextStyle(fontSize: 12, color: _textMuted)),
                    ]),
                  ],
                ),
              ),
              if (data.confidence != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${data.confidence}%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _accentLight)),
                    Text('Confidence', style: TextStyle(fontSize: 11, color: _textMuted)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          _buildActionButton(icon: Icons.eco_rounded, label: 'Learn More about ${data.plantName}', color: _green, lightColor: _greenLight,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlantDetailScreen(plantId: data.plantId ?? 999)))),
          if (!data.isHealthy && data.diseaseName != null) ...[
            const SizedBox(height: 10),
            _buildActionButton(icon: Icons.coronavirus_outlined, label: 'View Disease Details: ${data.diseaseName}', color: _orange, lightColor: _orange,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseDetailScreen(diseaseId: data.diseaseId ?? 999)))),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required Color lightColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3), width: 1)),
        child: Row(children: [
          Icon(icon, color: lightColor, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: lightColor), overflow: TextOverflow.ellipsis)),
          Icon(Icons.arrow_forward_ios_rounded, color: lightColor, size: 13),
        ]),
      ),
    );
  }

  Widget _buildInfoSection() {
    return _sectionCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(Icons.info_outline_rounded, color: _accentLight, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text('What is ${data.diseaseName ?? data.plantName}?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _accentLight))),
        ]),
        const SizedBox(height: 10),
        Text(data.description ?? '', style: TextStyle(fontSize: 13, color: _textMuted, height: 1.6)),
      ],
    ));
  }

  Widget _buildSeveritySection() {
    final double fraction = _severityFraction(data.severity);
    return _sectionCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Disease Severity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
            Text(data.severity ?? 'Unknown', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _accentLight)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 6,
          decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(50)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fraction,
            child: Container(decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(50))),
          ),
        ),
      ],
    ));
  }

  double _severityFraction(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'low':      return 0.25;
      case 'moderate': return 0.65;
      case 'medium':   return 0.5;
      case 'high':     return 0.85;
      case 'severe':   return 1.0;
      default:         return 0.5;
    }
  }

  Widget _buildTreatmentPlan() {
    if (data.treatments == null || data.treatments!.isEmpty) return const SizedBox.shrink();
    return _sectionCard(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Treatment Plan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
        const SizedBox(height: 12),
        ...data.treatments!.map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _treatmentTile(t))),
      ],
    ));
  }

  Widget _treatmentTile(TreatmentStep step) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border, width: 1)),
      child: Row(children: [
        Container(width: 36, height: 36,
            decoration: BoxDecoration(color: _green.withOpacity(0.13), borderRadius: BorderRadius.circular(10), border: Border.all(color: _green.withOpacity(0.25))),
            child: Icon(step.icon, color: _greenLight, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(step.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textPrimary)),
          const SizedBox(height: 2),
          Text(step.description, style: TextStyle(fontSize: 12, color: _textMuted, height: 1.4)),
        ])),
      ]),
    );
  }

  Widget _buildAdditionalTips() {
    if (data.tips == null || data.tips!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _orangeBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: _orange.withOpacity(0.25), width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.tips_and_updates_outlined, color: _orange, size: 16),
              const SizedBox(width: 6),
              Text('Additional Tips', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _orange)),
            ]),
            const SizedBox(height: 10),
            ...data.tips!.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 5, right: 8), decoration: BoxDecoration(color: _orange, shape: BoxShape.circle)),
                Expanded(child: Text(tip, style: TextStyle(fontSize: 12, color: _textMuted, height: 1.4))),
              ]),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthySection() {
    return _sectionCard(child: Column(children: [
      Container(width: 64, height: 64,
          decoration: BoxDecoration(color: _green.withOpacity(0.13), shape: BoxShape.circle, border: Border.all(color: _green.withOpacity(0.25))),
          child: Icon(Icons.favorite_rounded, color: _greenLight, size: 28)),
      const SizedBox(height: 14),
      Text('Plant is Healthy!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _greenLight)),
      const SizedBox(height: 6),
      Text('No signs of disease detected. Keep up the good care!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: _textMuted, height: 1.5)),
      if (data.tips != null && data.tips!.isNotEmpty) ...[
        const SizedBox(height: 16),
        Divider(color: _border, height: 1),
        const SizedBox(height: 14),
        Align(alignment: Alignment.centerLeft, child: Text('Care Tips', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _greenLight))),
        const SizedBox(height: 10),
        ...data.tips!.map((tip) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 5, height: 5, margin: const EdgeInsets.only(top: 5, right: 8), decoration: BoxDecoration(color: _green, shape: BoxShape.circle)),
            Expanded(child: Text(tip, style: TextStyle(fontSize: 12, color: _textMuted, height: 1.4))),
          ]),
        )),
      ],
    ]));
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(color: _cardDark, border: Border(top: BorderSide(color: _border, width: 1))),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _savingPdf ? null : _saveReport,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border, width: 1)),
                  child: _savingPdf
                      ? Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _green, strokeWidth: 2)))
                      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.download_outlined, color: _textMuted, size: 18),
                    const SizedBox(width: 6),
                    Text('Save Report', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textMuted)),
                  ]),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => context.go(AppRouter.scan),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(14)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Scan Another', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
        child: child,
      ),
    );
  }
}

// ── Data Models ───────────────────────────────────────────────────────────────

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
  final int? plantId;
  final int? diseaseId;

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
    this.plantId,
    this.diseaseId,
  });
}

class TreatmentStep {
  final String title;
  final String description;
  final IconData icon;
  const TreatmentStep({required this.title, required this.description, required this.icon});
}

// ── Sample Data Factory ───────────────────────────────────────────────────────

ScanDetailData sampleDetailFromRecord({
  required String plantName,
  required String date,
  required String time,
  required bool isHealthy,
  required String status,
}) {
  if (isHealthy) {
    return ScanDetailData(
      plantName: plantName, date: date, time: time, isHealthy: true, confidence: 95, plantId: 999,
      tips: ['Continue regular watering schedule', 'Ensure adequate sunlight exposure daily', 'Check for pests every 1–2 weeks', 'Feed with balanced fertilizer monthly'],
    );
  }

  return ScanDetailData(
    plantName: plantName, date: date, time: time, isHealthy: false,
    diseaseName: status, confidence: 70, severity: 'Medium',
    plantId: 999, diseaseId: 999,
    description: 'A plant disease was detected. Please consult a local plant specialist.',
    treatments: const [
      TreatmentStep(title: 'Isolate Plant',  description: 'Move away from other plants to prevent spreading', icon: Icons.format_align_center_outlined),
      TreatmentStep(title: 'Consult Expert', description: 'Contact a local plant health specialist',          icon: Icons.person_search_outlined),
    ],
    tips: ['Monitor the plant daily for changes', 'Avoid over-watering'],
  );
}
