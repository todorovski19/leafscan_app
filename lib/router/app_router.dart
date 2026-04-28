import 'package:go_router/go_router.dart';
import 'package:leafscan_app/screens/splash/splash_screen.dart';
import 'package:leafscan_app/screens/auth/auth_screen.dart';
import 'package:leafscan_app/screens/home/home_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppRouter — GoRouter route definitions
// Place in: lib/router/app_router.dart
// ─────────────────────────────────────────────────────────────────────────────

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login  = '/login';
  static const String home   = '/home';
  // Add more routes here as new screens arrive:
  // static const String scan    = '/scan';
  // static const String history = '/history';
  // static const String profile = '/profile';

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
    ],
  );
}