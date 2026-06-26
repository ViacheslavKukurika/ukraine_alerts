
/*-----------------------------------------------------------------------------
    У цьому файлі централізовано зберігаються шляхи та імена маршрутів
  застосунку.

    AppRoutesPaths містить фактичні URL-подібні шляхи, які використовує
  GoRouter. AppRoutesNames містить логічні імена маршрутів, які використовуються
  під час named-навігації через context.pushNamed().

    Винесення маршрутів у константи зменшує ризик друкарських помилок та 
  пришвидшує написання коду, який пов'язаний із навігацією.
-----------------------------------------------------------------------------*/

abstract final class AppRoutesPaths {
  static const String home = '/';
  static const String alertsMap = '/alerts-map';
  static const String regionAlerts = '/region-alerts';
}

abstract final class AppRoutesNames {
  static const String home = 'home';
  static const String alertsMap = 'alertsMap';
  static const String regionAlerts = 'regionAlerts';
}
