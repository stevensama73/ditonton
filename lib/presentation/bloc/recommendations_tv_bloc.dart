import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recommendations_tv_event.dart';
part 'recommendations_tv_state.dart';

class RecommendationsTvBloc extends Bloc<RecommendationsTvEvent, RecommendationsTvState> {
  final GetTvRecommendations _recommendationsTv;

  RecommendationsTvBloc(this._recommendationsTv) : super(RecommendationsTvEmpty()) {
    on<OnRecommendationsTv>((event, emit) async {
      emit(RecommendationsTvLoading());
      final result = await _recommendationsTv.execute(event.id);

      result.fold(
        (failure) {
          emit(RecommendationsTvError(failure.message));
        },
        (data) {
          emit(RecommendationsTvHasData(data));
        },
      );
    });
  }
}
