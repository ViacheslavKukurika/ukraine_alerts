/*
  Клас (його об'єкт) ActiveAlertsResponseDto являє собою увесь зовнішній об'єкт
DTO. Він приймає у себе список об'єктів іншого класу — AlertDto (одна з основ
ООП — композиція).
*/

import 'package:json_annotation/json_annotation.dart';
import 'package:ukraine_alerts/features/alerts/data/dto/alert_dto.dart';

part 'active_alerts_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ActiveAlertsResponseDto {
  const ActiveAlertsResponseDto({
    required this.alerts,
  });

  factory ActiveAlertsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ActiveAlertsResponseDtoFromJson(json);

  final List<AlertDto>? alerts;
}
