import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recommendations_event.dart';
part 'recommendations_state.dart';

class RecommendationsBloc extends Bloc<RecommendationsEvent, RecommendationsState> {
  final GetMovieRecommendations _recommendationsMovies;

  RecommendationsBloc(this._recommendationsMovies) : super(RecommendationsEmpty()) {
    on<OnRecommendationsMovies>((event, emit) async {
      emit(RecommendationsLoading());
      final result = await _recommendationsMovies.execute(event.id);

      result.fold(
        (failure) {
          emit(RecommendationsError(failure.message));
        },
        (data) {
          emit(RecommendationsHasData(data));
        },
      );
    });
  }
}
