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
