import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/screens/history/scan_detail_screen.dart';
import 'package:leafscan_app/services/auth_service.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class AnalyzingScreen extends StatefulWidget {
  final String imagePath;
  const AnalyzingScreen({super.key, required this.imagePath});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with TickerProviderStateMixin {

  LeafColors get _c     => LeafColors.of(context);
  Color get _bg         => _c.bg;
  Color get _cardBg     => _c.cardBg;
  Color get _green      => _c.green;
  Color get _greenLight => _c.greenLight;
  Color get _textDark   => _c.textPrimary;
  Color get _textMuted  => _c.textMuted;
  Color get _border     => _c.border;

  static const _steps = [
    _Step(icon: Icons.remove_red_eye_outlined, label: 'Analyzing image'),
    _Step(icon: Icons.memory_outlined,          label: 'AI processing'),
    _Step(icon: Icons.biotech_outlined,         label: 'Identifying disease'),
    _Step(icon: Icons.summarize_outlined,       label: 'Generating report'),
  ];

  late final List<AnimationController> _cardCtrls;
  late final List<Animation<double>>   _cardFades;
  late final List<Animation<Offset>>   _cardSlides;
  late final List<AnimationController> _dotCtrls;
  late final AnimationController       _iconCtrl;
  late final Animation<double>         _iconScale;

  @override
  void initState() {
    super.initState();

    _iconCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _iconScale = Tween<double>(begin: 0.92, end: 1.08)
        .animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeInOut));

    _cardCtrls = List.generate(_steps.length, (i) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 420)));
    _cardFades = _cardCtrls.map((c) =>
        CurvedAnimation(parent: c, curve: Curves.easeOut)).toList();
    _cardSlides = _cardCtrls.map((c) =>
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut))).toList();
    _dotCtrls = List.generate(_steps.length, (i) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600)));

    _runSequence();
  }

  Future<void> _runSequence() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(milliseconds: i == 0 ? 300 : 550));
      if (!mounted) return;
      _cardCtrls[i].forward();
      _dotCtrls[i].repeat(reverse: true);
    }
    await _callScanAPI();
  }

  Future<void> _callScanAPI() async {
    try {
      final token = await AuthService.getAccessToken();
      debugPrint('TOKEN: $token');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8000/api/analyses/scan/'),
      );
      request.headers['Authorization'] = 'Bearer ${token ?? ""}';

      if (kIsWeb) {
        final uri   = Uri.parse(widget.imagePath);
        final bytes = await http.get(uri);
        request.files.add(http.MultipartFile.fromBytes(
          'image', bytes.bodyBytes,
          filename: 'plant.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
        final file  = File(widget.imagePath);
        final bytes = await file.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'image', bytes,
          filename: 'plant.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      debugPrint('SCAN STATUS: ${response.statusCode}');
      debugPrint('SCAN BODY: ${response.body}');

      if (!mounted) return;
      for (final c in _dotCtrls) c.stop();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body        = jsonDecode(response.body);
        // Response structure: { analysis: { plant: {...}, disease: {...}, ... } }
        final data        = body['analysis'] ?? body;
        final plantName   = data['plant']?['name']         ?? 'Unknown Plant';
        final isHealthy   = data['result_label']            == 'HEALTHY';
        final diseaseName = data['disease']?['name']        ?? '';
        final confidence  = ((data['confidence'] as num?)! * 100)?.round() ?? 0;
        final createdAt   = data['created_at']              ?? '';
        final date        = createdAt.length >= 10 ? createdAt.substring(0, 10) : DateTime.now().toString().substring(0, 10);
        final time        = createdAt.length >= 16 ? createdAt.substring(11, 16) : '';
        final plantId     = data['plant']?['id']            as int?;
        final diseaseId   = data['disease']?['id']          as int?;
        final severity    = data['disease']?['severity']    ?? '';
        final description = data['disease']?['description'] ?? '';

        if (!mounted) return;
        context.go(AppRouter.result, extra: ScanDetailData(
          plantName:   plantName,
          date:        date,
          time:        time,
          isHealthy:   isHealthy,
          diseaseName: isHealthy ? null : diseaseName,
          confidence:  confidence,
          severity:    isHealthy ? null : severity,
          description: isHealthy ? null : description,
          plantId:     plantId,
          diseaseId:   isHealthy ? null : diseaseId,
        ));
      } else {
        _showError('Analysis failed (${response.statusCode}):\n${response.body}');
      }
    } catch (e) {
      debugPrint('Scan error: $e');
      _showError('Network error: $e');
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    for (final c in _dotCtrls) c.stop();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Scan Failed'),
        content: SingleChildScrollView(child: Text(msg)),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(ctx); context.go(AppRouter.scan); },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    for (final c in _cardCtrls) c.dispose();
    for (final c in _dotCtrls)  c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _iconScale,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: _greenLight.withOpacity(0.25),
                      shape: BoxShape.circle,
                      border: Border.all(color: _greenLight.withOpacity(0.4), width: 1.5),
                    ),
                    child: Icon(Icons.auto_awesome_rounded, color: _green, size: 34),
                  ),
                ),
                const SizedBox(height: 28),
                Text('Analyzing Your Plant',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _textDark)),
                const SizedBox(height: 6),
                Text('Our AI is examining the plant image…',
                    style: TextStyle(fontSize: 13, color: _textMuted)),
                const SizedBox(height: 36),
                ...List.generate(_steps.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FadeTransition(
                    opacity: _cardFades[i],
                    child: SlideTransition(
                      position: _cardSlides[i],
                      child: _StepCard(
                        step: _steps[i], dotCtrl: _dotCtrls[i],
                        cardBg: _cardBg, green: _greenLight,
                        border: _border, textDark: _textDark,
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                Text('This usually takes a few seconds',
                    style: TextStyle(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final _Step step;
  final AnimationController dotCtrl;
  final Color cardBg, green, border, textDark;
  const _StepCard({required this.step, required this.dotCtrl,
    required this.cardBg, required this.green, required this.border, required this.textDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: green.withOpacity(0.18), borderRadius: BorderRadius.circular(11)),
          child: Icon(step.icon, color: green, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(step.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textDark))),
        _BouncingDots(ctrl: dotCtrl, color: green),
      ]),
    );
  }
}

class _BouncingDots extends StatelessWidget {
  final AnimationController ctrl;
  final Color color;
  const _BouncingDots({required this.ctrl, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final anim = Tween<double>(begin: 0, end: -6).animate(
          CurvedAnimation(parent: ctrl, curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut)),
        );
        return AnimatedBuilder(
          animation: anim,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, anim.value),
            child: Container(
              width: 6, height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        );
      }),
    );
  }
}

class _Step {
  final IconData icon;
  final String label;
  const _Step({required this.icon, required this.label});
}