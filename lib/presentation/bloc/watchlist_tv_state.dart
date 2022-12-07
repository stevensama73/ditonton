part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object> get props => [];
}

class WatchlistTvEmpty extends WatchlistTvState {}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvSuccess extends WatchlistTvState {
  final String message;

  WatchlistTvSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvError extends WatchlistTvState {
  final String message;

  WatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvStatus extends WatchlistTvState {
  bool status = false;

  WatchlistTvStatus(this.status);

  @override
  List<Object> get props => [status];
}

class WatchlistTvHasData extends WatchlistTvState {
  final List<Tv> result;

  WatchlistTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
