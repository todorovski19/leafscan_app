import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late final AnimationController _treeCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _dot1Ctrl;
  late final AnimationController _dot2Ctrl;
  late final AnimationController _dot3Ctrl;

  late final Animation<double> _treeAnim;
  late final Animation<double> _textFade;
  late final Animation<double> _textSlide;
  late final Animation<double> _dot1;
  late final Animation<double> _dot2;
  late final Animation<double> _dot3;

  @override
  void initState() {
    super.initState();

    _treeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3400));
    _treeAnim = CurvedAnimation(parent: _treeCtrl, curve: Curves.easeInOut);

    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _textFade  = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);
    _textSlide = Tween<double>(begin: 12, end: 0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );

    _dot1Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _dot2Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _dot3Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));

    _dot1 = Tween<double>(begin: 0, end: -7).animate(CurvedAnimation(parent: _dot1Ctrl, curve: Curves.easeInOut));
    _dot2 = Tween<double>(begin: 0, end: -7).animate(CurvedAnimation(parent: _dot2Ctrl, curve: Curves.easeInOut));
    _dot3 = Tween<double>(begin: 0, end: -7).animate(CurvedAnimation(parent: _dot3Ctrl, curve: Curves.easeInOut));

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _treeCtrl.forward();
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _loopDot(_dot1Ctrl, 0);
    _loopDot(_dot2Ctrl, 200);
    _loopDot(_dot3Ctrl, 400);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) context.go(AppRouter.login);
  }

  void _loopDot(AnimationController c, int delayMs) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    if (mounted) c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _treeCtrl.dispose();
    _textCtrl.dispose();
    _dot1Ctrl.dispose();
    _dot2Ctrl.dispose();
    _dot3Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            SizedBox(
              width: 220,
              height: 300,
              child: AnimatedBuilder(
                animation: _treeAnim,
                builder: (_, __) => CustomPaint(
                  painter: _TreePainter(progress: _treeAnim.value),
                ),
              ),
            ),
            const SizedBox(height: 28),
            FadeTransition(
              opacity: _textFade,
              child: AnimatedBuilder(
                animation: _textSlide,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _textSlide.value),
                  child: child,
                ),
                child: Column(
                  children: [
                    Text('LeafScan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.splashText, letterSpacing: 3)),
                    const SizedBox(height: 6),
                    Text('DETECT · DIAGNOSE · CURE', style: TextStyle(fontSize: 11, color: AppColors.splashMuted, letterSpacing: 2.5, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 2),
            FadeTransition(
              opacity: _textFade,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(_dot1, AppColors.dot1),
                  const SizedBox(width: 10),
                  _buildDot(_dot2, AppColors.dot2),
                  const SizedBox(width: 10),
                  _buildDot(_dot3, AppColors.dot3),
                ],
              ),
            ),
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Animation<double> anim, Color color) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, anim.value),
        child: Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  final double progress;
  const _TreePainter({required this.progress});

  static double _clamp(double v) => v.clamp(0.0, 1.0);
  static double _phase(double p, double start, double duration) => _clamp((p - start) / duration);
  static Color _lerpColor(Color a, Color b, double t) => Color.lerp(a, b, t)!;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final groundY = size.height - 20;
    final p = progress;

    final trunkP   = _phase(p, 0.00, 0.25);
    final branch1P = _phase(p, 0.20, 0.25);
    final branch2P = _phase(p, 0.32, 0.22);
    final branch3P = _phase(p, 0.44, 0.18);
    final leafP    = _phase(p, 0.38, 0.50);
    final healP    = _phase(p, 0.45, 0.55);

    const sickTrunk    = Color(0xFF3A2F22);
    const healthTrunk  = Color(0xFF3E3020);
    const sickLeaf     = Color(0xFF4A5248);
    const healthyLeaf  = Color(0xFF3D6050);
    const newLeafColor = Color(0xFF527A62);
    const spotColor    = Color(0xFF2E3830);
    const groundColor  = Color(0xFF222B35);

    final trunkColor = _lerpColor(sickTrunk, healthTrunk, healP);
    final branchPaint = Paint()..color = trunkColor..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final leafPaint = Paint()..style = PaintingStyle.fill;

    if (trunkP > 0) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, groundY + 2), width: 56 * trunkP, height: 10 * trunkP),
        Paint()..color = groundColor,
      );
    }

    void branch(double x1, double y1, double x2, double y2, double w, double t) {
      if (t <= 0) return;
      branchPaint.strokeWidth = w;
      canvas.drawLine(Offset(x1, y1), Offset(x1 + (x2 - x1) * t, y1 + (y2 - y1) * t), branchPaint);
    }

    final midY   = groundY - 55;
    final upperY = groundY - 85;

    branch(cx, groundY, cx, groundY - 120, 9, trunkP);
    branch(cx, midY, cx - 45, midY - 48, 5, branch1P);
    branch(cx, midY, cx + 44, midY - 46, 5, branch1P);
    branch(cx, upperY, cx - 22, upperY - 34, 3.5, branch1P);
    branch(cx, upperY, cx + 22, upperY - 32, 3.5, branch1P);
    branch(cx - 28, midY - 30, cx - 58, midY - 60, 2.5, branch2P);
    branch(cx - 28, midY - 30, cx - 14, midY - 62, 2.5, branch2P);
    branch(cx + 28, midY - 28, cx + 56, midY - 58, 2.5, branch2P);
    branch(cx + 28, midY - 28, cx + 14, midY - 60, 2.5, branch2P);
    branch(cx - 45, midY - 48, cx - 55, midY - 70, 2, branch3P);
    branch(cx + 44, midY - 46, cx + 54, midY - 68, 2, branch3P);
    branch(cx - 22, upperY - 34, cx - 30, upperY - 52, 1.5, branch3P);
    branch(cx + 22, upperY - 32, cx + 30, upperY - 50, 1.5, branch3P);

    if (leafP <= 0) return;

    final leaves = [
      [0.0,-158.0,20.0,0.00],[-12.0,-148.0,13.0,0.03],[12.0,-147.0,13.0,0.03],
      [-22.0,-136.0,11.0,0.07],[22.0,-134.0,11.0,0.07],[-22.0,-126.0,12.0,0.12],
      [22.0,-124.0,12.0,0.12],[-32.0,-118.0,10.0,0.16],[32.0,-116.0,10.0,0.16],
      [-52.0,-103.0,13.0,0.20],[52.0,-101.0,13.0,0.20],[-62.0,-90.0,10.0,0.24],
      [62.0,-88.0,10.0,0.24],[-42.0,-96.0,10.0,0.26],[42.0,-94.0,10.0,0.26],
      [-16.0,-112.0,9.0,0.18],[16.0,-110.0,9.0,0.18],[-36.0,-82.0,9.0,0.28],[36.0,-80.0,9.0,0.28],
    ];

    for (final l in leaves) {
      final lp = _clamp((leafP - l[3] * 0.5) / (1 - l[3] * 0.5));
      if (lp <= 0) continue;
      final hp = _clamp((healP - l[3] * 0.3) / (1 - l[3] * 0.3));
      leafPaint.color = _lerpColor(sickLeaf, healthyLeaf, hp);
      canvas.drawCircle(Offset(cx + l[0], groundY + l[1]), l[2] * lp, leafPaint);
    }

    final spotAlpha = (1.0 - healP * 2.5).clamp(0.0, 0.7);
    if (spotAlpha > 0) {
      final sp = Paint()..color = spotColor.withOpacity(spotAlpha)..style = PaintingStyle.fill;
      for (final s in [[3.0,-156.0,4.0],[-11.0,-146.0,3.0],[13.0,-143.0,2.5],[-51.0,-101.0,3.0],[51.0,-99.0,3.0],[-20.0,-133.0,2.5]]) {
        canvas.drawCircle(Offset(cx + s[0], groundY + s[1]), s[2], sp);
      }
    }

    final na = _clamp((healP - 0.5) / 0.5);
    if (na > 0) {
      final np = Paint()..color = newLeafColor.withOpacity(na)..style = PaintingStyle.fill;
      for (final g in [[0.0,-174.0,10.0],[-8.0,-168.0,7.0],[8.0,-166.0,7.0],[-68.0,-98.0,9.0],[68.0,-96.0,9.0],[-56.0,-115.0,7.0],[56.0,-113.0,7.0]]) {
        canvas.drawCircle(Offset(cx + g[0], groundY + g[1]), g[2], np);
      }
    }
  }

  @override
  bool shouldRepaint(_TreePainter old) => old.progress != progress;
}