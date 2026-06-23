/*
  Така сутність, як репозиторій потрібна нам для конвертації: DTO => Entity.
Функція "mapAlertDtoToEntity" перетворює об'єкт типу DTO (що є нащадком JSON) у
об'єкт Entity. 
*/

import 'package:ukraine_alerts/features/alerts/data/dto/alert_dto.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/active_alert.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

// ActiveAlert? = не кожен DTO зможе стати Entity

ActiveAlert? mapAlertDtoToEntity(AlertDto dto) {

  // фільтрація тривог: нам потрібні лише air_raid
  // trim (видаляє пробіли) + toLowerCase = нормалізація рядка

  if (dto.alertType?.trim().toLowerCase() != 'air_raid') {
    return null;
  }

  final locationOblastUid = dto.locationOblastUid?.trim();
  final locationType = dto.locationType?.trim().toLowerCase();

  /* Для підсвічування карти нам потрібна інформація про область
 (dto.locationOblastUid). Однак у нас є і запасний варіант, але лише при 
 умові: locationType == 'oblast'. Якщо запис описує район, але інформація про
 область відсутня, ми повертаємо null.
  */

  final rawRegionUid = locationOblastUid != null && locationOblastUid.isNotEmpty
      ? locationOblastUid
      : locationType == 'oblast'
      ? dto.locationUid?.trim()
      : null;

  // нам приходить String, тому треба конвертація в int:

  final regionUid = int.tryParse(rawRegionUid ?? '');

  if (regionUid == null) {
    return null;
  }

  /*
   Цикл використаний для пошуку співпадіння, тобто виявлення району, де є 
  активна тривога
  */

  for (final region in Region.values) {
    if (region.uid == regionUid) {
      return ActiveAlert(region: region);
    }
  }

  return null;
}
