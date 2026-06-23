import 'package:equatable/equatable.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

/*
  State повна інформаційна картка екрану у певний момент часу. Це як змінна, яку
 контролює і прокидує вниз inherited-widget, але це не просто змінна, а повно-
 цінний об'єкт класу.

    Equatable дозволяє порівнювати State за значеннями полів, а не за адресою
  об’єкта.
*/

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

  
   // Геттер. Якщо значення змінилося, то Cubit розуміє, що UI треба оновити.
  

  @override
  List<Object?> get props => [
    selectedRegion,
    requestStatus,
    airRaidStatus,
    errorMessage,
  ];
}
