/*
  DioClient створює один налаштований HTTP-клієнт. Він вирішує наступні питання:
    1) куди робити запит?;
    2) скільки чекати?;
    3) який формат даних просимо повернути сервер?;
    4) як авторизуватися?.
  Це модульний елемент, який дозволяє в кожному API-методі не повторювати
  базову адресу timeout і токен.
*/

import 'package:dio/dio.dart';
import 'package:ukraine_alerts/core/config/app_config.dart';

abstract final class DioClient {
  static Dio create() {
    final options = BaseOptions(
      baseUrl: AppConfig.alertsApiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        if (AppConfig.hasAlertsApiToken)
          'Authorization': 'Bearer ${AppConfig.alertsApiToken}',
      },
    );

    return Dio(options);
  }
}
