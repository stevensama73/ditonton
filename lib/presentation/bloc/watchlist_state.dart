part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistEmpty extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistSuccess extends WatchlistState {
  final String message;

  WatchlistSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistError extends WatchlistState {
  final String message;

  WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistStatus extends WatchlistState {
  bool status = false;

  WatchlistStatus(this.status);

  @override
  List<Object> get props => [status];
}

class WatchlistHasData extends WatchlistState {
  final List<Movie> result;

  WatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}
