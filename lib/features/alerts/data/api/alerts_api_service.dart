
/*-----------------------------------------------------------------------------
    AlertsApiService є найнижчим рівнем data-шару, який безпосередньо взаємодіє
  із сервером "alerts.in.ua" через налаштований Dio-клієнт.

    Клас виконує два види HTTP-запитів:

    1) отримання статусу повітряної тривоги для одного регіону за його uid;
    2) отримання списку статусів усіх областей для побудови карти.

    Обидва endpoint повертають JSON-рядки, а не складні JSON-об'єкти. Тому Dio
  налаштовується на ResponseType.plain і спочатку повертає звичайний текст.
  Наприклад, у response.data може міститися текст`"A"` разом із JSON-лапками.
  Функція jsonDecode прибирає JSON-обгортку та перетворює його на Dart-рядок
  `A`.

    Цей клас перевіряє лише формат відповіді та повертає сирі рядки. Він не
  визначає, що означають "A", "P" або "N". Інтерпретація отриманих значень є
  відповідальністю AlertsRepository. 

  ******************************************************************************

  Трішки про endpoint і чому він не зовсім такий, як було вказано у завданні:
Спочатку для екрана карти я використовував endpoint: "`/v1/alerts/active.json`",
який був зазначений у завданні. Він повертає список структурованих об’єктів
активних тривог, тому для нього були створені DTO, Entity та mapper.

  Однак коли я вже все підключив і відкрив на смартфоні мапу тривог, то побачив,
що кількість областей, які підсвічено червоним кольором значно менша, ніж на 
сайті: https://alerts.in.ua/ у цей же момент часу. На сайті https://devs.alerts.in.ua/
я знайшов спеціалізований ендпойнт "/v1/iot/active_air_raid_alerts_by_oblast.json". Він
напряму повертає статуси повітряної тривоги за областями. Завдяки цьому
Repository може одразу сформувати Map<Region, AirRaidStatus>, а застосунку не
потрібно додатково фільтрувати список різних тривог і визначати, до яких
областей вони належать.

  Для статусу одного регіону використовується endpoint:
  "/v1/iot/active_air_raid_alerts/{uid}.json". Після переходу на ці endpoint
старі DTO більше не відповідали фактичному формату даних. Створювати окремий
DTO для одного рядка A, P або N було б зайвим ускладненням. Тому я видалив старі
DTO, згенеровані ".g.dart", mapper та залежності кодогенерації. При цьому
архітектурне розділення залишилося:

  AlertsApiService виконує HTTP-запит і повертає сирі дані, AlertsRepository
перетворює їх на AirRaidStatus або Map<Region, AirRaidStatus>, Cubit керує
станами завантаження, успіху та помилки, а UI лише відображає готовий стан.
-----------------------------------------------------------------------------*/

import 'dart:convert';
import 'package:dio/dio.dart';

class AlertsApiService {
  AlertsApiService(this._dio);

  final Dio _dio;

  Future<String> getRegionAirRaidStatus(int uid) async {
    final response = await _dio.get<String>(
      '/v1/iot/active_air_raid_alerts/$uid.json',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );

    final rawBody = response.data ?? '';
    final decodeBody = jsonDecode(rawBody);

    if (decodeBody is! String) {
      throw const FormatException(
        'Unexpected region alert response format',
      );
    }
    return decodeBody;
  }

  Future<String> getAirRaidStatusesByOblast() async {
    final response = await _dio.get<String>(
      '/v1/iot/active_air_raid_alerts_by_oblast.json',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );

    final rawBody = response.data ?? '';
    final decodedBody = jsonDecode(rawBody);

    if (decodedBody is! String) {
      throw const FormatException(
        'Unexpected oblast alert statuses response format',
      );
    }

    return decodedBody;
  }
}
