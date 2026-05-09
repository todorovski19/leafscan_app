import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/screens/history/scan_detail_screen.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AnalyzingScreen — animated analysis progress, then navigates to result
// Place in: lib/screens/scan/analyzing_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class AnalyzingScreen extends StatefulWidget {
  final String imagePath;
  const AnalyzingScreen({super.key, required this.imagePath});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with TickerProviderStateMixin {
  // ── Colors ──────────────────────────────────────────────────────────────
  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardBg          => _c.cardBg;
  Color get _green          => _c.green;
  Color get _greenLight          => _c.greenLight;
  Color get _textDark          => _c.textPrimary;
  Color get _textMuted          => _c.textMuted;
  Color get _border          => _c.border;
  Color get _headerBg    => _c.headerBg;

  static const _steps = [
    _Step(icon: Icons.remove_red_eye_outlined,  label: 'Analyzing image'),
    _Step(icon: Icons.memory_outlined,           label: 'AI processing'),
    _Step(icon: Icons.biotech_outlined,          label: 'Identifying disease'),
    _Step(icon: Icons.summarize_outlined,        label: 'Generating report'),
  ];

  // One controller per step card (fade + slide in)
  late final List<AnimationController> _cardCtrls;
  late final List<Animation<double>>   _cardFades;
  late final List<Animation<Offset>>   _cardSlides;

  // Dot bounce controllers per step
  late final List<AnimationController> _dotCtrls;

  // Icon sparkle controller
  late final AnimationController _iconCtrl;
  late final Animation<double>   _iconScale;

  @override
  void initState() {
    super.initState();

    // Icon pulse
    _iconCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _iconScale = Tween<double>(begin: 0.92, end: 1.08)
        .animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeInOut));

    // Card animations
    _cardCtrls = List.generate(
        _steps.length,
            (i) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 420)));
    _cardFades = _cardCtrls
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();
    _cardSlides = _cardCtrls
        .map((c) => Tween<Offset>(
        begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    // Dot bounce (three dots per step, we drive them with one controller each)
    _dotCtrls = List.generate(
        _steps.length,
            (i) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 600)));

    _runSequence();
  }

  Future<void> _runSequence() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(Duration(milliseconds: i == 0 ? 300 : 550));
      if (!mounted) return;
      _cardCtrls[i].forward();
      _dotCtrls[i].repeat(reverse: true);
    }
    // Wait a bit then navigate to result
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    // Stop dot animations
    for (final c in _dotCtrls) c.stop();

    // Navigate to result with sample Early Blight data
    context.go(
      AppRouter.result,
      extra: sampleDetailFromRecord(
        plantName: 'Rose Bush',
        date: 'May 5, 2026',
        time: '8:32 PM',
        isHealthy: false,
        status: 'Early Blight',
      ),
    );
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    for (final c in _cardCtrls) c.dispose();
    for (final c in _dotCtrls) c.dispose();
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
                // ── Animated icon ─────────────────────────────────────────
                ScaleTransition(
                  scale: _iconScale,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: _greenLight.withOpacity(0.25),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: _greenLight.withOpacity(0.4), width: 1.5),
                    ),
                    child: Icon(Icons.auto_awesome_rounded,
                        color: _green, size: 34),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Title ─────────────────────────────────────────────────
                Text('Analyzing Your Plant',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _textDark)),
                const SizedBox(height: 6),
                Text('Our AI is examining the plant image…',
                    style: TextStyle(fontSize: 13, color: _textMuted)),
                const SizedBox(height: 36),

                // ── Step cards ────────────────────────────────────────────
                ...List.generate(_steps.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FadeTransition(
                      opacity: _cardFades[i],
                      child: SlideTransition(
                        position: _cardSlides[i],
                        child: _StepCard(
                          step: _steps[i],
                          dotCtrl: _dotCtrls[i],
                          cardBg: _cardBg,
                          green: _greenLight,
                          border: _border,
                          textDark: _textDark,
                        ),
                      ),
                    ),
                  );
                }),

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

// ── Step card widget ──────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final _Step step;
  final AnimationController dotCtrl;
  final Color cardBg, green, border, textDark;

  const _StepCard({
    required this.step,
    required this.dotCtrl,
    required this.cardBg,
    required this.green,
    required this.border,
    required this.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: green.withOpacity(0.18),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(step.icon, color: green, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(step.label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textDark)),
          ),
          _BouncingDots(ctrl: dotCtrl, color: green),
        ],
      ),
    );
  }
}

// ── Three bouncing dots ───────────────────────────────────────────────────────
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
          CurvedAnimation(
            parent: ctrl,
            curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeInOut),
          ),
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

// ── Data model ────────────────────────────────────────────────────────────────
class _Step {
  final IconData icon;
  final String label;
  const _Step({required this.icon, required this.label});
}