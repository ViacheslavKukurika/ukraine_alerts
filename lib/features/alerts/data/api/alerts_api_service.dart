/*-------------------------------------------------------------------
  Це посередник між застосунком і сервером. Його задача:
  Зробити конкретний HTTP-запит і повернути результат (сирий).
-------------------------------------------------------------------*/

import 'dart:convert';
import 'package:dio/dio.dart';

class AlertsApiService {
  AlertsApiService(this._dio);

  final Dio _dio;

  /*-------------------------------------------------------------------
    Метод "getRegionAirRaidStatus" повертає нам статус одного, обраного нами
  конкретного регіону. Згідно документації, API повертає нам JSON-рядок типу:
    - "N" (немає тривоги);
    або
    - "A" (активна повітряна тривога);
    або
    - "P" (часткова тривога);
  
    Далі ми просимо Dio повернути сирий текст (без цієї команди у мене були 
  проблеми):
    responseType: ResponseType.plain;
  Потім jsonDecode(rawBody) перетворює JSON-текст у Dart-рядок. Типу:

    "N" => N. 
  -------------------------------------------------------------------*/

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

  /*-------------------------------------------------------------------
  Метод getActiveAlerts повертає нам список усіх активних тривог. Тут API
повертає нам вже не рядок, а цілий JSON-об'єкт. Змінна "response" — має тип 
"Map<String, dynamic>", тобто Dio підкапотно автоматично перетворює JSON у
Mapу. 
-------------------------------------------------------------------*/

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
