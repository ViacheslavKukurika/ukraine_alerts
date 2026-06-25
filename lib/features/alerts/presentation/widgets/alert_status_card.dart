/*-------------------------------------------------------------------
  Віджет отримує AirRaidStatus і через switch формує відповідний
 статусний контент: іконку та текст повідомлення.
-------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';

class AlertStatusCard extends StatelessWidget {
  const AlertStatusCard({
    required this.status,
    super.key,
  });

  static const String _alarmIconPath = 'assets/images/region/image_alarm.png';

  static const String _inactiveIconPath =
      'assets/images/region/green_circular.png';

  final AirRaidStatus status;

  @override
  Widget build(BuildContext context) {
    final content = switch (status) {
      AirRaidStatus.active => Column(
        key: const ValueKey(AirRaidStatus.active),
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            _alarmIconPath,
            width: 101,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            'Повітряна тривога!\n'
            'Будь ласка, пройдіть до укриття',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ],
      ),

      AirRaidStatus.inactive => Column(
        key: const ValueKey(AirRaidStatus.inactive),
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            _inactiveIconPath,
            width: 110,
            height: 110,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            'Немає тривоги',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),

      AirRaidStatus.partial => const Column(
        key: ValueKey(AirRaidStatus.partial),
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 100,
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Text(
            'Часткова повітряна тривога',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),

      AirRaidStatus.unknown => const SizedBox.shrink(
        key: ValueKey(AirRaidStatus.unknown),
      ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: content,
    );
  }
}
