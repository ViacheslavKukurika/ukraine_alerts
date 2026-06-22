import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ukraine_alerts/features/alerts/data/dto/active_alerts_response_dto.dart';

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

  Future<ActiveAlertsResponseDto> getActiveAlerts() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/v1/alerts/active.json',
    );

    final data = response.data;

    if (data == null) {
      throw const FormatException(
        'Active alerts response is empty',
      );
    }
    return ActiveAlertsResponseDto.fromJson(data);
  }
}
