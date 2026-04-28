import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafscan_app/theme/app_theme.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ScanScreen — take photo or upload from gallery
// Place in: lib/screens/scan/scan_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  Future<void> _takePhoto(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo != null && context.mounted) {
      // TODO: navigate to result screen with photo.path
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo captured: ${photo.name}'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _uploadFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (image != null && context.mounted) {
      // TODO: navigate to result screen with image.path
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image selected: ${image.name}'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryMint.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Scan Plant',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTipBanner(),
              const SizedBox(height: 16),
              _buildTakePhotoCard(context),
              const SizedBox(height: 12),
              _buildGalleryCard(context),
              const SizedBox(height: 28),
              _buildPhotoTips(),
              const SizedBox(height: 24),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E6D8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE8924A).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFFD4722A),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Best Results',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD4722A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Take a clear photo of the affected leaf in good lighting. Make sure the entire leaf is visible.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9A5020),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakePhotoCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _takePhoto(context),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: const Color(0xFF8EC4A4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Take Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Use your camera to capture',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _uploadFromGallery(context),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryMint.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.image_outlined,
                color: AppColors.primary.withOpacity(0.7),
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Upload from Gallery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                children: [
                  const TextSpan(text: 'Choose '),
                  TextSpan(
                    text: 'from your photos',
                    style: TextStyle(color: AppColors.primary.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTips() {
    const tips = [
      'Use natural daylight for best results',
      'Keep the leaf in focus and centered',
      'Avoid shadows and reflections',
      'Capture close-up of affected areas',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photography Tips',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        ...tips.map(
              (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 5, right: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}