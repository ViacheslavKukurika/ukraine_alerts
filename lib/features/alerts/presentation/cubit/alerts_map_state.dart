/*-----------------------------------------------------------------------------
  AlertsMapState є "карткою" повного стану екрана карти в певний момент часу.

  Він містить:

   1) requestStatus — стан асинхронного запиту;
   2) regionStatuses — статус повітряної тривоги для кожного регіону;
   3) errorMessage — повідомлення, яке показується після помилки.

  Метод copyWith створює новий екземпляр стану, змінюючи лише передані поля.
Equatable порівнює екземпляри стану за значеннями властивостей, перелічених у
props, а не лише за адресою об'єкта в пам'яті.
-----------------------------------------------------------------------------*/

import 'package:equatable/equatable.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

class AlertsMapState extends Equatable {
  const AlertsMapState({
    required this.requestStatus,
    required this.regionStatuses,
    this.errorMessage,
  });

  const AlertsMapState.initial()
    : requestStatus = RequestStatus.initial,
      regionStatuses = const {},
      errorMessage = null;

  final RequestStatus requestStatus;
  final Map<Region, AirRaidStatus> regionStatuses;
  final String? errorMessage;

  // Метод для отримання статусу тривоги обраного регіону із мапи:

  AirRaidStatus statusFor(Region region) {
    return regionStatuses[region] ?? AirRaidStatus.unknown;
  }

  AlertsMapState copyWith({
    RequestStatus? requestStatus,
    Map<Region, AirRaidStatus>? regionStatuses,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AlertsMapState(
      requestStatus: requestStatus ?? this.requestStatus,
      regionStatuses: regionStatuses ?? this.regionStatuses,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    requestStatus,
    regionStatuses,
    errorMessage,
  ];
}
