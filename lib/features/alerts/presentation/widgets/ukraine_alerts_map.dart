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
    return InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              _baseMapPath,
              fit: BoxFit.contain,
            ),

            for (final region in Region.values)
              Positioned.fill(
                key: ValueKey(region),
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _opacityFor(
                      regionStatuses[region] ?? AirRaidStatus.unknown,
                    ),
                    duration: const Duration(
                      milliseconds: 350,
                    ),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      region.overlayAssetPath,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      errorBuilder:
                          (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const SizedBox.shrink();
                          },
                    ),
                  ),
                ),
              ),
          ],
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
