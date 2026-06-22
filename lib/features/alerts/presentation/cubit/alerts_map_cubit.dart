import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukraine_alerts/features/alerts/data/repositories/alerts_repository.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

class AlertsMapCubit extends Cubit<AlertsMapState> {
  AlertsMapCubit(this._alertsRepository)
      : super(const AlertsMapState.initial());

  final AlertsRepository _alertsRepository;

  Future<void> loadActiveAlerts() async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final activeAlerts = await _alertsRepository.getActiveAlerts();

      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          activeAlerts: List.unmodifiable(activeAlerts),
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          activeAlerts: const [],
          errorMessage: 'Не вдалося завантажити активні тривоги',
        ),
      );
    }
  }
}
