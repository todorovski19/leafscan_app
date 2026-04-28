import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafscan_app/providers/theme_provider.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// main.dart — entry point
// Place in: lib/main.dart
// ─────────────────────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: LeafScanApp(),
    ),
  );
}

// ConsumerWidget so we can watch the themeProvider
class LeafScanApp extends ConsumerWidget {
  const LeafScanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'PlantCare AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,         // switches between light/dark
      routerConfig: AppRouter.router,
    );
  }
}
