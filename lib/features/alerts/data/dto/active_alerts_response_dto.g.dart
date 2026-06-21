// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_alerts_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveAlertsResponseDto _$ActiveAlertsResponseDtoFromJson(
  Map<String, dynamic> json,
) => ActiveAlertsResponseDto(
  alerts: (json['alerts'] as List<dynamic>?)
      ?.map((e) => AlertDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);
