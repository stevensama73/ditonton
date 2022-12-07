import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTv, SaveTvWatchlist, RemoveTvWatchlist, GetWatchListTvStatus])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockSaveTvWatchlist mockSaveTvWatchlistTv;
  late MockRemoveTvWatchlist mockRemoveTvWatchlistTv;
  late MockGetWatchListTvStatus mockWatchlistTvStatus;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockSaveTvWatchlistTv = MockSaveTvWatchlist();
    mockRemoveTvWatchlistTv = MockRemoveTvWatchlist();
    mockWatchlistTvStatus = MockGetWatchListTvStatus();
    watchlistTvBloc = WatchlistTvBloc(mockSaveTvWatchlistTv, mockRemoveTvWatchlistTv, mockWatchlistTvStatus, mockGetWatchlistTv);
  });

  test('initial state should be empty', () {
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTv.execute()).thenAnswer((_) async => Right([testWatchlistTv]));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(OnWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvHasData([testWatchlistTv]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetWatchlistTv.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(OnWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Success] when save data is gotten successfully',
    build: () {
      when(mockSaveTvWatchlistTv.execute(testTvDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockWatchlistTvStatus.execute(testTvDetail.id)).thenAnswer((_) async => true);
      return watchlistTvBloc;
    },
    act: (bloc) => [bloc.add(OnSaveWatchlistTv(testTvDetail)), bloc.add(OnWatchlistTvStatus(testTvDetail.id))],
    expect: () => [WatchlistTvSuccess('Added to Watchlist'), WatchlistTvStatus(watchlistTvBloc.isAddedToWatchlistTv)],
    verify: (bloc) {
      verify(mockSaveTvWatchlistTv.execute(testTvDetail));
      verify(mockWatchlistTvStatus.execute(testTvDetail.id));
    },
  );
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Error] when save data is unsuccessful',
    build: () {
      when(mockSaveTvWatchlistTv.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(OnSaveWatchlistTv(testTvDetail)),
    expect: () => [
      WatchlistTvError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockSaveTvWatchlistTv.execute(testTvDetail));
    },
  );
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Success] when remove data is gotten successfully',
    build: () {
      when(mockRemoveTvWatchlistTv.execute(testTvDetail)).thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockWatchlistTvStatus.execute(testTvDetail.id)).thenAnswer((_) async => false);
      return watchlistTvBloc;
    },
    act: (bloc) => [bloc.add(OnRemoveWatchlistTv(testTvDetail)), bloc.add(OnWatchlistTvStatus(testTvDetail.id))],
    expect: () => [WatchlistTvSuccess('Removed from Watchlist'), WatchlistTvStatus(watchlistTvBloc.isAddedToWatchlistTv)],
    verify: (bloc) {
      verify(mockRemoveTvWatchlistTv.execute(testTvDetail));
      verify(mockWatchlistTvStatus.execute(testTvDetail.id));
    },
  );
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Error] when remove data is unsuccessful',
    build: () {
      when(mockRemoveTvWatchlistTv.execute(testTvDetail)).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(OnRemoveWatchlistTv(testTvDetail)),
    expect: () => [
      WatchlistTvError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveTvWatchlistTv.execute(testTvDetail));
    },
  );
}
