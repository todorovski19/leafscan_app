import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ThemeProvider — persists dark/light mode across app restarts
// Place in: lib/providers/theme_provider.dart
// ─────────────────────────────────────────────────────────────────────────────

const _kThemeKey = 'dark_mode';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Default to light — _loadFromPrefs() will update asynchronously
    _loadFromPrefs();
    return ThemeMode.light;
  }

  // Read the saved preference from disk
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_kThemeKey) ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Toggle and persist
  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kThemeKey, !isDark);
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
