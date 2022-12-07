import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies, SaveWatchlist, RemoveWatchlist, GetWatchListStatus])
void main() {
  late WatchlistBloc watchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockSaveWatchlist mockSaveWatchlistMovies;
  late MockRemoveWatchlist mockRemoveWatchlistMovies;
  late MockGetWatchListStatus mockWatchlistMoviesStatus;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockSaveWatchlistMovies = MockSaveWatchlist();
    mockRemoveWatchlistMovies = MockRemoveWatchlist();
    mockWatchlistMoviesStatus = MockGetWatchListStatus();
    watchlistBloc = WatchlistBloc(mockSaveWatchlistMovies, mockRemoveWatchlistMovies, mockWatchlistMoviesStatus, mockGetWatchlistMovies);
  });

  test('initial state should be empty', () {
    expect(watchlistBloc.state, WatchlistEmpty());
  });

  blocTest<WatchlistBloc, WatchlistState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(OnWatchlist()),
    expect: () => [
      WatchlistLoading(),
      WatchlistHasData([testWatchlistMovie]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
  blocTest<WatchlistBloc, WatchlistState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(OnWatchlist()),
    expect: () => [
      WatchlistLoading(),
      WatchlistError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
  blocTest<WatchlistBloc, WatchlistState>(
    'Should emit [Success] when save data is gotten successfully',
    build: () {
      when(mockSaveWatchlistMovies.execute(testMovieDetail)).thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockWatchlistMoviesStatus.execute(testMovieDetail.id)).thenAnswer((_) async => true);
      return watchlistBloc;
    },
    act: (bloc) => [bloc.add(OnSaveWatchlist(testMovieDetail)), bloc.add(OnWatchlistStatus(testMovieDetail.id))],
    expect: () => [WatchlistSuccess('Added to Watchlist'), WatchlistStatus(watchlistBloc.isAddedToWatchlist)],
    verify: (bloc) {
      verify(mockSaveWatchlistMovies.execute(testMovieDetail));
      verify(mockWatchlistMoviesStatus.execute(testMovieDetail.id));
    },
  );
  blocTest<WatchlistBloc, WatchlistState>(
    'Should emit [Error] when save data is unsuccessful',
    build: () {
      when(mockSaveWatchlistMovies.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(OnSaveWatchlist(testMovieDetail)),
    expect: () => [
      WatchlistError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistMovies.execute(testMovieDetail));
    },
  );
  blocTest<WatchlistBloc, WatchlistState>(
    'Should emit [Success] when remove data is gotten successfully',
    build: () {
      when(mockRemoveWatchlistMovies.execute(testMovieDetail)).thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockWatchlistMoviesStatus.execute(testMovieDetail.id)).thenAnswer((_) async => false);
      return watchlistBloc;
    },
    act: (bloc) => [bloc.add(OnRemoveWatchlist(testMovieDetail)), bloc.add(OnWatchlistStatus(testMovieDetail.id))],
    expect: () => [WatchlistSuccess('Removed from Watchlist'), WatchlistStatus(watchlistBloc.isAddedToWatchlist)],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
      verify(mockWatchlistMoviesStatus.execute(testMovieDetail.id));
    },
  );
  blocTest<WatchlistBloc, WatchlistState>(
    'Should emit [Error] when remove data is unsuccessful',
    build: () {
      when(mockRemoveWatchlistMovies.execute(testMovieDetail)).thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(OnRemoveWatchlist(testMovieDetail)),
    expect: () => [
      WatchlistError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
    },
  );
}
