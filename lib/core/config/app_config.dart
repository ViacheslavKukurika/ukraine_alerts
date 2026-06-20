abstract final class AppConfig {
  static const String alertsApiBaseUrl = 'https://api.alerts.in.ua';
  static const String  alertsApiToken = String.fromEnvironment(
    'ALERTS_API_TOKEN');
  static bool get hasAlertsApiToken => alertsApiToken.isNotEmpty;
}
