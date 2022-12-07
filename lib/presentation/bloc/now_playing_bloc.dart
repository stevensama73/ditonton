import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_event.dart';
part 'now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final GetNowPlayingMovies _nowPlayingMovies;

  NowPlayingBloc(this._nowPlayingMovies) : super(NowPlayingEmpty()) {
    on<OnNowPlayingMovies>((event, emit) async {
      emit(NowPlayingLoading());
      final result = await _nowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(NowPlayingError(failure.message));
        },
        (data) {
          emit(NowPlayingHasData(data));
        },
      );
    });
  }
}
