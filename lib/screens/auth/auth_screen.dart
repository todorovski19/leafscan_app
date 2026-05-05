import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AuthScreen — modern sleek login
// lib/screens/auth/auth_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool  _passwordHidden = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Colours ────────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFF181F1B);
  static const Color _card       = Color(0xFF1E2923);
  static const Color _inputBg    = Color(0xFF243028);
  static const Color _border     = Color(0xFF2E3D33);
  static const Color _green      = Color(0xFF5C9E78);
  static const Color _greenLight = Color(0xFF7CC49A);
  static const Color _textPrimary= Color(0xFFF0EDE6);
  static const Color _textMuted  = Color(0xFF7A9080);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56),
              _buildHeroText(),
              const SizedBox(height: 48),
              _buildForm(),
              const SizedBox(height: 20),
              _buildLoginButton(),
              const SizedBox(height: 16),
              _buildForgot(),
              const SizedBox(height: 40),
              _buildDivider(),
              const SizedBox(height: 28),
              _buildRegisterPrompt(),
              const SizedBox(height: 32),
              _buildLegal(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero text ──────────────────────────────────────────────────────────────
  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Green accent dot
        Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(color: _greenLight, shape: BoxShape.circle),
        ),
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 38, height: 1.15, fontWeight: FontWeight.w800, color: _textPrimary, letterSpacing: -1.0),
            children: [
              TextSpan(text: 'Ready to\nheal your\n'),
              TextSpan(text: 'plants?', style: TextStyle(color: _greenLight)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Sign in to diagnose, track and cure\nyour plants with AI.',
          style: TextStyle(fontSize: 14, color: _textMuted, height: 1.6),
        ),
      ],
    );
  }

  // ── Form fields ────────────────────────────────────────────────────────────
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Email'),
        const SizedBox(height: 8),
        _inputField(
          controller: _emailCtrl,
          hint: 'your@email.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        _label('Password'),
        const SizedBox(height: 8),
        _inputField(
          controller: _passwordCtrl,
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          obscure: _passwordHidden,
          suffix: GestureDetector(
            onTap: () => setState(() => _passwordHidden = !_passwordHidden),
            child: Icon(
              _passwordHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: _textMuted, size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: _textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _textMuted, fontSize: 15),
          prefixIcon: Icon(icon, color: _textMuted, size: 19),
          suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.only(right: 14), child: suffix) : null,
          suffixIconConstraints: const BoxConstraints(),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          filled: false,
        ),
      ),
    );
  }

  // ── Login button ───────────────────────────────────────────────────────────
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => context.go(AppRouter.home),
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
      ),
    );
  }

  // ── Forgot password ────────────────────────────────────────────────────────
  Widget _buildForgot() {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: const Text(
          'Forgot your password?',
          style: TextStyle(fontSize: 13, color: _greenLight, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // ── Divider ────────────────────────────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _border)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text('or', style: TextStyle(fontSize: 13, color: _textMuted)),
        ),
        Expanded(child: Container(height: 1, color: _border)),
      ],
    );
  }

  // ── Register prompt ────────────────────────────────────────────────────────
  Widget _buildRegisterPrompt() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1),
      ),
      child: Column(
        children: [
          const Text(
            'New to PlantCare AI?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Create a free account and start healing your plants today.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: _textMuted, height: 1.4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => _showRegisterSheet(),
              style: OutlinedButton.styleFrom(
                foregroundColor: _greenLight,
                side: const BorderSide(color: _green, width: 1.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Create Account',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Register bottom sheet ──────────────────────────────────────────────────
  void _showRegisterSheet() {
    final nameCtrl     = TextEditingController();
    final emailCtrl    = TextEditingController();
    final passCtrl     = TextEditingController();
    bool  passHidden   = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _textPrimary)),
              const SizedBox(height: 6),
              const Text('Join thousands healing their plants.', style: TextStyle(fontSize: 13, color: _textMuted)),
              const SizedBox(height: 28),
              _label('Full Name'),
              const SizedBox(height: 8),
              _inputField(controller: nameCtrl, hint: 'John Doe', icon: Icons.person_outline_rounded),
              const SizedBox(height: 16),
              _label('Email'),
              const SizedBox(height: 8),
              _inputField(controller: emailCtrl, hint: 'your@email.com', icon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _label('Password'),
              const SizedBox(height: 8),
              _inputField(
                controller: passCtrl, hint: '••••••••',
                icon: Icons.lock_outline_rounded, obscure: passHidden,
                suffix: GestureDetector(
                  onTap: () => setS(() => passHidden = !passHidden),
                  child: Icon(passHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.go(AppRouter.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Legal ──────────────────────────────────────────────────────────────────
  Widget _buildLegal() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 11.5, color: _textMuted, height: 1.6),
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(text: 'Terms', style: const TextStyle(color: _greenLight, fontWeight: FontWeight.w500)),
          const TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Policy', style: const TextStyle(color: _greenLight, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}