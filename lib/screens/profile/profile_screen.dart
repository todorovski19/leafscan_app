import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafscan_app/screens/profile/settings_screen.dart';
import 'package:leafscan_app/screens/profile/edit_profile_screen.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _orange      = Color(0xFFE8924A);
  static const Color _border      = Color(0xFF243028);

  static const String _name     = 'Sarah Johnson';
  static const String _bio      = 'Plant Enthusiast 🌿';
  static const String _email    = 'sarah.j@email.com';
  static const String _phone    = '+1 (555) 123-4567';
  static const String _location = 'San Francisco, CA';

  File? _profileImage;

  static const List<_Achievement> _achievements = [
    _Achievement(icon: Icons.eco_rounded,             iconColor: Color(0xFF7CC49A), title: 'Plant Expert',    subtitle: '50+ scans completed'),
    _Achievement(icon: Icons.trending_up_rounded,     iconColor: Color(0xFFE8924A), title: 'Early Adopter',   subtitle: 'Member since 2026'),
    _Achievement(icon: Icons.workspace_premium_rounded,iconColor: Color(0xFF5C9E78), title: 'Healthy Garden', subtitle: '80% healthy plants'),
  ];

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: _cardDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2))),
            ListTile(
              leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: _green.withOpacity(0.15), shape: BoxShape.circle), child: const Icon(Icons.camera_alt_rounded, color: _greenLight, size: 20)),
              title: const Text('Take a Photo', style: TextStyle(fontWeight: FontWeight.w600, color: _textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: _green.withOpacity(0.15), shape: BoxShape.circle), child: const Icon(Icons.photo_library_rounded, color: _greenLight, size: 20)),
              title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600, color: _textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 85, maxWidth: 512, maxHeight: 512);
    if (picked != null && mounted) setState(() => _profileImage = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(context),
                  const SizedBox(height: 16),
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  _sectionLabel('Achievements'),
                  const SizedBox(height: 12),
                  ..._achievements.map((a) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _buildAchievementCard(a))),
                  const SizedBox(height: 24),
                  _sectionLabel('Quick Actions'),
                  const SizedBox(height: 12),
                  _buildActionCard(icon: Icons.share_rounded,       title: 'Share App',       subtitle: 'Invite friends to PlantCare AI', onTap: () {}),
                  const SizedBox(height: 10),
                  _buildActionCard(icon: Icons.star_rounded,        title: 'Rate Us',         subtitle: 'Love the app? Leave a review',   onTap: () {}),
                  const SizedBox(height: 10),
                  _buildActionCard(icon: Icons.help_outline_rounded, title: 'Help & Support', subtitle: 'Get assistance anytime',          onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF1A211D), border: Border(bottom: BorderSide(color: Color(0xFF243028), width: 1))),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textPrimary)),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                  child: const Icon(Icons.settings_outlined, color: _textMuted, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: _border, width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _buildAvatar(),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textPrimary)),
            const SizedBox(height: 2),
            Text(_bio, style: const TextStyle(fontSize: 14, color: _textMuted)),
          ]),
        ]),
        const SizedBox(height: 20),
        _infoRow(Icons.mail_outline_rounded,    _email),    const SizedBox(height: 10),
        _infoRow(Icons.phone_outlined,          _phone),    const SizedBox(height: 10),
        _infoRow(Icons.location_on_outlined,    _location),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
            style: OutlinedButton.styleFrom(
              foregroundColor: _greenLight,
              side: BorderSide(color: _green.withOpacity(0.5), width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: const Text('Edit Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(width: 80, height: 80, child: Stack(children: [
      Container(
        width: 76, height: 76,
        decoration: BoxDecoration(color: _green.withOpacity(0.15), borderRadius: BorderRadius.circular(18), border: Border.all(color: _green.withOpacity(0.3), width: 1.5)),
        clipBehavior: Clip.antiAlias,
        child: _profileImage != null
            ? Image.file(_profileImage!, fit: BoxFit.cover)
            : const Icon(Icons.eco_rounded, color: _greenLight, size: 36),
      ),
      Positioned(
        bottom: 0, right: 0,
        child: GestureDetector(
          onTap: _pickImage,
          child: Container(width: 26, height: 26, decoration: const BoxDecoration(color: _orange, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 13)),
        ),
      ),
    ]));
  }

  Widget _infoRow(IconData icon, String text) => Row(children: [
    Icon(icon, size: 16, color: _textMuted), const SizedBox(width: 10),
    Text(text, style: const TextStyle(fontSize: 13, color: _textMuted)),
  ]);

  Widget _buildStatsRow() {
    return Row(children: [
      Expanded(child: _statCard(Icons.eco_rounded,        '12',  'Plants',      _greenLight)),
      const SizedBox(width: 10),
      Expanded(child: _statCard(Icons.camera_alt_rounded, '24',  'Scans',       _greenLight)),
      const SizedBox(width: 10),
      Expanded(child: _statCard(Icons.trending_up_rounded,'92%', 'Success',     _orange)),
    ]);
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
      child: Column(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.13), shape: BoxShape.circle, border: Border.all(color: color.withOpacity(0.25))),
            child: Icon(icon, color: color, size: 18)),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: _textMuted), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _sectionLabel(String title) => Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary));

  Widget _buildAchievementCard(_Achievement a) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
      child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: a.iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: a.iconColor.withOpacity(0.3))),
            child: Icon(a.icon, color: a.iconColor, size: 20)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(a.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textPrimary)),
          const SizedBox(height: 2),
          Text(a.subtitle, style: const TextStyle(fontSize: 12, color: _textMuted)),
        ])),
        const Text('🏆', style: TextStyle(fontSize: 20)),
      ]),
    );
  }

  Widget _buildActionCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: _textMuted)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: _textMuted, size: 20),
        ]),
      ),
    );
  }
}

class _Achievement {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  const _Achievement({required this.icon, required this.iconColor, required this.title, required this.subtitle});
}