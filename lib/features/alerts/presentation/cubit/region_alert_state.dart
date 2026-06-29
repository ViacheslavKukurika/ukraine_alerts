/*-----------------------------------------------------------------------------
  RegionAlertState описує повний стан екрана конкретного регіону.

   У ньому зберігаються:
    1) вибраний користувачем Region;
    2) поточний стан HTTP-запиту;
    3) отриманий AirRaidStatus;
    4) необов'язкове повідомлення про помилку.

  Cubit не змінює поточний State напряму, а створює новий через copyWith і 
передає його методом emit(). Equatable використовує props, щоб порівнювати стани
за значеннями їхніх полів.
-----------------------------------------------------------------------------*/

import 'package:equatable/equatable.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

class RegionAlertState extends Equatable {
  const RegionAlertState({
    required this.requestStatus,
    required this.airRaidStatus,
    this.selectedRegion,
    this.errorMessage,
  });

  const RegionAlertState.initial()
    : selectedRegion = null,
      requestStatus = RequestStatus.initial,
      airRaidStatus = AirRaidStatus.unknown,
      errorMessage = null;

  final Region? selectedRegion;
  final RequestStatus requestStatus;
  final AirRaidStatus airRaidStatus;
  final String? errorMessage;

  bool get hasSelectedRegion => selectedRegion != null;

  RegionAlertState copyWith({
    Region? selectedRegion,
    RequestStatus? requestStatus,
    AirRaidStatus? airRaidStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RegionAlertState(
      selectedRegion: selectedRegion ?? this.selectedRegion,
      requestStatus: requestStatus ?? this.requestStatus,
      airRaidStatus: airRaidStatus ?? this.airRaidStatus,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedRegion,
    requestStatus,
    airRaidStatus,
    errorMessage,
  ];
}
