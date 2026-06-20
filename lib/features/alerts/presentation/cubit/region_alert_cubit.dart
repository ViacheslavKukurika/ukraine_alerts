import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukraine_alerts/features/alerts/data/models/air_raid_status.dart';
import 'package:ukraine_alerts/features/alerts/data/models/region.dart';
import 'package:ukraine_alerts/features/alerts/data/models/request_status.dart';
import 'package:ukraine_alerts/features/alerts/presentation/cubit/region_alert_state.dart';

class RegionAlertCubit extends Cubit<RegionAlertState> {
  RegionAlertCubit() : super(const RegionAlertState.initial());

  Future<void> selectRegion(Region region) async {
    emit(
      state.copyWith(
        selectedRegion: region,
        requestStatus: RequestStatus.loading,
        airRaidStatus: AirRaidStatus.unknown,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 700));

    final mockStatus = switch (region.uid % 3) {
      0 => AirRaidStatus.active,
      1 => AirRaidStatus.partial,
      _ => AirRaidStatus.inactive,
    };

    emit(
      state.copyWith(
        selectedRegion: region,
        requestStatus: RequestStatus.success,
        airRaidStatus: mockStatus,
      ),
    );
  }
}
