import 'package:ukraine_alerts/features/alerts/data/api/alerts_api_service.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/active_alert.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/data/repositories/active_alert_mapper.dart';

class AlertsRepository {
  AlertsRepository(this._apiService);

  final AlertsApiService _apiService;

  Future<AirRaidStatus> getRegionAirRaidStatus(int uid) async {
    final rawStatus = await _apiService.getRegionAirRaidStatus(uid);
    final normalizedStatus = rawStatus.trim().toUpperCase();
    return switch (normalizedStatus) {
      'A' => AirRaidStatus.active,
      'P' => AirRaidStatus.partial,
      'N' => AirRaidStatus.inactive,
      _ => AirRaidStatus.unknown,
    };
  }

  Future<List<ActiveAlert>> getActiveAlerts() async {
    final responseDto = await _apiService.getActiveAlerts();
    final alertDtos = responseDto.alerts ?? [];

    final activeRegions = <Region>{};

    for (final alertDto in alertDtos) {
      final activeAlert = mapAlertDtoToEntity(alertDto);

      if (activeAlert != null) {
        activeRegions.add(activeAlert.region);
      }
    }

    return activeRegions.map((region) => ActiveAlert(region: region)).toList();
  }
}
