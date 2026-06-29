/*-----------------------------------------------------------------------------
  AlertsMapScreen відображає загальний стан повітряних тривог в Україні.

  Екран слухає AlertsMapCubit через BlocBuilder і залежно від State показує
початкове завантаження, повідомлення про помилку з кнопкою повторної спроби або
успішно завантажену карту.

  UkraineAlertsMap отримує Map<Region, AirRaidStatus> та змінює прозорість
PNG-overlay кожного регіону. Нижче формується відсортований список областей із
повною або частковою тривогою.

  В AppBar розташовані легенда та кнопка ручного оновлення. Для кнопки викори-
-стовується окремий BlocBuilder із buildWhen, оскільки її вигляд залежить лише
від requestStatus, а не від зміни самих даних карти.
-----------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_cubit.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/alert_region_card.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/alerts_map_legend.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/ukraine_alerts_map.dart';

class AlertsMapScreen extends StatelessWidget {
  const AlertsMapScreen({super.key});

  static const Color _alertsMapAppBarColor = Color(0xFFB3DFF7);
  static const Color _alertsMapBackgroundColor = Color(0xFFA0D6F5);
  static const String _refreshIconPath =
      'assets/images/icons/circular_arrow.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _alertsMapBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Назад',
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24,
          ),
        ),
        title: Text(
          'Alerts Map',
          style: GoogleFonts.kameron(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E1E1E),
          ),
        ),
        centerTitle: true,
        backgroundColor: _alertsMapAppBarColor,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        // залишає стабільний колір AppBar при скролі
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Позначення на карті',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF9ED6F5),
                    surfaceTintColor: Colors.transparent,
                    title: const Text('Позначення'),
                    content: const AlertsMapLegend(),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Закрити'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          BlocBuilder<AlertsMapCubit, AlertsMapState>(
            buildWhen: (previous, current) {
              return previous.requestStatus != current.requestStatus;
            },
            builder: (context, state) {
              final isLoading = state.requestStatus == RequestStatus.loading;

              return IconButton(
                tooltip: 'Оновити карту',
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<AlertsMapCubit>().loadAirRaidStatuses();
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const ImageIcon(
                        AssetImage(_refreshIconPath),
                        size: 20,
                      ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AlertsMapCubit, AlertsMapState>(
        builder: (context, state) {
          final hasData = state.regionStatuses.isNotEmpty;

          if (state.isInitialLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.requestStatus == RequestStatus.failure && !hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'Сталася невідома помилка',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AlertsMapCubit>().loadAirRaidStatuses();
                      },
                      child: const Text('Спробувати ще раз'),
                    ),
                  ],
                ),
              ),
            );
          }

          final alertEntries =
              state.regionStatuses.entries
                  .where(
                    (entry) =>
                        entry.value == AirRaidStatus.active ||
                        entry.value == AirRaidStatus.partial,
                  )
                  .toList()
                ..sort(
                  (first, second) =>
                      first.key.label.compareTo(second.key.label),
                );

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.45,
                  child: UkraineAlertsMap(
                    regionStatuses: state.regionStatuses,
                  ),
                ),
                const SizedBox(height: 16),
                if (alertEntries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Активних повітряних тривог немає',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alertEntries.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final entry = alertEntries[index];

                      return AlertRegionCard(
                        region: entry.key,
                        status: entry.value,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
