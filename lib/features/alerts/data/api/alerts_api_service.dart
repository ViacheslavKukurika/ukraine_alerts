import 'package:dio/dio.dart';

class AlertsApiService {
  AlertsApiService(this._dio);

  final Dio _dio;

  Future<String> getRegionAirRaidStatus(int uid) async {
    final response = await _dio.get<String>(
      '/v1/iot/active_air_raid_alerts/$uid.json',
    );
    return response.data ?? '';
  }
}
