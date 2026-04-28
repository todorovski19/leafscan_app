import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary      = Color(0xFF5C9E78);
  static const Color primaryLight = Color(0xFF7CC49A);
  static const Color primaryMint  = Color(0xFFA8D5B5);
  static const Color primaryDark  = Color(0xFF3A7A56);

  static const Color splashBg    = Color(0xFF28313D);
  static const Color splashText  = Color(0xFFDCE4DF);
  static const Color splashMuted = Color(0xFF637068);

  static const Color background  = Color(0xFFF0EDE6);
  static const Color cardBg      = Color(0xFFFFFFFF);
  static const Color textDark    = Color(0xFF1A1A1A);
  static const Color textMuted   = Color(0xFF8A8A8A);
  static const Color border      = Color(0xFFDDDDD8);

  static const Color dot1 = Color(0xFF3D5C4A);
  static const Color dot2 = Color(0xFF527A62);
  static const Color dot3 = Color(0xFF7AA08A);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      background: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.6),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 15),
    ),
  );
}