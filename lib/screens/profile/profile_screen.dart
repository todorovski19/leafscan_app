import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:leafscan_app/screens/profile/settings_screen.dart';
import 'package:leafscan_app/screens/profile/edit_profile_screen.dart';
import 'package:leafscan_app/screens/profile/help_center_screen.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark    => _c.cardBg;
  Color get _headerBg    => _c.headerBg;
  Color get _green       => _c.green;
  Color get _greenLight  => _c.greenLight;
  Color get _textPrimary => _c.textPrimary;
  Color get _textMuted   => _c.textMuted;
  Color get _orange      => _c.orange;
  Color get _border      => _c.border;

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

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? _c.red : _green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  Future<void> _shareApp() async {
    const text =
        'Check out PlantCare AI 🌿 — instantly identify plant diseases and get care tips. '
        'Download: https://plantcare-ai.app';
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      text,
      subject: 'PlantCare AI',
      sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
    );
  }

  void _openHelpCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
    );
  }

  void _showRateDialog() {
    int rating = 0;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          backgroundColor: _cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _orange.withOpacity(0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: _orange.withOpacity(0.35)),
                  ),
                  child: Icon(Icons.star_rounded, color: _orange, size: 32),
                ),
                const SizedBox(height: 16),
                Text('Enjoying PlantCare AI?',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800, color: _textPrimary)),
                const SizedBox(height: 6),
                Text(
                  'Tap a star to rate your experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: _textMuted, height: 1.4),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < rating;
                    return GestureDetector(
                      onTap: () => setS(() => rating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AnimatedScale(
                          scale: filled ? 1.0 : 0.92,
                          duration: const Duration(milliseconds: 150),
                          child: Icon(
                            filled ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: 38,
                            color: filled ? _orange : _textMuted,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 18,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      _ratingLabel(rating),
                      key: ValueKey(rating),
                      style: TextStyle(
                          fontSize: 12, color: _greenLight, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Maybe Later',
                            style: TextStyle(color: _textMuted, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: rating == 0
                            ? null
                            : () {
                                Navigator.pop(ctx);
                                _snack('Thanks for the $rating-star rating!');
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _green.withOpacity(0.35),
                          disabledForegroundColor: Colors.white70,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Submit',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1: return 'We\'ll do better — tell us why.';
      case 2: return 'Thanks — we\'re listening.';
      case 3: return 'Glad you\'re using it!';
      case 4: return 'Awesome, thank you!';
      case 5: return 'You\'re amazing 🌟';
      default: return '';
    }
  }

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
              leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: _green.withOpacity(0.15), shape: BoxShape.circle), child: Icon(Icons.camera_alt_rounded, color: _greenLight, size: 20)),
              title: Text('Take a Photo', style: TextStyle(fontWeight: FontWeight.w600, color: _textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: _green.withOpacity(0.15), shape: BoxShape.circle), child: Icon(Icons.photo_library_rounded, color: _greenLight, size: 20)),
              title: Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600, color: _textPrimary)),
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
                  _buildActionCard(icon: Icons.share_rounded,       title: 'Share App',       subtitle: 'Invite friends to PlantCare AI', onTap: _shareApp),
                  const SizedBox(height: 10),
                  _buildActionCard(icon: Icons.star_rounded,        title: 'Rate Us',         subtitle: 'Love the app? Leave a review',   onTap: _showRateDialog),
                  const SizedBox(height: 10),
                  _buildActionCard(icon: Icons.help_outline_rounded, title: 'Help & Support', subtitle: 'Get assistance anytime',          onTap: _openHelpCenter),
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
      decoration: BoxDecoration(color: _headerBg, border: Border(bottom: BorderSide(color: _border, width: 1))),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textPrimary)),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                  child: Icon(Icons.settings_outlined, color: _textMuted, size: 20),
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
            Text(_name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textPrimary)),
            const SizedBox(height: 2),
            Text(_bio, style: TextStyle(fontSize: 14, color: _textMuted)),
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
            : Icon(Icons.eco_rounded, color: _greenLight, size: 36),
      ),
      Positioned(
        bottom: 0, right: 0,
        child: GestureDetector(
          onTap: _pickImage,
          child: Container(width: 26, height: 26, decoration: BoxDecoration(color: _orange, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 13)),
        ),
      ),
    ]));
  }

  Widget _infoRow(IconData icon, String text) => Row(children: [
    Icon(icon, size: 16, color: _textMuted), const SizedBox(width: 10),
    Text(text, style: TextStyle(fontSize: 13, color: _textMuted)),
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
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: _textMuted), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _sectionLabel(String title) => Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary));

  Widget _buildAchievementCard(_Achievement a) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border, width: 1)),
      child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: a.iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: a.iconColor.withOpacity(0.3))),
            child: Icon(a.icon, color: a.iconColor, size: 20)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(a.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textPrimary)),
          const SizedBox(height: 2),
          Text(a.subtitle, style: TextStyle(fontSize: 12, color: _textMuted)),
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
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12, color: _textMuted)),
          ])),
          Icon(Icons.chevron_right_rounded, color: _textMuted, size: 20),
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