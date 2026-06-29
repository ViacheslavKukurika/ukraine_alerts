//Базовий Cubit, який запобігає emit-у станів після закриття Cubit

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SafeCubit<State> extends Cubit<State> {
  SafeCubit(super.initialState);

  void safeEmit(State newState) {
    if (isClosed) {
      return;
    }

    emit(newState);
  }
}
