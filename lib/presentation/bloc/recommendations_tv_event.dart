part of 'recommendations_tv_bloc.dart';

abstract class RecommendationsTvEvent extends Equatable {
  const RecommendationsTvEvent();

  @override
  List<Object> get props => [];
}

class OnRecommendationsTv extends RecommendationsTvEvent {
  final int id;

  OnRecommendationsTv(this.id);

  @override
  List<Object> get props => [id];
}
