// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertDto _$AlertDtoFromJson(Map<String, dynamic> json) => AlertDto(
  alertType: json['alert_type'] as String?,
  locationUid: _uidFromJson(json['location_uid']),
  locationOblastUid: _uidFromJson(json['location_oblast_uid']),
  locationType: json['location_type'] as String?,
);
