import 'package:equatable/equatable.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/active_alert.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

class AlertsMapState extends Equatable {
  const AlertsMapState({
    required this.requestStatus,
    required this.activeAlerts,
    this.errorMessage,
  });

  const AlertsMapState.initial()
    : requestStatus = RequestStatus.initial,
      activeAlerts = const [],
      errorMessage = null;

  final RequestStatus requestStatus;
  final List<ActiveAlert> activeAlerts;
  final String? errorMessage;

  Set<Region> get activeRegions =>
      activeAlerts.map((alert) => alert.region).toSet();

  AlertsMapState copyWith({
    RequestStatus? requestStatus,
    List<ActiveAlert>? activeAlerts,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AlertsMapState(
      requestStatus: requestStatus ?? this.requestStatus,
      activeAlerts: activeAlerts ?? this.activeAlerts,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    requestStatus,
    activeAlerts,
    errorMessage,
  ];
}
