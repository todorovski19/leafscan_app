import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  final _loginEmailCtrl    = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();
  bool  _loginPasswordHidden = true;

  final _regNameCtrl     = TextEditingController();
  final _regEmailCtrl    = TextEditingController();
  final _regPasswordCtrl = TextEditingController();
  bool  _regPasswordHidden = true;

  @override
  void dispose() {
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              _buildLogo(),
              const SizedBox(height: 12),
              _buildAppTitle(),
              const SizedBox(height: 32),
              _buildCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() => Container(
    width: 80, height: 80,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFFB8E0C8), Color(0xFF7CC49A)],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6))],
    ),
    child: const Center(child: Icon(Icons.eco_rounded, size: 44, color: AppColors.primaryDark)),
  );

  Widget _buildAppTitle() => const Column(
    children: [
      Text('PlantCare AI', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textDark, letterSpacing: -0.5)),
      SizedBox(height: 4),
      Text('Detect. Diagnose. Cure.', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
    ],
  );

  Widget _buildCard() => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4))],
    ),
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabToggle(),
        const SizedBox(height: 28),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
          child: _isLogin
              ? _buildLoginForm(key: const ValueKey('login'))
              : _buildRegisterForm(key: const ValueKey('register')),
        ),
        const SizedBox(height: 20),
        _buildLegalText(),
      ],
    ),
  );

  Widget _buildTabToggle() => Row(
    children: [
      Expanded(child: _tabBtn('Login',    _isLogin,  () => setState(() => _isLogin = true))),
      const SizedBox(width: 8),
      Expanded(child: _tabBtn('Register', !_isLogin, () => setState(() => _isLogin = false))),
    ],
  );

  Widget _tabBtn(String label, bool active, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.primaryMint.withOpacity(0.4),
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.primary)),
    ),
  );

  Widget _buildLoginForm({Key? key}) => Column(
    key: key, crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _fieldLabel('Email'), const SizedBox(height: 8),
      _textField(controller: _loginEmailCtrl, hint: 'your@email.com', prefixIcon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 20),
      _fieldLabel('Password'), const SizedBox(height: 8),
      _textField(
        controller: _loginPasswordCtrl, hint: '••••••••',
        prefixIcon: Icons.lock_outline_rounded, obscure: _loginPasswordHidden,
        suffixIcon: IconButton(
          icon: Icon(_loginPasswordHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textMuted, size: 20),
          onPressed: () => setState(() => _loginPasswordHidden = !_loginPasswordHidden),
        ),
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {},
          child: const Text('Forgot Password?', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
        ),
      ),
      const SizedBox(height: 20),
      _primaryButton('Login', () => context.go(AppRouter.home)),
    ],
  );

  Widget _buildRegisterForm({Key? key}) => Column(
    key: key, crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _fieldLabel('Full Name'), const SizedBox(height: 8),
      _textField(controller: _regNameCtrl, hint: 'John Doe', prefixIcon: null),
      const SizedBox(height: 20),
      _fieldLabel('Email'), const SizedBox(height: 8),
      _textField(controller: _regEmailCtrl, hint: 'your@email.com', prefixIcon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 20),
      _fieldLabel('Password'), const SizedBox(height: 8),
      _textField(
        controller: _regPasswordCtrl, hint: '••••••••',
        prefixIcon: Icons.lock_outline_rounded, obscure: _regPasswordHidden,
        suffixIcon: IconButton(
          icon: Icon(_regPasswordHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppColors.textMuted, size: 20),
          onPressed: () => setState(() => _regPasswordHidden = !_regPasswordHidden),
        ),
      ),
      const SizedBox(height: 24),
      _primaryButton('Create Account', () => context.go(AppRouter.home)),
    ],
  );

  Widget _fieldLabel(String text) => Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark));

  Widget _textField({required TextEditingController controller, required String hint, required IconData? prefixIcon, bool obscure = false, Widget? suffixIcon, TextInputType? keyboardType}) {
    return TextField(
      controller: controller, obscureText: obscure, keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted, size: 20) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) => SizedBox(
    width: double.infinity, height: 52,
    child: ElevatedButton(onPressed: onTap, child: Text(label)),
  );

  Widget _buildLegalText() => RichText(
    textAlign: TextAlign.center,
    text: const TextSpan(
      style: TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.6),
      children: [
        TextSpan(text: 'By continuing, you agree to our '),
        TextSpan(text: 'Terms', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
        TextSpan(text: '\nand '),
        TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}