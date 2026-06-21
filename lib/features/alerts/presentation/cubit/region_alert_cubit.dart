import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/data/repositories/alerts_repository.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/region_alert_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

class RegionAlertCubit extends Cubit<RegionAlertState> {
  RegionAlertCubit(this._alertsRepository)
    : super(const RegionAlertState.initial());

  final AlertsRepository _alertsRepository;

  Future<void> selectRegion(Region region) async {
    emit(
      state.copyWith(
        selectedRegion: region,
        requestStatus: RequestStatus.loading,
        airRaidStatus: AirRaidStatus.unknown,
        clearErrorMessage: true,
      ),
    );

    try {
      final airRaidStatus = await _alertsRepository.getRegionAirRaidStatus(
        region.uid,
      );

      emit(
        state.copyWith(
          selectedRegion: region,
          requestStatus: RequestStatus.success,
          airRaidStatus: airRaidStatus,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          selectedRegion: region,
          requestStatus: RequestStatus.failure,
          airRaidStatus: AirRaidStatus.unknown,
          errorMessage: 'Не вдалося отримати статус тривоги',
        ),
      );
    }
  }
}
