/*
  DTO - це проміжний формат між сирим JSON-об'єктом з однієї сторони, та 
повноцінною Entity-моделлю, яку використовує наш клієжнтський застосункок,
з іншої сторони. DTO зберігає значення майже такими, як вони прийшли. Тобто DTO
 — це вже клас, тобто більш високорівнева структура.

  Об'єкти класу AlertDto — це вкладені об'єкти (щось типу структурно-
-функціональних одиниць), які будуть міститися в загальному, головному класі —
— "ActiveAlertsResponseDto". Вони там будуть представлені як множина, тобто
елементи списку.

  Якщо у сервіс "dart-quicktype" скопіювати приклад JSON-у, який дає сервер, то
там міститься забагато полів, які не потрібні нам для Entity (як я розумію, нам
просто не потрібні ці поля взагалі). Тож у цьому файлі використовуються ті
поля, які нам потрібні за умовою задачі. 
*/

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

/*
  Згенеровані файли (alert_dto.g.dart та active_alerts_response_dto.dart) — це
автоматично згенеровані за допомогою JsonSerializable файли, які пишуть замість
нас код, який дістає значення з Mapи, приводить його до типу й передає в 
конструктор DTO-класу.
*/
