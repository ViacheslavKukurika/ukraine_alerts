/* 
  У цьому файлі немає секретних даних, однак у нас тут є спосіб отримати
секретні дані (токен):
  secrets.json → --dart-define-from-file → String.fromEnvironment →
→ AppConfig.alertsApiToken
  Основна логіка: токен не записаний напряму у код й не потрапляє у Git.
  Також тут для зручності базова URL-а записана у змінну, щоб було зручніше
  користуватися (як named-шляхи у GoRouter). 
*/

abstract final class AppConfig {
  static const String alertsApiBaseUrl = 'https://api.alerts.in.ua';
  static const String  alertsApiToken = String.fromEnvironment(
    'ALERTS_API_TOKEN');
  static bool get hasAlertsApiToken => alertsApiToken.isNotEmpty;
}
