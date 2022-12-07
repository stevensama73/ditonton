part of 'recommendations_bloc.dart';

abstract class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object> get props => [];
}

class RecommendationsEmpty extends RecommendationsState {}

class RecommendationsLoading extends RecommendationsState {}

class RecommendationsError extends RecommendationsState {
  final String message;

  RecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationsHasData extends RecommendationsState {
  final List<Movie> result;

  RecommendationsHasData(this.result);

  @override
  List<Object> get props => [result];
}
