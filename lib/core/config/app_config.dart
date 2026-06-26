
/*-----------------------------------------------------------------------------
    AppConfig зберігає глобальні параметри, необхідні для роботи з API:
  базову адресу сервера та API-токен.

  Токен не записується безпосередньо у Dart-код. Під час запуску значення
  передається з secrets.json через параметр "--dart-define-from-file",   після
  чого читається за допомогою "String.fromEnvironment".

    Ланцюг отримання токена:
  secrets.json → --dart-define-from-file → String.fromEnvironment → 
    → AppConfig.alertsApiToken.

    Властивість "hasAlertsApiToken" дозволяє перевірити, чи було передано
  непорожнє значення токена перед створенням заголовка авторизації.
-----------------------------------------------------------------------------*/

abstract final class AppConfig {
  static const String alertsApiBaseUrl = 'https://api.alerts.in.ua';
  static const String alertsApiToken = String.fromEnvironment(
    'ALERTS_API_TOKEN',
  );
  static bool get hasAlertsApiToken => alertsApiToken.isNotEmpty;
}
