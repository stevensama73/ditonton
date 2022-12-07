import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail _detailMovie;

  DetailBloc(this._detailMovie) : super(DetailEmpty()) {
    on<OnDetail>((event, emit) async {
      emit(DetailLoading());
      final result = await _detailMovie.execute(event.id);

      result.fold(
        (failure) {
          emit(DetailError(failure.message));
        },
        (data) {
          emit(DetailHasData(data));
        },
      );
    });
  }
}
