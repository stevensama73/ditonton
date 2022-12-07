import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _popularTv;

  PopularTvBloc(this._popularTv) : super(PopularTvEmpty()) {
    on<OnPopularTv>((event, emit) async {
      emit(PopularTvLoading());
      final result = await _popularTv.execute();

      result.fold(
        (failure) {
          emit(PopularTvError(failure.message));
        },
        (data) {
          emit(PopularTvHasData(data));
        },
      );
    });
  }
}
