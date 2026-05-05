import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/widgets/app_bottom_nav_bar.dart';

class UploadScreen extends StatefulWidget {
  final String imagePath;
  const UploadScreen({super.key, required this.imagePath});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  static const Color _bg         = Color(0xFF161C18);
  static const Color _cardDark   = Color(0xFF1E2923);
  static const Color _green      = Color(0xFF5C9E78);
  static const Color _greenLight = Color(0xFF7CC49A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textMuted  = Color(0xFF7A9080);
  static const Color _border     = Color(0xFF243028);

  Uint8List? _imageBytes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final bytes = await XFile(widget.imagePath).readAsBytes();
      if (mounted) setState(() { _imageBytes = bytes; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // ── Hero image ──────────────────────────────────────────────────
          Stack(
            children: [
              // Image
              SizedBox(
                width: double.infinity,
                height: screenH * 0.52,
                child: _loading
                    ? Container(
                  color: const Color(0xFF0D1510),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: _green, strokeWidth: 2),
                  ),
                )
                    : _imageBytes != null
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder())
                    : _placeholder(),
              ),

              // ── Top gradient so back button is readable ─────────────────
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  height: 110,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xCC000000), Colors.transparent],
                    ),
                  ),
                ),
              ),

              // ── Back button — blends into gradient ──────────────────────
              Positioned(
                top: 0, left: 0, right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(
                              // subtle frosted look — no harsh box, blends with gradient
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.18),
                                  width: 1),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 17),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(color: Colors.black45, blurRadius: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Bottom fade into bg ─────────────────────────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, _bg],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Content ─────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: [
                  // AI badge card
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: _cardDark,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _border, width: 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: _green.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _greenLight.withOpacity(0.3), width: 1),
                          ),
                          child: const Icon(Icons.auto_awesome_rounded,
                              color: _greenLight, size: 24),
                        ),
                        const SizedBox(height: 10),
                        const Text('AI-Powered Analysis',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _textPrimary)),
                        const SizedBox(height: 4),
                        const Text('Our AI will analyze your plant in seconds',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: _textMuted,
                                height: 1.4)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Analyze Plant CTA
                  GestureDetector(
                    onTap: () => context.push(
                        AppRouter.analyzing,
                        extra: widget.imagePath),
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: _green.withOpacity(0.35),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: const Center(
                        child: Text('Analyze Plant',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                  _buildPhotoTips(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFF0D1510),
    child: Center(
        child: Icon(Icons.broken_image_outlined,
            color: _green.withOpacity(0.3), size: 64)),
  );

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
        const Text('Photography Tips',
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
                  decoration: const BoxDecoration(
                      color: _green, shape: BoxShape.circle)),
              Expanded(
                  child: Text(tip,
                      style: const TextStyle(
                          fontSize: 13, color: _textMuted, height: 1.4))),
            ],
          ),
        )),
      ],
    );
  }
}