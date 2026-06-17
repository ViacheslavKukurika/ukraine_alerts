import 'package:flutter/material.dart';
import 'package:ukraine_alerts/features/alerts/data/models/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/alert_status_card.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/region_dropdown.dart';

class RegionAlertsScreen extends StatelessWidget {
  const RegionAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Region Alerts'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            RegionDropdown(
              onSelected: (region) {
                debugPrint(region?.label ?? 'Регіон не вибрано');
              },
            ),
            SizedBox(height: 24),
            AlertStatusCard(status: AirRaidStatus.inactive),
          ],
        ),
      ),
    );
  }
}
