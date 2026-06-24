import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukraine_alerts/features/alerts/data/repositories/alerts_repository.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/alerts_map_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

class AlertsMapCubit extends Cubit<AlertsMapState> {
  AlertsMapCubit(this._alertsRepository)
    : super(const AlertsMapState.initial());

  final AlertsRepository _alertsRepository;
  Timer? _refreshTimer;

  Future<void> loadAirRaidStatuses() async {
    if (state.requestStatus == RequestStatus.loading) {
      return;
    }
    
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final regionStatuses = await _alertsRepository
          .getAirRaidStatusesByOblast();

      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          regionStatuses: Map.unmodifiable(regionStatuses),
          clearErrorMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('loadAirRaidStatuses failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: 'Не вдалося завантажити карту тривог',
        ),
      );
    }
  }

  void startAutoRefresh() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        loadAirRaidStatuses();
      },
    );
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
