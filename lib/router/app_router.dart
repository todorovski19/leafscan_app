import 'package:go_router/go_router.dart';
import 'package:leafscan_app/screens/splash/splash_screen.dart';
import 'package:leafscan_app/screens/auth/auth_screen.dart';
import 'package:leafscan_app/screens/home/home_screen.dart';
import 'package:leafscan_app/screens/scan/scan_screen.dart';
import 'package:leafscan_app/screens/history/history_screen.dart';
import 'package:leafscan_app/screens/profile/profile_screen.dart';
import 'package:leafscan_app/screens/disease/disease_detail_screen.dart';


// ─────────────────────────────────────────────────────────────────────────────
// AppRouter — GoRouter route definitions
// Place in: lib/router/app_router.dart
// ─────────────────────────────────────────────────────────────────────────────

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String scan = '/scan';

  static const String profile = '/profile';
  static const String history = '/history';
  static const String diseaseDetail = '/disease/:id';


  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: scan,
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/disease/:id',
        builder: (context, state) {
          // Го земаме id-то од URL-от и го претвораме во int
          final id = int.parse(state.pathParameters['id']!);
          return DiseaseDetailScreen(diseaseId: id);
        },
      ),
    ],
  );
}


