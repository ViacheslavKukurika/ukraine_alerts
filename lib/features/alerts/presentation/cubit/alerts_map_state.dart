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
