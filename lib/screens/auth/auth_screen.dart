import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/services/auth_service.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool  _passwordHidden = true;
  bool  _loading        = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _card        => _c.cardBg;
  Color get _inputBg     => _c.inputBg;
  Color get _border      => _c.border;
  Color get _green       => _c.green;
  Color get _greenLight  => _c.greenLight;
  Color get _textPrimary => _c.textPrimary;
  Color get _textMuted   => _c.textMuted;

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<void> _handleLogin() async {
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }

    setState(() { _loading = true; _error = null; });

    final result = await AuthService.login(email: email, password: password);

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      context.go(AppRouter.home);
    } else {
      setState(() => _error = result.error);
    }
  }

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
              if (_error != null) ...[
                const SizedBox(height: 12),
                _buildError(_error!),
              ],
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

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: _greenLight, shape: BoxShape.circle),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 38, height: 1.15, fontWeight: FontWeight.w800, color: _textPrimary, letterSpacing: -1.0),
            children: [
              const TextSpan(text: 'Ready to\nheal your\n'),
              TextSpan(text: 'plants?', style: TextStyle(color: _greenLight)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Sign in to diagnose, track and cure\nyour plants with AI.',
          style: TextStyle(fontSize: 14, color: _textMuted, height: 1.6),
        ),
      ],
    );
  }

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

  Widget _buildError(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(msg, style: const TextStyle(fontSize: 13, color: Colors.red))),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5),
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
        style: TextStyle(fontSize: 15, color: _textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: _textMuted, fontSize: 15),
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

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _loading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
      ),
    );
  }

  Widget _buildForgot() {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Text(
          'Forgot your password?',
          style: TextStyle(fontSize: 13, color: _greenLight, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('or', style: TextStyle(fontSize: 13, color: _textMuted)),
        ),
        Expanded(child: Container(height: 1, color: _border)),
      ],
    );
  }

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
          Text('New to LeafScan AI?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary)),
          const SizedBox(height: 4),
          Text(
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
                side: BorderSide(color: _green, width: 1.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Create Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegisterSheet() {
    final nameCtrl   = TextEditingController();
    final emailCtrl  = TextEditingController();
    final passCtrl   = TextEditingController();
    bool  passHidden = true;
    bool  loading    = false;
    String? error;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _textPrimary)),
              const SizedBox(height: 6),
              Text('Join thousands healing their plants.', style: TextStyle(fontSize: 13, color: _textMuted)),
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
              if (error != null) ...[
                const SizedBox(height: 10),
                Text(error!, style: const TextStyle(fontSize: 13, color: Colors.red)),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading ? null : () async {
                    setS(() { loading = true; error = null; });
                    final result = await AuthService.register(
                      fullName: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      password: passCtrl.text,
                    );
                    if (!ctx.mounted) return;
                    if (result.success) {
                      Navigator.pop(ctx);
                      if (mounted) context.go(AppRouter.home);
                    } else {
                      setS(() { loading = false; error = result.error; });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegal() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 11.5, color: _textMuted, height: 1.6),
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(text: 'Terms', style: TextStyle(color: _greenLight, fontWeight: FontWeight.w500)),
          const TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Policy', style: TextStyle(color: _greenLight, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
