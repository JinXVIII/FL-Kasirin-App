import 'package:go_router/go_router.dart';

import '../../presentations/screens/dashboard/dashboard_screen.dart';

class RouteConstants {
  static const String dashboard = 'dashboard';
  static const String dashboardPath = '/dashboard';
}

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: RouteConstants.dashboardPath,
    routes: [
      GoRoute(
        name: RouteConstants.dashboard,
        path: RouteConstants.dashboardPath,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
