
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
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_cubit.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/alerts_map_legend.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/ukraine_alerts_map.dart';

// Дані не у класі, щоб кольори не дублювати в різних частинах файлу

const Color _alertsMapAppBarColor = Color(0xFFB3DFF7);
const Color _alertsMapBackgroundColor = Color(0xFFA0D6F5);
const Color _alertCardColor = Color(0xFFC4E6F9);

const String _alertIconPath = 'assets/images/icons/alert_triangle.png';
const String _refreshIconPath = 'assets/images/icons/circular_arrow.png';

class AlertsMapScreen extends StatelessWidget {
  const AlertsMapScreen({super.key});

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

          final isInitialLoading =
              state.requestStatus == RequestStatus.initial ||
              (state.requestStatus == RequestStatus.loading && !hasData);

          if (isInitialLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.requestStatus == RequestStatus.failure && !hasData) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24),
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

                      return _AlertRegionCard(
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

class _AlertRegionCard extends StatelessWidget {
  const _AlertRegionCard({
    required this.region,
    required this.status,
  });

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
