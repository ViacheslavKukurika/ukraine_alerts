import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/region_alert_cubit.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/region_alert_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RegionDropdown(
              onSelected: (region) {
                if (region == null) {
                  return;
                }
                context.read<RegionAlertCubit>().selectRegion(region);
              },
            ),
            const SizedBox(height: 24),
            BlocBuilder<RegionAlertCubit, RegionAlertState>(
              builder: (context, state) {
                final selectedRegion = state.selectedRegion;
                return Column(
                  children: [
                    if (selectedRegion != null) ...[
                      Text('Обрано: ${selectedRegion.label}'),
                      const SizedBox(height: 16),
                    ],

                    if (state.requestStatus == RequestStatus.loading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                    ],

                    if (state.requestStatus == RequestStatus.failure) ...[
                      Text(
                        state.errorMessage ?? 'Сталася невідома помилка',
                        textAlign: TextAlign.center,
                      ),
                    ],

                    AlertStatusCard(status: state.airRaidStatus),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
