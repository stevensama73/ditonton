import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'airing_today_tv_event.dart';
part 'airing_today_tv_state.dart';

class AiringTodayTvBloc extends Bloc<AiringTodayTvEvent, AiringTodayTvState> {
  final GetAiringTodayTv _airingTodayTv;

  AiringTodayTvBloc(this._airingTodayTv) : super(AiringTodayTvEmpty()) {
    on<OnAiringTodayTv>((event, emit) async {
      emit(AiringTodayTvLoading());
      final result = await _airingTodayTv.execute();

      result.fold(
        (failure) {
          emit(AiringTodayTvError(failure.message));
        },
        (data) {
          emit(AiringTodayTvHasData(data));
        },
      );
    });
  }
}
