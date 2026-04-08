import 'package:go_router/go_router.dart';

import '../models/scan_record.dart';
import '../screens/guide_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/preview_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/results_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/preview', builder: (context, state) => const PreviewScreen()),
    GoRoute(
      path: '/results',
      builder: (context, state) {
        final record = state.extra as ScanRecord;
        return ResultsScreen(record: record);
      },
    ),
    GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
    GoRoute(path: '/guide', builder: (context, state) => const GuideScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
  ],
);
