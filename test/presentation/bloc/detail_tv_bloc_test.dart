import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/detail_bloc.dart';
import 'package:ditonton/presentation/bloc/detail_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail])
void main() {
  late DetailTvBloc detailTvBloc;
  late MockGetTvDetail mockGetTvDetail;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    detailTvBloc = DetailTvBloc(mockGetTvDetail);
  });

  test('initial state should be empty', () {
    expect(detailTvBloc.state, DetailTvEmpty());
  });

  blocTest<DetailTvBloc, DetailTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvDetail.execute(1)).thenAnswer((_) async => Right(testTvDetail));
      return detailTvBloc;
    },
    act: (bloc) => bloc.add(OnDetailTv(1)),
    expect: () => [
      DetailTvLoading(),
      DetailTvHasData(testTvDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(1));
    },
  );

  blocTest<DetailTvBloc, DetailTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetTvDetail.execute(1)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return detailTvBloc;
    },
    act: (bloc) => bloc.add(OnDetailTv(1)),
    expect: () => [
      DetailTvLoading(),
      DetailTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(1));
    },
  );
}
