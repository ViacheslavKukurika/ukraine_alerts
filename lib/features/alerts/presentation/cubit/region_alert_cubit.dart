/*-----------------------------------------------------------------------------
  RegionAlertCubit керує вибором одного регіону та завантаженням його  поточного
статусу повітряної тривоги.

  Після вибору регіону Cubit спочатку emit-ить loading-стан, а потім передає
його uid у Repository. Отримана відповідь перетворюється на AirRaidStatus і 
записується у новий RegionAlertState.

  Якщо запит завершується помилкою, Cubit переходить у failure-стан і передає UI
зрозуміле повідомлення. Перевірка requestStatus захищає стан від одночасного
запуску кількох запитів та конфлікту їхніх результатів.
-----------------------------------------------------------------------------*/

import 'package:ukraine_alerts/core/cubit/safe_cubit.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';
import 'package:ukraine_alerts/features/alerts/data/repositories/alerts_repository.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/region_alert_state.dart';
import 'package:ukraine_alerts/features/alerts/presentation/models/request_status.dart';

class RegionAlertCubit extends  SafeCubit<RegionAlertState> {
  RegionAlertCubit(this._alertsRepository)
    : super(const RegionAlertState.initial());

  final AlertsRepository _alertsRepository;

  Future<void> selectRegion(Region region) async {
    // Не запускаємо новий запит, доки не завершився попередній:
    if (state.requestStatus == RequestStatus.loading) {
      return;
    }
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

      safeEmit(
        state.copyWith(
          selectedRegion: region,
          requestStatus: RequestStatus.success,
          airRaidStatus: airRaidStatus,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      safeEmit(
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
