import 'package:go_router/go_router.dart';
import 'package:ukraine_alerts/features/alerts/presentation/screens/alerts_map_screen.dart';
import 'package:ukraine_alerts/features/alerts/presentation/screens/home_screen.dart';
import 'package:ukraine_alerts/features/alerts/presentation/screens/region_alerts_screen.dart';
import 'package:ukraine_alerts/router/app_routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutesPaths.home,
    routes: [
      GoRoute(
        path: AppRoutesPaths.home,
        name: AppRoutesNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutesPaths.alertsMap,
        name: AppRoutesNames.alertsMap,
        builder: (context, state) => const AlertsMapScreen(),
      ),
      GoRoute(
        path: AppRoutesPaths.regionAlerts,
        name: AppRoutesNames.regionAlerts,
        builder: (context, state) => const RegionAlertsScreen(),
      ),
    ],
  );
}
