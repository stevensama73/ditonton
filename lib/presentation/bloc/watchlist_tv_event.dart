part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  List<Object> get props => [];
}

class OnWatchlistTv extends WatchlistTvEvent {}

class OnSaveWatchlistTv extends WatchlistTvEvent {
  final TvDetail tv;

  OnSaveWatchlistTv(this.tv);

  @override
  List<Object> get props => [tv];
}

class OnRemoveWatchlistTv extends WatchlistTvEvent {
  final TvDetail tv;

  OnRemoveWatchlistTv(this.tv);

  @override
  List<Object> get props => [tv];
}

class OnWatchlistTvStatus extends WatchlistTvEvent {
  final int id;

  OnWatchlistTvStatus(this.id);

  @override
  List<Object> get props => [id];
}
