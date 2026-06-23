import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_cubit.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

class AlertsMapScreen extends StatelessWidget {
  const AlertsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта тривог'),
      ),
      body: BlocBuilder<AlertsMapCubit, AlertsMapState>(
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.initial ||
              state.requestStatus == RequestStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.requestStatus == RequestStatus.failure) {
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
                        context.read<AlertsMapCubit>().loadActiveAlerts();
                      },
                      child: const Text('Спробувати ще раз'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state.activeAlerts.isEmpty) {
            return const Center(
              child: Text(
                'Активних повітряних тривог немає',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.activeAlerts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final activeAlert = state.activeAlerts[index];

              return ListTile(
                leading: const Icon(
                  Icons.warning_amber_rounded,
                ),
                title: Text(activeAlert.region.label),
                subtitle: const Text(
                  'Активна повітряна тривога',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
