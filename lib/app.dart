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
