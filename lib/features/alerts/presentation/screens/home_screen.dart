import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukraine_alerts/router/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _alertsMapIconPath =
      'assets/images/icons/alerts_map_icon.png';

  static const String _regionAlertsIconPath =
      'assets/images/icons/region_alerts_icon.png';

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1E1E1E),
      elevation: 5,
      shadowColor: Colors.black26,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.kameron(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1EC0F2),
              Color(0xFF60D1CE),
              Color(0xFFB4E69F),
              Color(0xFFEFF57D),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        context.pushNamed(AppRoutesNames.alertsMap);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            _alertsMapIconPath,
                            width: 17,
                            height: 16,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          const Text('Alerts Map'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        context.pushNamed(AppRoutesNames.regionAlerts);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            _regionAlertsIconPath,
                            width: 29,
                            height: 16,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          const Text('Region Alerts'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
