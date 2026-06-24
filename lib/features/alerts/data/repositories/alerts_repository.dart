/*-------------------------------------------------------------------
  Репозиторій організовує послідовність:
  
  1) API service (запит до бекенду);
  2) DTO;
  3) mapper;
  4) Entity;
-------------------------------------------------------------------*/

import 'package:ukraine_alerts/features/alerts/data/api/alerts_api_service.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/active_alert.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/data/repositories/active_alert_mapper.dart';

class AlertsRepository {
  AlertsRepository(this._apiService);

  final AlertsApiService _apiService;
  static const List<Region> _regionsByApiOrder = [
    Region.crimea,
    Region.volyn,
    Region.vinnytsia,
    Region.dnipropetrovsk,
    Region.donetsk,
    Region.zhytomyr,
    Region.zakarpattia,
    Region.zaporizhzhia,
    Region.ivanoFrankivsk,
    Region.kyivCity,
    Region.kyivRegion,
    Region.kirovohrad,
    Region.luhansk,
    Region.lviv,
    Region.mykolaiv,
    Region.odesa,
    Region.poltava,
    Region.rivne,
    Region.sevastopol,
    Region.sumy,
    Region.ternopil,
    Region.kharkiv,
    Region.kherson,
    Region.khmelnytskyi,
    Region.cherkasy,
    Region.chernivtsi,
    Region.chernihiv,
  ];

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

    /*-------------------------------------------------------------------
      Використовуємо Set, бо може бути, наприклад, що API поверне декілька 
     активних тривог в межах області: район, місто, область. В такому випадку
     кожен запис може перетворитися на Region.sumy. Set же зберігає
     лише унікальні значення, автоматично видаляючи дублікати.
    -------------------------------------------------------------------*/

    final activeRegions = <Region>{};

    for (final alertDto in alertDtos) {
      final activeAlert = mapAlertDtoToEntity(alertDto);

      if (activeAlert != null) {
        activeRegions.add(activeAlert.region);
      }
    }

    return activeRegions.map((region) => ActiveAlert(region: region)).toList();
  }

  Future<Map<Region, AirRaidStatus>> getAirRaidStatusesByOblast() async {
    final rawStatuses = await _apiService.getAirRaidStatusesByOblast();

    final normalizedStatuses = rawStatuses.trim().toUpperCase();

    if (normalizedStatuses.length != _regionsByApiOrder.length) {
      throw FormatException(
        'Unexpected number of oblast statuses: '
        '${normalizedStatuses.length}',
      );
    }

    final statuses = <Region, AirRaidStatus>{};

    for (var index = 0; index < _regionsByApiOrder.length; index++) {
      final region = _regionsByApiOrder[index];
      final rawStatus = normalizedStatuses[index];

      final status = switch (rawStatus) {
        'A' => AirRaidStatus.active,
        'P' => AirRaidStatus.partial,
        'N' => AirRaidStatus.inactive,
        _ => AirRaidStatus.unknown,
      };

      statuses[region] = status;
    }

    return Map.unmodifiable(statuses);
  }
}
