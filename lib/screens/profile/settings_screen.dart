import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafscan_app/providers/theme_provider.dart';
import 'package:leafscan_app/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SettingsScreen — ConsumerStatefulWidget so it can read & write themeProvider
// Place in: lib/screens/profile/settings_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    // Watch themeProvider — rebuilds when dark/light changes
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    final bg       = isDark ? AppColors.darkBackground : AppColors.background;
    final cardBg   = isDark ? AppColors.darkCardBg     : Colors.white;
    final textMain = isDark ? AppColors.darkTextDark   : AppColors.textDark;
    final textSub  = isDark ? AppColors.darkTextMuted  : AppColors.textMuted;
    final divColor = isDark ? AppColors.darkBorder     : const Color(0xFFEEEEEE);
    final iconBg   = isDark ? const Color(0xFF2A3D33)  : const Color(0xFFD6EEE2);

    return Scaffold(
      backgroundColor: bg,
      // ── App Bar ───────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textMain,
          ),
        ),
        centerTitle: false,
      ),
      // ── Body ──────────────────────────────────────────────────────────────
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── Preferences ─────────────────────────────────────────────────
          _sectionLabel('Preferences', textSub),
          const SizedBox(height: 10),
          _card(
            cardBg: cardBg,
            children: [
              _toggleTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Receive scan updates',
                value: _notificationsEnabled,
                onChanged: (v) => setState(() => _notificationsEnabled = v),
                textMain: textMain,
                textSub: textSub,
                iconBg: iconBg,
              ),
              _divider(divColor),
              // Dark Mode toggle — reads & writes themeProvider
              _toggleTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme',
                value: isDark,
                onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                textMain: textMain,
                textSub: textSub,
                iconBg: iconBg,
              ),
              _divider(divColor),
              _arrowTile(
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
                textMain: textMain,
                textSub: textSub,
                iconBg: iconBg,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Security ────────────────────────────────────────────────────
          _sectionLabel('Security', textSub),
          const SizedBox(height: 10),
          _card(
            cardBg: cardBg,
            children: [
              _arrowTile(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy Settings',
                subtitle: 'Manage your data',
                onTap: () {},
                textMain: textMain,
                textSub: textSub,
                iconBg: iconBg,
              ),
              _divider(divColor),
              _arrowTile(
                icon: Icons.lock_reset_rounded,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () {},
                textMain: textMain,
                textSub: textSub,
                iconBg: iconBg,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── About ────────────────────────────────────────────────────────
          _sectionLabel('About', textSub),
          const SizedBox(height: 10),
          _card(
            cardBg: cardBg,
            children: [
              _arrowTile(
                icon: Icons.help_outline_rounded,
                title: 'Help Center',
                subtitle: 'Get support',
                onTap: () {},
                textMain: textMain,
                textSub: textSub,
                iconBg: iconBg,
              ),
              _divider(divColor),
              _arrowTile(
                icon: Icons.description_outlined,
                title: 'Terms & Privacy',
                subtitle: 'Legal information',
                onTap: () {},
                textMain: textMain,
                textSub: textSub,
                iconBg: iconBg,
              ),
              _divider(divColor),
              _plainTile(
                icon: Icons.insert_drive_file_outlined,
                title: 'App Version',
                subtitle: 'v1.0.0',
                textMain: textMain,
                textSub: textSub,
                iconBg: iconBg,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Log Out ──────────────────────────────────────────────────────
          _card(
            cardBg: cardBg,
            children: [_logOutTile(onTap: () {})],
          ),

          const SizedBox(height: 36),

          // ── Footer ───────────────────────────────────────────────────────
          _buildFooter(textMain, textSub),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text, Color color) => Text(
    text,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );

  Widget _card({required Color cardBg, required List<Widget> children}) =>
      Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(children: children),
      );

  Widget _divider(Color color) => Divider(
    height: 1,
    thickness: 0.8,
    indent: 70,
    color: color,
  );

  Widget _iconBubble(IconData icon, Color bg) => Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    child: Icon(icon, color: AppColors.primary, size: 22),
  );

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textMain,
    required Color textSub,
    required Color iconBg,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _iconBubble(icon, iconBg),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textMain)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(fontSize: 13, color: textSub)),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      );

  Widget _arrowTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textMain,
    required Color textSub,
    required Color iconBg,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _iconBubble(icon, iconBg),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textMain)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(fontSize: 13, color: textSub)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: textSub, size: 22),
            ],
          ),
        ),
      );

  Widget _plainTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textMain,
    required Color textSub,
    required Color iconBg,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _iconBubble(icon, iconBg),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textMain)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 13, color: textSub)),
              ],
            ),
          ],
        ),
      );

  Widget _logOutTile({required VoidCallback onTap}) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFFDE8D8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout_rounded,
                color: Color(0xFFE8924A), size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Log Out',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE8924A))),
              SizedBox(height: 2),
              Text('Sign out of your account',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildFooter(Color textMain, Color textSub) => Column(
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF7CC49A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.eco_rounded,
            color: Colors.white, size: 42),
      ),
      const SizedBox(height: 12),
      Text('PlantCare AI',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textMain)),
      const SizedBox(height: 4),
      Text('Your trusted plant health companion',
          style: TextStyle(fontSize: 13, color: textSub)),
      const SizedBox(height: 8),
      Text('© 2026 PlantCare AI. All rights reserved.',
          style: TextStyle(fontSize: 12, color: textSub)),
    ],
  );
}
