import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  static const watchlistTvAddSuccessMessage = 'Added to Watchlist';
  static const watchlistTvRemoveSuccessMessage = 'Removed from Watchlist';

  bool _isAddedtoWatchlistTv = false;

  bool get isAddedToWatchlistTv => _isAddedtoWatchlistTv;

  final SaveTvWatchlist _saveWatchlistTv;
  final RemoveTvWatchlist _removeWatchlistTv;
  final GetWatchListTvStatus _watchlistTvStatus;
  final GetWatchlistTv _watchlistTv;

  WatchlistTvBloc(this._saveWatchlistTv, this._removeWatchlistTv, this._watchlistTvStatus, this._watchlistTv) : super(WatchlistTvEmpty()) {
    on<OnWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await _watchlistTv.execute();

      result.fold(
        (failure) {
          emit(WatchlistTvError(failure.message));
        },
        (data) {
          emit(WatchlistTvHasData(data));
        },
      );
    });
    on<OnSaveWatchlistTv>((event, emit) async {
      final result = await _saveWatchlistTv.execute(event.tv);

      result.fold(
        (failure) {
          emit(WatchlistTvError(failure.message));
        },
        (data) {
          emit(WatchlistTvSuccess(data));
        },
      );

      OnWatchlistTvStatus(event.tv.id);
    });
    on<OnRemoveWatchlistTv>((event, emit) async {
      final result = await _removeWatchlistTv.execute(event.tv);

      result.fold(
        (failure) {
          emit(WatchlistTvError(failure.message));
        },
        (data) {
          emit(WatchlistTvSuccess(data));
        },
      );

      OnWatchlistTvStatus(event.tv.id);
    });
    on<OnWatchlistTvStatus>((event, emit) async {
      final result = await _watchlistTvStatus.execute(event.id);
      _isAddedtoWatchlistTv = result;
      emit(WatchlistTvStatus(result));
    });
  }
}
