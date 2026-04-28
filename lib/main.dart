import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafscan_app/router/app_router.dart';
import 'package:leafscan_app/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: LeafScanApp(),
    ),
  );
}

class LeafScanApp extends StatelessWidget {
  const LeafScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PlantCare AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}