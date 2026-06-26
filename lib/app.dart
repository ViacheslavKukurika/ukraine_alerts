
/*-----------------------------------------------------------------------------
  Тут міститься кореневий віджет застосунку — клас App. App створює
 MaterialApp.router, у якому підключаються глобальна тема, назва застосунку та
 конфігурація GoRouter.

  Саме з цього рівня починається побудова інтерфейсу. MaterialApp.router
 використовується замість звичайного MaterialApp, тому що навігація між
 HomeScreen, AlertsMapScreen і RegionAlertsScreen виконується через окремо
 налаштований AppRouter.
-----------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:ukraine_alerts/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ukraine Alerts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D7DD2)),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
