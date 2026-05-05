import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafscan_app/theme/app_theme.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  static const Color _bg          = Color(0xFF161C18);
  static const Color _cardDark    = Color(0xFF1E2923);
  static const Color _green       = Color(0xFF5C9E78);
  static const Color _greenLight  = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted   = Color(0xFF7A9080);
  static const Color _orange      = Color(0xFFE8924A);
  static const Color _border      = Color(0xFF243028);
  static const Color _orangeBg    = Color(0xFF2A1F15);

  Future<void> _takePhoto(BuildContext context) async {
    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90);
    if (photo != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Photo captured: ${photo.name}'),
        backgroundColor: _green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  Future<void> _uploadFromGallery(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (image != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image selected: ${image.name}'),
        backgroundColor: _green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTipBanner(),
                    const SizedBox(height: 20),
                    _buildTakePhotoBtn(context),
                    const SizedBox(height: 12),
                    _buildGalleryBtn(context),
                    const SizedBox(height: 32),
                    _buildPhotoTips(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: _cardDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
              child: const Icon(Icons.arrow_back_rounded, color: _textMuted, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          const Text('Scan Plant', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
        ],
      ),
    );
  }

  Widget _buildTipBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _orangeBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _orange.withOpacity(0.25), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: _orange.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.tips_and_updates_outlined, color: _orange, size: 17),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Get Best Results', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _orange)),
                SizedBox(height: 3),
                Text('Photograph the affected leaf in good natural lighting. Make sure the entire leaf is visible.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9A6030), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakePhotoBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => _takePhoto(context),
      child: Container(
        width: double.infinity, height: 160,
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _green.withOpacity(0.45), width: 1.5),
          boxShadow: [BoxShadow(color: _green.withOpacity(0.1), blurRadius: 24, spreadRadius: 2)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: _green.withOpacity(0.15), borderRadius: BorderRadius.circular(16), border: Border.all(color: _greenLight.withOpacity(0.3), width: 1)),
              child: const Icon(Icons.camera_alt_rounded, color: _greenLight, size: 28),
            ),
            const SizedBox(height: 14),
            const Text('Take Photo', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 4),
            const Text('Use your camera to capture', style: TextStyle(fontSize: 12, color: _textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => _uploadFromGallery(context),
      child: Container(
        width: double.infinity, height: 160,
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _border, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.photo_library_outlined, color: _textMuted, size: 28),
            ),
            const SizedBox(height: 14),
            const Text('Upload from Gallery', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 4),
            const Text('Choose from your photos', style: TextStyle(fontSize: 12, color: _textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTips() {
    const tips = ['Use natural daylight for best results', 'Keep the leaf in focus and centred', 'Avoid shadows and reflections', 'Capture close-up of affected areas'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Photography Tips', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textMuted, letterSpacing: 0.3)),
        const SizedBox(height: 12),
        ...tips.map((tip) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 5, right: 10), decoration: const BoxDecoration(color: _green, shape: BoxShape.circle)),
              Expanded(child: Text(tip, style: const TextStyle(fontSize: 13, color: _textMuted, height: 1.4))),
            ],
          ),
        )),
      ],
    );
  }
}