import 'package:equatable/equatable.dart';
import 'package:ukraine_alerts/features/alerts/data/models/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/models/region.dart';
import 'package:ukraine_alerts/features/alerts/data/models/request_status.dart';

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

  @override
  List<Object?> get props => [
    selectedRegion,
    requestStatus,
    airRaidStatus,
    errorMessage,
  ];
}
