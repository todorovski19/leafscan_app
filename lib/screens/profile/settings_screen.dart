import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leafscan_app/providers/theme_provider.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/screens/profile/help_center_screen.dart';
import 'package:leafscan_app/screens/profile/terms_privacy_screen.dart';
import 'package:leafscan_app/services/auth_service.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SettingsScreen
// lib/screens/profile/settings_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark          => _c.cardBg;
  Color get _inputBg          => _c.inputBg;
  Color get _green          => _c.green;
  Color get _greenLight          => _c.greenLight;
  Color get _textPrimary          => _c.textPrimary;
  Color get _textMuted          => _c.textMuted;
  Color get _orange          => _c.orange;
  Color get _border          => _c.border;
  Color get _red          => _c.red;
  Color get _headerBg    => _c.headerBg;

  bool _notificationsEnabled = true;

  void _push(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // ── Snackbar helper ────────────────────────────────────────────────────────
  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? _red : _green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  // ── LOGOUT ─────────────────────────────────────────────────────────────────
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textPrimary)),
        content: Text('Are you sure you want to log out?', style: TextStyle(fontSize: 14, color: _textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: _textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _doLogout();
            },
            child: Text('Log Out', style: TextStyle(color: _red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _doLogout() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF5C9E78))),
    );

    // TODO: pass real refresh token from secure storage
    final result = await AuthService.logout();

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // close loader

    if (result.success) {
      // Navigate back to login and clear stack
      context.go(AppRouter.login);
    } else {
      // Still navigate — token may already be expired
      _snack(result.error ?? 'Logged out', error: false);
      context.go(AppRouter.login);
    }
  }

  // ── CHANGE PASSWORD ────────────────────────────────────────────────────────
  void _showChangePassword() {
    final oldCtrl  = TextEditingController();
    final newCtrl  = TextEditingController();
    final confCtrl = TextEditingController();
    bool oldHidden  = true;
    bool newHidden  = true;
    bool confHidden = true;
    bool loading    = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
              Text('Change Password', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textPrimary)),
              const SizedBox(height: 4),
              Text('Enter your current password to continue.', style: TextStyle(fontSize: 13, color: _textMuted)),
              const SizedBox(height: 24),
              _sheetLabel('Current Password'),
              const SizedBox(height: 8),
              _sheetInput(ctrl: oldCtrl, hint: '••••••••', icon: Icons.lock_outline_rounded, obscure: oldHidden,
                  suffix: GestureDetector(onTap: () => setS(() => oldHidden = !oldHidden),
                      child: Icon(oldHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _textMuted, size: 20))),
              const SizedBox(height: 16),
              _sheetLabel('New Password'),
              const SizedBox(height: 8),
              _sheetInput(ctrl: newCtrl, hint: '••••••••', icon: Icons.lock_outline_rounded, obscure: newHidden,
                  suffix: GestureDetector(onTap: () => setS(() => newHidden = !newHidden),
                      child: Icon(newHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _textMuted, size: 20))),
              const SizedBox(height: 16),
              _sheetLabel('Confirm New Password'),
              const SizedBox(height: 8),
              _sheetInput(ctrl: confCtrl, hint: '••••••••', icon: Icons.lock_outline_rounded, obscure: confHidden,
                  suffix: GestureDetector(onTap: () => setS(() => confHidden = !confHidden),
                      child: Icon(confHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _textMuted, size: 20))),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : () async {
                    if (newCtrl.text != confCtrl.text) {
                      _snack('Passwords do not match', error: true); return;
                    }
                    if (newCtrl.text.length < 6) {
                      _snack('Password must be at least 6 characters', error: true); return;
                    }
                    setS(() => loading = true);
                    // TODO: pass real token from secure storage
                    final result = await AuthService.changePassword(
                      oldPassword: oldCtrl.text.trim(),
                      newPassword: newCtrl.text.trim(),
                    );
                    setS(() => loading = false);
                    if (!mounted) return;
                    Navigator.pop(ctx);
                    if (result.success) {
                      _snack('Password changed successfully!');
                    } else {
                      _snack(result.error ?? 'Failed to change password', error: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green, foregroundColor: Colors.white, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Update Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── RESET PASSWORD ─────────────────────────────────────────────────────────
  void _showResetPassword() {
    final emailCtrl = TextEditingController();
    final newCtrl   = TextEditingController();
    final confCtrl  = TextEditingController();
    bool newHidden  = true;
    bool confHidden = true;
    bool loading    = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardDark,
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
              Text('Reset Password', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _textPrimary)),
              const SizedBox(height: 4),
              Text('Enter your email and set a new password.', style: TextStyle(fontSize: 13, color: _textMuted)),
              const SizedBox(height: 24),
              _sheetLabel('Email Address'),
              const SizedBox(height: 8),
              _sheetInput(ctrl: emailCtrl, hint: 'your@email.com', icon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _sheetLabel('New Password'),
              const SizedBox(height: 8),
              _sheetInput(ctrl: newCtrl, hint: '••••••••', icon: Icons.lock_outline_rounded, obscure: newHidden,
                  suffix: GestureDetector(onTap: () => setS(() => newHidden = !newHidden),
                      child: Icon(newHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _textMuted, size: 20))),
              const SizedBox(height: 16),
              _sheetLabel('Confirm New Password'),
              const SizedBox(height: 8),
              _sheetInput(ctrl: confCtrl, hint: '••••••••', icon: Icons.lock_outline_rounded, obscure: confHidden,
                  suffix: GestureDetector(onTap: () => setS(() => confHidden = !confHidden),
                      child: Icon(confHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _textMuted, size: 20))),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : () async {
                    if (emailCtrl.text.trim().isEmpty) {
                      _snack('Please enter your email', error: true); return;
                    }
                    if (newCtrl.text != confCtrl.text) {
                      _snack('Passwords do not match', error: true); return;
                    }
                    if (newCtrl.text.length < 6) {
                      _snack('Password must be at least 6 characters', error: true); return;
                    }
                    setS(() => loading = true);
                    final result = await AuthService.resetPassword(
                      email: emailCtrl.text.trim(),
                      newPassword: newCtrl.text.trim(),
                    );
                    setS(() => loading = false);
                    if (!mounted) return;
                    Navigator.pop(ctx);
                    if (result.success) {
                      _snack('Password reset successfully!');
                    } else {
                      _snack(result.error ?? 'Failed to reset password', error: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange, foregroundColor: Colors.white, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Reset Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sheet helpers ──────────────────────────────────────────────────────────
  Widget _sheetLabel(String text) => Text(text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.4));

  Widget _sheetInput({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: _inputBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border, width: 1)),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14, color: _textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: _textMuted, fontSize: 14),
          prefixIcon: Icon(icon, color: _textMuted, size: 18),
          suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.only(right: 14), child: suffix) : null,
          suffixIconConstraints: const BoxConstraints(),
          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15), filled: false,
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                _sectionLabel('Preferences'), const SizedBox(height: 10),
                _card([
                  _toggleTile(Icons.notifications_outlined, 'Notifications', 'Receive scan updates', _notificationsEnabled, (v) => setState(() => _notificationsEnabled = v)),
                  _divider(),
                  _toggleTile(Icons.dark_mode_outlined, 'Dark Mode', 'Switch to dark theme', isDark, (_) => ref.read(themeProvider.notifier).toggle()),
                  _divider(),
                  _arrowTile(Icons.language_rounded, 'Language', 'English', () {}),
                ]),
                const SizedBox(height: 20),
                _sectionLabel('Security'), const SizedBox(height: 10),
                _card([
                  _arrowTile(Icons.lock_outline_rounded,  'Change Password', 'Update your password',      _showChangePassword),
                  _divider(),
                  _arrowTile(Icons.lock_reset_rounded,    'Reset Password',  'Set a new password via email', _showResetPassword),
                ]),
                const SizedBox(height: 20),
                _sectionLabel('About'), const SizedBox(height: 10),
                _card([
                  _arrowTile(Icons.help_outline_rounded,       'Help Center',    'Get support',       () => _push(const HelpCenterScreen())),
                  _divider(),
                  _arrowTile(Icons.description_outlined,       'Terms & Privacy','Legal information', () => _push(const TermsPrivacyScreen())),
                  _divider(),
                  _plainTile(Icons.insert_drive_file_outlined, 'App Version',    'v1.0.0'),
                ]),
                const SizedBox(height: 16),
                _card([_logOutTile()]),
                const SizedBox(height: 32),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
    decoration: BoxDecoration(color: _headerBg, border: Border(bottom: BorderSide(color: _border, width: 1))),
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(width: 38, height: 38,
                decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                child: Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20)),
          ),
          const SizedBox(width: 14),
          Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
        ]),
      ),
    ),
  );

  Widget _sectionLabel(String text) => Text(text,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5));

  Widget _card(List<Widget> children) => Container(
    decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
    child: Column(children: children),
  );

  Widget _divider() => Divider(height: 1, thickness: 0.8, indent: 68, color: _border);

  Widget _iconBubble(IconData icon, {Color? color}) => Container(
    width: 40, height: 40,
    decoration: BoxDecoration(color: (color ?? _green).withOpacity(0.13), shape: BoxShape.circle, border: Border.all(color: (color ?? _green).withOpacity(0.2))),
    child: Icon(icon, color: color ?? _greenLight, size: 19),
  );

  Widget _toggleTile(IconData icon, String title, String sub, bool value, ValueChanged<bool> onChanged) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      _iconBubble(icon), const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
        Text(sub,   style: TextStyle(fontSize: 12, color: _textMuted)),
      ])),
      Switch.adaptive(value: value, onChanged: onChanged, activeColor: _green),
    ]),
  );

  Widget _arrowTile(IconData icon, String title, String sub, VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(16),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        _iconBubble(icon), const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
          Text(sub,   style: TextStyle(fontSize: 12, color: _textMuted)),
        ])),
        Icon(Icons.chevron_right_rounded, color: _textMuted, size: 20),
      ]),
    ),
  );

  Widget _plainTile(IconData icon, String title, String sub) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      _iconBubble(icon), const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
        Text(sub,   style: TextStyle(fontSize: 12, color: _textMuted)),
      ]),
    ]),
  );

  Widget _logOutTile() => InkWell(
    onTap: _confirmLogout,
    borderRadius: BorderRadius.circular(16),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(width: 40, height: 40,
            decoration: BoxDecoration(color: _red.withOpacity(0.13), shape: BoxShape.circle, border: Border.all(color: _red.withOpacity(0.25))),
            child: Icon(Icons.logout_rounded, color: _red, size: 19)),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Log Out',              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _red)),
          Text('Sign out of account', style: TextStyle(fontSize: 12, color: _textMuted)),
        ]),
      ]),
    ),
  );

  Widget _buildFooter() => Column(children: [
    Container(width: 64, height: 64,
        decoration: BoxDecoration(color: _green.withOpacity(0.15), borderRadius: BorderRadius.circular(18), border: Border.all(color: _green.withOpacity(0.3))),
        child: Icon(Icons.eco_rounded, color: _greenLight, size: 32)),
    const SizedBox(height: 12),
    Text('PlantCare AI', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _textPrimary)),
    const SizedBox(height: 4),
    Text('Your trusted plant health companion', style: TextStyle(fontSize: 12, color: _textMuted)),
    const SizedBox(height: 6),
    Text('© 2026 PlantCare AI. All rights reserved.', style: TextStyle(fontSize: 11, color: _textMuted)),
  ]);
}