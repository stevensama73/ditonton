import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  bool _isAddedtoWatchlist = false;

  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  final GetWatchListStatus _watchListStatus;
  final GetWatchlistMovies _watchlistMovie;

  WatchlistBloc(this._saveWatchlist, this._removeWatchlist, this._watchListStatus, this._watchlistMovie) : super(WatchlistEmpty()) {
    on<OnWatchlist>((event, emit) async {
      emit(WatchlistLoading());
      final result = await _watchlistMovie.execute();

      result.fold(
        (failure) {
          emit(WatchlistError(failure.message));
        },
        (data) {
          emit(WatchlistHasData(data));
        },
      );
    });
    on<OnSaveWatchlist>((event, emit) async {
      final result = await _saveWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(WatchlistError(failure.message));
        },
        (data) {
          emit(WatchlistSuccess(data));
        },
      );

      OnWatchlistStatus(event.movie.id);
    });
    on<OnRemoveWatchlist>((event, emit) async {
      final result = await _removeWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(WatchlistError(failure.message));
        },
        (data) {
          emit(WatchlistSuccess(data));
        },
      );

      OnWatchlistStatus(event.movie.id);
    });
    on<OnWatchlistStatus>((event, emit) async {
      final result = await _watchListStatus.execute(event.id);
      _isAddedtoWatchlist = result;
      emit(WatchlistStatus(result));
    });
  }
}
