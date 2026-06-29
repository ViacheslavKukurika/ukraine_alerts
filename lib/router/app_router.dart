/*-----------------------------------------------------------------------------
    AppRouter описує навігацію між екранами та створює залежності, необхідні
  для роботи функціональності повітряних тривог.

  Для HomeScreen додаткові залежності не потрібні. Для AlertsMapScreen і
  RegionAlertsScreen створюється послідовний ланцюг:

    Dio → AlertsApiService → AlertsRepository → Cubit → Screen.

    Dio виконує HTTP-запити, API Service працює з конкретними endpoint,
  Repository перетворює сирі відповіді на моделі застосунку, а Cubit керує
  станом відповідного екрана. BlocProvider передає створений Cubit вниз по
  дереву віджетів і автоматично закриває його після виходу з маршруту.
-----------------------------------------------------------------------------*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ukraine_alerts/core/network/dio_client.dart';
import 'package:ukraine_alerts/features/alerts/data/api/alerts_api_service.dart';
import 'package:ukraine_alerts/features/alerts/data/repositories/alerts_repository.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_cubit.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/region_alert_cubit.dart';
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
        builder: (context, state) {
          final dio = DioClient.create();
          final apiService = AlertsApiService(dio);
          final repository = AlertsRepository(apiService);
          return BlocProvider(
            create: (_) => AlertsMapCubit(repository)
              ..loadAirRaidStatuses()
              ..startAutoRefresh(),
            child: const AlertsMapScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutesPaths.regionAlerts,
        name: AppRoutesNames.regionAlerts,
        builder: (context, state) {
          final dio = DioClient.create();
          final apiService = AlertsApiService(dio);
          final repository = AlertsRepository(apiService);
          return BlocProvider(
            create: (context) => RegionAlertCubit(repository),
            child: const RegionAlertsScreen(),
          );
        },
      ),
    ],
  );
}
