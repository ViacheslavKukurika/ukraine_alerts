import 'package:ukraine_alerts/features/alerts/data/dto/alert_dto.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/active_alert.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

ActiveAlert? mapAlertDtoToEntity(AlertDto dto) {
  if (dto.alertType?.trim().toLowerCase() != 'air_raid') {
    return null;
  }

  final locationOblastUid = dto.locationOblastUid?.trim();
  final locationType = dto.locationType?.trim().toLowerCase();

  final rawRegionUid = locationOblastUid != null && locationOblastUid.isNotEmpty
      ? locationOblastUid
      : locationType == 'oblast'
      ? dto.locationUid?.trim()
      : null;

  final regionUid = int.tryParse(rawRegionUid ?? '');

  if (regionUid == null) {
    return null;
  }

  for (final region in Region.values) {
    if (region.uid == regionUid) {
      return ActiveAlert(region: region);
    }
  }

  return null;
}
