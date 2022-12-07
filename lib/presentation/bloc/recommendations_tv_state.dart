part of 'recommendations_tv_bloc.dart';

abstract class RecommendationsTvState extends Equatable {
  const RecommendationsTvState();

  @override
  List<Object> get props => [];
}

class RecommendationsTvEmpty extends RecommendationsTvState {}

class RecommendationsTvLoading extends RecommendationsTvState {}

class RecommendationsTvError extends RecommendationsTvState {
  final String message;

  RecommendationsTvError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationsTvHasData extends RecommendationsTvState {
  final List<Tv> result;

  RecommendationsTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
