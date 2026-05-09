import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';
import 'package:leafscan_app/theme/leaf_colors.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  LeafColors get _c => LeafColors.of(context);
  Color get _bg          => _c.bg;
  Color get _cardDark    => _c.cardBg;
  Color get _green       => _c.green;
  Color get _greenLight  => _c.greenLight;
  Color get _textPrimary => _c.textPrimary;
  Color get _textMuted   => _c.textMuted;
  Color get _orange      => _c.orange;
  Color get _border      => _c.border;
  Color get _orangeBg    => _c.orange.withOpacity(0.12);

  Future<void> _takePhoto(BuildContext context) async {
    final XFile? photo = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 90);
    if (photo != null && context.mounted) {
      context.push(AppRouter.upload, extra: photo.path);
    }
  }

  Future<void> _uploadFromGallery(BuildContext context) async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (image != null && context.mounted) {
      context.push(AppRouter.upload, extra: image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scan Plant',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary),
              ),
              const SizedBox(height: 20),
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
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
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
            decoration: BoxDecoration(
                color: _orange.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(Icons.tips_and_updates_outlined,
                color: _orange, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Get Best Results',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _orange)),
                SizedBox(height: 3),
                Text(
                    'Photograph the affected leaf in good natural lighting. '
                        'Make sure the entire leaf is visible.',
                    style: TextStyle(
                        fontSize: 12,
                        color: _textMuted,
                        height: 1.4)),
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
          boxShadow: [
            BoxShadow(
                color: _green.withOpacity(0.1),
                blurRadius: 24,
                spreadRadius: 2)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                  color: _green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: _greenLight.withOpacity(0.3), width: 1)),
              child: Icon(Icons.camera_alt_rounded,
                  color: _greenLight, size: 28),
            ),
            const SizedBox(height: 14),
            Text('Take Photo',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary)),
            const SizedBox(height: 4),
            Text('Use your camera to capture',
                style: TextStyle(fontSize: 12, color: _textMuted)),
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
              decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(Icons.photo_library_outlined,
                  color: _textMuted, size: 28),
            ),
            const SizedBox(height: 14),
            Text('Upload from Gallery',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary)),
            const SizedBox(height: 4),
            Text('Choose from your photos',
                style: TextStyle(fontSize: 12, color: _textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTips() {
    const tips = [
      'Use natural daylight for best results',
      'Keep the leaf in focus and centred',
      'Avoid shadows and reflections',
      'Capture close-up of affected areas',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photography Tips',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textMuted,
                letterSpacing: 0.3)),
        const SizedBox(height: 12),
        ...tips.map((tip) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 6, height: 6,
                  margin: const EdgeInsets.only(top: 5, right: 10),
                  decoration: BoxDecoration(
                      color: _green, shape: BoxShape.circle)),
              Expanded(
                  child: Text(tip,
                      style: TextStyle(
                          fontSize: 13,
                          color: _textMuted,
                          height: 1.4))),
            ],
          ),
        )),
      ],
    );
  }
}