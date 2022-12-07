import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _topRatedTv;

  TopRatedTvBloc(this._topRatedTv) : super(TopRatedTvEmpty()) {
    on<OnTopRatedTv>((event, emit) async {
      emit(TopRatedTvLoading());
      final result = await _topRatedTv.execute();

      result.fold(
        (failure) {
          emit(TopRatedTvError(failure.message));
        },
        (data) {
          emit(TopRatedTvHasData(data));
        },
      );
    });
  }
}
