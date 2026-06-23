import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukraine_alerts/features/alerts/data/repositories/alerts_repository.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

/*
  Цей Cubit керує екраном конкретного регіону. Фабула:

    1) Користувач обрав регіон;
    2) Cubit emit loading;
    3) Repository робить запит;
    4) Якщо успіх — success;
    5) Якщо помилка — failure.
*/

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
          // захист список у State від випадкової зміни (add, clear...):
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
