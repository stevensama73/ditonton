part of 'airing_today_tv_bloc.dart';

abstract class AiringTodayTvState extends Equatable {
  const AiringTodayTvState();

  @override
  List<Object> get props => [];
}

class AiringTodayTvEmpty extends AiringTodayTvState {}

class AiringTodayTvLoading extends AiringTodayTvState {}

class AiringTodayTvError extends AiringTodayTvState {
  final String message;

  AiringTodayTvError(this.message);

  @override
  List<Object> get props => [message];
}

class AiringTodayTvHasData extends AiringTodayTvState {
  final List<Tv> result;

  AiringTodayTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
