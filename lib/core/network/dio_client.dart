/*-----------------------------------------------------------------------------
  DioClient створює та повертає попередньо налаштований HTTP-клієнт Dio.

  Тут централізовано визначаються:
  - базова адреса Alerts API;
  - максимальний час встановлення з'єднання;
  - максимальний час очікування відповіді;
  - бажаний формат відповіді;
  - заголовок авторизації з API-токеном.

  Завдяки цьому API-методи не повинні щоразу повторювати однакові налаштування.
Вони отримують готовий Dio-клієнт і вказують лише шлях конкретного endpoint та
параметри запиту.
-----------------------------------------------------------------------------*/

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
