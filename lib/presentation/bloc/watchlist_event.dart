part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class OnWatchlist extends WatchlistEvent {}

class OnSaveWatchlist extends WatchlistEvent {
  final MovieDetail movie;

  OnSaveWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnRemoveWatchlist extends WatchlistEvent {
  final MovieDetail movie;

  OnRemoveWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnWatchlistStatus extends WatchlistEvent {
  final int id;

  OnWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
