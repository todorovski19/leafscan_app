import 'package:go_router/go_router.dart';
import 'package:leafscan_app/screens/splash/splash_screen.dart';
import 'package:leafscan_app/screens/auth/auth_screen.dart';
import 'package:leafscan_app/screens/home/home_screen.dart';
import 'package:leafscan_app/screens/scan/scan_screen.dart';
import 'package:leafscan_app/screens/history/history_screen.dart';
import 'package:leafscan_app/screens/profile/profile_screen.dart';
import 'package:leafscan_app/screens/disease/disease_detail_screen.dart';
import 'package:leafscan_app/screens/plant/plant_detail_screen.dart';
import 'package:leafscan_app/screens/history/scan_detail_screen.dart';
import 'package:leafscan_app/screens/scans/upload_screen.dart';
import 'package:leafscan_app/screens/scans/analyzing_screen.dart' as analyzingLib;
// ─────────────────────────────────────────────────────────────────────────────
// AppRouter — GoRouter route definitions
// ─────────────────────────────────────────────────────────────────────────────

class AppRouter {
  AppRouter._();

  static const String splash        = '/';
  static const String login         = '/login';
  static const String home          = '/home';
  static const String scan          = '/scan';
  static const String result        = '/result';
  static const String profile       = '/profile';
  static const String history       = '/history';
  static const String diseaseDetail = '/disease/:id';
  static const String plantDetail   = '/plant/:id';
  static const String upload        = '/upload';
  static const String analyzing     = '/analyzing';

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
        builder: (context, state) => ScanScreen(),
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
          final id = int.parse(state.pathParameters['id']!);
          return DiseaseDetailScreen(diseaseId: id);
        },
      ),
      GoRoute(
        path: '/plant/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PlantDetailScreen(plantId: id);
        },
      ),
      GoRoute(
        path: result,
        builder: (context, state) {
          final data = state.extra as ScanDetailData;
          return ScanDetailScreen(data: data);
        },
      ),
      GoRoute(
        path: upload,
        builder: (context, state) {
          final imagePath = state.extra as String;
          return UploadScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: analyzing,
        builder: (context, state) {
          final imagePath = state.extra as String;
          return analyzingLib.AnalyzingScreen(imagePath: imagePath);        },
      ),
    ],
  );
}
