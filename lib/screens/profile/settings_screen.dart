import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafscan_app/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _orange      = Color(0xFFE8924A);
  static const Color _border      = Color(0xFF243028);

  bool _notificationsEnabled = true;

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
                _sectionLabel('Preferences'),  const SizedBox(height: 10),
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
                  _arrowTile(Icons.lock_outline_rounded,  'Privacy Settings', 'Manage your data',    () {}),
                  _divider(),
                  _arrowTile(Icons.lock_reset_rounded,    'Change Password',  'Update your password', () {}),
                ]),
                const SizedBox(height: 20),
                _sectionLabel('About'), const SizedBox(height: 10),
                _card([
                  _arrowTile(Icons.help_outline_rounded,       'Help Center',    'Get support',        () {}),
                  _divider(),
                  _arrowTile(Icons.description_outlined,       'Terms & Privacy','Legal information',  () {}),
                  _divider(),
                  _plainTile(Icons.insert_drive_file_outlined, 'App Version',    'v1.0.0'),
                ]),
                const SizedBox(height: 16),
                _card([_logOutTile(() {})]),
                const SizedBox(height: 32),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF1A211D), border: Border(bottom: BorderSide(color: Color(0xFF243028), width: 1))),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(width: 38, height: 38, decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                  child: const Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20)),
            ),
            const SizedBox(width: 14),
            const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
          ]),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.5));

  Widget _card(List<Widget> children) => Container(
    decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
    child: Column(children: children),
  );

  Widget _divider() => Divider(height: 1, thickness: 0.8, indent: 68, color: _border);

  Widget _iconBubble(IconData icon) => Container(
    width: 40, height: 40,
    decoration: BoxDecoration(color: _green.withOpacity(0.13), shape: BoxShape.circle, border: Border.all(color: _green.withOpacity(0.2))),
    child: Icon(icon, color: _greenLight, size: 19),
  );

  Widget _toggleTile(IconData icon, String title, String sub, bool value, ValueChanged<bool> onChanged) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      _iconBubble(icon), const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
        Text(sub,   style: const TextStyle(fontSize: 12, color: _textMuted)),
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
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
          Text(sub,   style: const TextStyle(fontSize: 12, color: _textMuted)),
        ])),
        const Icon(Icons.chevron_right_rounded, color: _textMuted, size: 20),
      ]),
    ),
  );

  Widget _plainTile(IconData icon, String title, String sub) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      _iconBubble(icon), const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
        Text(sub,   style: const TextStyle(fontSize: 12, color: _textMuted)),
      ]),
    ]),
  );

  Widget _logOutTile(VoidCallback onTap) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(16),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: _orange.withOpacity(0.13), shape: BoxShape.circle, border: Border.all(color: _orange.withOpacity(0.25))),
            child: const Icon(Icons.logout_rounded, color: _orange, size: 19)),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Log Out',              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _orange)),
          Text('Sign out of account', style: TextStyle(fontSize: 12, color: _textMuted)),
        ]),
      ]),
    ),
  );

  Widget _buildFooter() => Column(children: [
    Container(width: 64, height: 64, decoration: BoxDecoration(color: _green.withOpacity(0.15), borderRadius: BorderRadius.circular(18), border: Border.all(color: _green.withOpacity(0.3))),
        child: const Icon(Icons.eco_rounded, color: _greenLight, size: 32)),
    const SizedBox(height: 12),
    const Text('PlantCare AI', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _textPrimary)),
    const SizedBox(height: 4),
    const Text('Your trusted plant health companion', style: TextStyle(fontSize: 12, color: _textMuted)),
    const SizedBox(height: 6),
    const Text('© 2026 PlantCare AI. All rights reserved.', style: TextStyle(fontSize: 11, color: _textMuted)),
  ]);
}