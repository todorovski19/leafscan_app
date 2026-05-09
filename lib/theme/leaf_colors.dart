import 'package:flutter/material.dart';

class LeafColors {
  final Color bg;
  final Color cardBg;
  final Color headerBg;
  final Color inputBg;
  final Color green;
  final Color greenLight;
  final Color textPrimary;
  final Color textMuted;
  final Color orange;
  final Color border;
  final Color red;
  final Color shadow;

  const LeafColors._({
    required this.bg,
    required this.cardBg,
    required this.headerBg,
    required this.inputBg,
    required this.green,
    required this.greenLight,
    required this.textPrimary,
    required this.textMuted,
    required this.orange,
    required this.border,
    required this.red,
    required this.shadow,
  });

  static const LeafColors light = LeafColors._(
    bg:          Color(0xFFF2F0EA),
    cardBg:      Color(0xFFFFFFFF),
    headerBg:    Color(0xFFFBFAF6),
    inputBg:     Color(0xFFF2F0EA),
    green:       Color(0xFF5C9E78),
    greenLight:  Color(0xFF7CC49A),
    textPrimary: Color(0xFF1A211D),
    textMuted:   Color(0xFF6F7E76),
    orange:      Color(0xFFE8924A),
    border:      Color(0xFFE2E0DA),
    red:         Color(0xFFE05252),
    shadow:      Color(0x14000000),
  );

  static const LeafColors dark = LeafColors._(
    bg:          Color(0xFF161C18),
    cardBg:      Color(0xFF1E2923),
    headerBg:    Color(0xFF1A211D),
    inputBg:     Color(0xFF243028),
    green:       Color(0xFF5C9E78),
    greenLight:  Color(0xFF7CC49A),
    textPrimary: Color(0xFFF0EDE6),
    textMuted:   Color(0xFF7A9080),
    orange:      Color(0xFFE8924A),
    border:      Color(0xFF243028),
    red:         Color(0xFFE05252),
    shadow:      Color(0x33000000),
  );

  static LeafColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
