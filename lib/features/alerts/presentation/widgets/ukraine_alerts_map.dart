import 'package:flutter/material.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/region_overlay_asset.dart';

class UkraineAlertsMap extends StatelessWidget {
  const UkraineAlertsMap({
    required this.regionStatuses,
    super.key,
  });

  static const String _baseMapPath = 'assets/images/map/ukraine_map.png';

  final Map<Region, AirRaidStatus> regionStatuses;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                _baseMapPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint(
                    'Base map load failed: $_baseMapPath\n$error',
                  );

                  return const Center(
                    child: Text(
                      'Не вдалося завантажити карту',
                    ),
                  );
                },
              ),

              for (final entry in regionStatuses.entries)
                if (entry.value == AirRaidStatus.active ||
                    entry.value == AirRaidStatus.partial)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        key: ValueKey(entry.key),
                        opacity: _opacityFor(entry.value),
                        duration: const Duration(
                          milliseconds: 350,
                        ),
                        curve: Curves.easeInOut,
                        child: Image.asset(
                          entry.key.overlayAssetPath,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                          errorBuilder:
                              (
                                context,
                                error,
                                stackTrace,
                              ) {
                                debugPrint(
                                  'Overlay load failed: '
                                  '${entry.key.overlayAssetPath}\n$error',
                                );

                                return const SizedBox.shrink();
                              },
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  double _opacityFor(AirRaidStatus status) {
    return switch (status) {
      AirRaidStatus.active => 1,
      AirRaidStatus.partial => 0.55,
      AirRaidStatus.inactive => 0,
      AirRaidStatus.unknown => 0,
    };
  }
}
