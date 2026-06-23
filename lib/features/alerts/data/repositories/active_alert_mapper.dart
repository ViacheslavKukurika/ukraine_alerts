/*...................................................................
  Mapper перетворює AlertDto, створений із JSON-даних,
у внутрішню Entity ActiveAlert.

  Repository використовує цей mapper для підготовки даних,
які потім передає Cubit.
...................................................................*/

import 'package:ukraine_alerts/features/alerts/data/dto/alert_dto.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/active_alert.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

// ActiveAlert? = не кожен DTO зможе стати Entity

ActiveAlert? mapAlertDtoToEntity(AlertDto dto) {

  // фільтрація тривог: нам потрібні лише air_raid

  if (dto.alertType?.trim().toLowerCase() != 'air_raid') {
    return null;
  }

  // нормалізуємо тип String для безпеки:

  final locationType = dto.locationType?.trim().toLowerCase();
  int? regionUid;

  /*...................................................................
   Для карти нам потрібен UID області.

  1) якщо API надало locationOblastUid, використовуємо його;
  2) якщо locationOblastUid відсутній, але сама локація є областю,
    використовуємо locationUid;
  3) якщо запис стосується міста або району, але UID області відсутній,
    не намагаємося вгадувати область і повертаємо null.
  ...................................................................*/

  if (dto.locationOblastUid != null) {
    regionUid = dto.locationOblastUid;
  } else if (locationType == 'oblast') {
    regionUid = dto.locationUid;
  } else {
    return null;
  }

  if (regionUid == null) {
    return null;
  }  

  /*...................................................................
   Шукаємо в enum Region область, UID якої збігається
  з UID, отриманим від API.
  ...................................................................*/

  for (final region in Region.values) {
    if (region.uid == regionUid) {
      return ActiveAlert(region: region);
    }
  }

  // Якщо API повернуло UID, якого немає у нашому Region-enum
  return null;
}
