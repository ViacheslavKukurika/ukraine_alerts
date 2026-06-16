import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ukraine_alerts/router/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pushNamed(AppRoutesNames.alertsMap);
              },
               child: const Text('Alerts Map'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.pushNamed(AppRoutesNames.regionAlerts);
              },
               child: const Text('Region Alerts'),
            ),
          ],
        ),
      ),
    );
  }
}
