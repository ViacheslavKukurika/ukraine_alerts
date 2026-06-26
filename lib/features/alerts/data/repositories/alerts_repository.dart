/*-----------------------------------------------------------------------------
    AlertsRepository є посередником між AlertsApiService та рештою застосунку.
  Він отримує сирі рядки API й перетворює їх на типізовані моделі, зрозумілі для
  Cubit та UI.

      Для одного регіону Repository нормалізує отриманий рядок і зіставляє:

    A → AirRaidStatus.active;
    P → AirRaidStatus.partial;
    N → AirRaidStatus.inactive;
    невідоме значення → AirRaidStatus.unknown.

    Endpoint карти повертає один рядок, у якому позиція кожного символу
  відповідає певному регіону. Список _regionsByApiOrder зберігає регіони саме в
  порядку, визначеному API. 

    Перед побудовою карти Repository перевіряє кількість отриманих символів.
  Після цього кожний символ перетворюється на AirRaidStatus, а результат повер-
  -тається як незмінна Map<Region, AirRaidStatus>.
-----------------------------------------------------------------------------*/

import 'package:ukraine_alerts/features/alerts/data/api/alerts_api_service.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

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
    // Видалити пробіли + зробити великі літери
    final normalizedStatus = rawStatus.trim().toUpperCase();
    return switch (normalizedStatus) {
      'A' => AirRaidStatus.active,
      'P' => AirRaidStatus.partial,
      'N' => AirRaidStatus.inactive,
      _ => AirRaidStatus.unknown,
    };
  }

  Future<Map<Region, AirRaidStatus>> getAirRaidStatusesByOblast() async {
    // Отримуємо сирий рядок від сервера (типу: NANPNNN...):
    final rawStatuses = await _apiService.getAirRaidStatusesByOblast();
    // Нормалізуємо рядок, якщо щось не так піде на бекенді:
    final normalizedStatuses = rawStatuses.trim().toUpperCase();

    // Безпека: перевірка правильності (цілісності) відповіді від сервера
    if (normalizedStatuses.length != _regionsByApiOrder.length) {
      throw FormatException(
        'Unexpected number of oblast statuses: '
        '${normalizedStatuses.length}',
      );
    }

    // створення порожньої мапи, яка скоро стане вже Entity:
    final statuses = <Region, AirRaidStatus>{};

    // Цикл проходить через усі індекси списку регіонів і напвонює мапу:
    for (var index = 0; index < _regionsByApiOrder.length; index++) {
      // На кожній ітерації один і той самий index використовується двічі:
      final region = _regionsByApiOrder[index];

      // Із рядка API береться символ на тій самій позиції, що і елемент у
      // списку регіонів (рядок 92). Тут важлива відповідність:
      final rawStatus = normalizedStatuses[index];

      final status = switch (rawStatus) {
        'A' => AirRaidStatus.active,
        'P' => AirRaidStatus.partial,
        'N' => AirRaidStatus.inactive,
        _ => AirRaidStatus.unknown,
      };

      statuses[region] = status;
    }

    // Безпека: для незмінності мапи:
    return Map.unmodifiable(statuses);
  }
}
