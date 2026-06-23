/*
  Віджет, який отримує AirRaidStatus і на основі цих даних через switch
 обирає текст і колір в UI.
*/
import 'package:flutter/material.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';

class AlertStatusCard extends StatelessWidget {
  const AlertStatusCard({required this.status, super.key});

  final AirRaidStatus status;

  @override
  Widget build(BuildContext context) {
    final statusText = switch (status) {
      AirRaidStatus.active => 'Увага! Активна повітряна тривога',
      AirRaidStatus.partial => 'Часткова повітряна тривога',
      AirRaidStatus.inactive => 'Повітряна тривога відсутня',
      AirRaidStatus.unknown => 'Статус тривоги невідомий',
    };
    final backgroundColor = switch (status) {
      AirRaidStatus.active => Colors.red,
      AirRaidStatus.partial => const Color.fromARGB(255, 200, 159, 11),
      AirRaidStatus.inactive => Colors.greenAccent,
      AirRaidStatus.unknown => Colors.grey,
    };
    return AnimatedContainer(
      duration:  const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Text(          
          statusText,
          key: ValueKey(statusText),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
