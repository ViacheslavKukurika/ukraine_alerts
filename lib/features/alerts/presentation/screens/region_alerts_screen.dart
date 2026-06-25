import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/region_alert_cubit.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/region_alert_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/alert_status_card.dart';
import 'package:ukraine_alerts/features/alerts/presentation/widgets/region_dropdown.dart';

const String _refreshIconPath = 'assets/images/icons/circular_arrow.png';

class RegionAlertsScreen extends StatelessWidget {
  const RegionAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionAlertCubit, RegionAlertState>(
      builder: (context, state) {
        final selectedRegion = state.selectedRegion;
        final isLoading = state.requestStatus == RequestStatus.loading;

        final appBarColor = switch (state.airRaidStatus) {
          AirRaidStatus.active => const Color(0xFFC86666),
          AirRaidStatus.inactive => const Color(0xFF66C99A),
          AirRaidStatus.unknown => const Color(0xFFB4DFF8),
          AirRaidStatus.partial => const Color(0xFFFFCA6A),
        };

        final gradientColors = switch (state.airRaidStatus) {
          AirRaidStatus.active => const [
            Color(0xFFA20000),
            Color(0xFFAB0404),
            Color(0xFFD71A1A),
            Color(0xFFFD2D2D),
          ],
          AirRaidStatus.inactive => const [
            Color(0xFF01A558),
            Color(0xFF0AAB59),
            Color(0xFF46D661),
            Color(0xFF77FA67),
          ],
          AirRaidStatus.unknown => const [
            Color(0xFF84CAF2),
            Color(0xFF8BCEF3),
            Color(0xFF9DD5F6),
            Color(0xFFA9DAF7),
          ],
          AirRaidStatus.partial => const [
            Color(0xFFFFF3CD),
            Color(0xFFFFE69C),
            Color(0xFFFFD36A),
            Color(0xFFFFCA6A),
          ],
        };

        final Widget centerContent;

        if (state.requestStatus == RequestStatus.loading) {
          centerContent = const CircularProgressIndicator(
            color: Colors.white,
          );
        } else if (state.requestStatus == RequestStatus.failure) {
          centerContent = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 72,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Сталася невідома помилка',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: selectedRegion == null
                    ? null
                    : () {
                        context.read<RegionAlertCubit>().selectRegion(
                          selectedRegion,
                        );
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E1E1E),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Спробувати ще раз'),
              ),
            ],
          );
        } else if (selectedRegion == null ||
            state.airRaidStatus == AirRaidStatus.unknown) {
          centerContent = Opacity(
            opacity: 0.22,
            child: Image.asset(
              'assets/images/region/city.png',
              width: 320,
              fit: BoxFit.contain,
            ),
          );
        } else {
          centerContent = AlertStatusCard(
            status: state.airRaidStatus,
          );
        }

        return Scaffold(
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
              'Region Alerts',
              style: GoogleFonts.kameron(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E1E1E),
              ),
            ),
            centerTitle: true,
            backgroundColor: appBarColor,
            foregroundColor: const Color(0xFF1E1E1E),
            animateColor: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                tooltip: 'Оновити статус',
                onPressed: selectedRegion == null || isLoading
                    ? null
                    : () {
                        context.read<RegionAlertCubit>().selectRegion(
                          selectedRegion,
                        );
                      },
                icon: const ImageIcon(
                  AssetImage(_refreshIconPath),
                  size: 20,
                ),
              ),
            ],
          ),
          body: AnimatedContainer(
            width: double.infinity,
            height: double.infinity,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    RegionDropdown(
                      enabled: !isLoading,
                      onSelected: (region) {
                        if (region == null) {
                          return;
                        }

                        context.read<RegionAlertCubit>().selectRegion(region);
                      },
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          child: centerContent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
