/*-----------------------------------------------------------------------------
  WIDGET
  
  AlertRegionCard відображає один регіон зі списку активних повітряних тривог на
екрані карти.

  Віджет отримує Region та AirRaidStatus, після чого визначає текст повідомлення
й колір залежно від того, чи тривога є повною або частковою. Картка показує
статусну іконку, назву регіону та короткий опис поточного стану.
-----------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

class AlertRegionCard extends StatelessWidget {
  const AlertRegionCard({
    required this.region,
    required this.status,
    super.key,
  });

  static const Color _alertCardColor = Color(0xFFC4E6F9);
  static const String _alertIconPath = 'assets/images/icons/alert_triangle.png';

  final Region region;
  final AirRaidStatus status;

  @override
  Widget build(BuildContext context) {
    final isFullAlert = status == AirRaidStatus.active;

    final statusText = isFullAlert
        ? 'Повітряна тривога в усьому регіоні'
        : 'Часткова повітряна тривога';

    final statusColor = isFullAlert
        ? Theme.of(context).colorScheme.error
        : Colors.orange.shade800;

    return Card(
      color: _alertCardColor,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shadowColor: Colors.black26,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: SizedBox(
          width: 42,
          height: 42,
          child: Center(
            child: Image.asset(
              _alertIconPath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.warning_amber_rounded,
                  color: statusColor,
                  size: 30,
                );
              },
            ),
          ),
        ),
        title: Text(
          region.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
            ),
          ),
        ),
      ),
    );
  }
}
