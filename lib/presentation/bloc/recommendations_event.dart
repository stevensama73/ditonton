part of 'recommendations_bloc.dart';

abstract class RecommendationsEvent extends Equatable {
  const RecommendationsEvent();

  @override
  List<Object> get props => [];
}

class OnRecommendationsMovies extends RecommendationsEvent {
  final int id;

  OnRecommendationsMovies(this.id);

  @override
  List<Object> get props => [id];
}
