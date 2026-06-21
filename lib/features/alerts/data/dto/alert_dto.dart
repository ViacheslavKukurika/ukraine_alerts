import 'package:json_annotation/json_annotation.dart';

part 'alert_dto.g.dart';

@JsonSerializable(createToJson: false)
class AlertDto {
  const AlertDto({
    required this.alertType,
    required this.locationUid,
    required this.locationOblastUid,
    required this.locationType,
  });

  factory AlertDto.fromJson(Map<String, dynamic> json) =>
      _$AlertDtoFromJson(json);

  @JsonKey(name: 'alert_type')
  final String? alertType;

  @JsonKey(name: 'location_uid')
  final String? locationUid;

  @JsonKey(name: 'location_oblast_uid')
  final String? locationOblastUid;

  @JsonKey(name: 'location_type')
  final String? locationType;
}
