import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppColors — light mode constants (use Theme.of(context) for dark-aware values)
// Place in: lib/theme/app_theme.dart
// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  static const Color primary      = Color(0xFF5C9E78);
  static const Color primaryLight = Color(0xFF7CC49A);
  static const Color primaryMint  = Color(0xFFA8D5B5);
  static const Color primaryDark  = Color(0xFF3A7A56);

  static const Color splashBg    = Color(0xFF28313D);
  static const Color splashText  = Color(0xFFDCE4DF);
  static const Color splashMuted = Color(0xFF637068);

  // Light mode
  static const Color background  = Color(0xFFF0EDE6);
  static const Color cardBg      = Color(0xFFFFFFFF);
  static const Color textDark    = Color(0xFF1A1A1A);
  static const Color textMuted   = Color(0xFF8A8A8A);
  static const Color border      = Color(0xFFDDDDD8);

  // Dark mode equivalents
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBg     = Color(0xFF1E1E1E);
  static const Color darkTextDark   = Color(0xFFF0F0F0);
  static const Color darkTextMuted  = Color(0xFF9E9E9E);
  static const Color darkBorder     = Color(0xFF2C2C2C);
  static const Color darkSurface    = Color(0xFF252525);

  static const Color dot1 = Color(0xFF3D5C4A);
  static const Color dot2 = Color(0xFF527A62);
  static const Color dot3 = Color(0xFF7AA08A);
}

class AppTheme {
  AppTheme._();

  // ── Light ──────────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      background: AppColors.background,
      surface: AppColors.cardBg,
    ),
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.cardBg,
    dividerColor: AppColors.border,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
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
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return const Color(0xFFD0D0D0);
      }),
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );

  // ── Dark ───────────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      background: AppColors.darkBackground,
      surface: AppColors.darkCardBg,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCardBg,
    dividerColor: AppColors.darkBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkCardBg,
      foregroundColor: AppColors.darkTextDark,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
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
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.6),
      ),
      hintStyle: const TextStyle(color: AppColors.darkTextMuted, fontSize: 15),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return const Color(0xFF444444);
      }),
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}
