import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_tv_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTv])
void main() {
  late AiringTodayTvBloc airingTodayTvBloc;
  late MockGetAiringTodayTv mockGetAiringTodayTv;

  setUp(() {
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    airingTodayTvBloc = AiringTodayTvBloc(mockGetAiringTodayTv);
  });

  test('initial state should be empty', () {
    expect(airingTodayTvBloc.state, AiringTodayTvEmpty());
  });

  final tTvModel = Tv(
      backdropPath: "/5kkw5RT1OjTAMh3POhjo5LdaACZ.jpg",
      genreIds: [80, 10765],
      id: 90462,
      originalName: "Chucky",
      overview: "After a vintage Chucky doll",
      popularity: 3642.719,
      posterPath: "/kY0BogCM8SkNJ0MNiHB3VTM86Tz.jpg",
      firstAirDate: "2021-10-12",
      name: "Chucky",
      voteAverage: 7.9,
      voteCount: 3481);
  final tTvList = <Tv>[tTvModel];

  blocTest<AiringTodayTvBloc, AiringTodayTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetAiringTodayTv.execute()).thenAnswer((_) async => Right(tTvList));
      return airingTodayTvBloc;
    },
    act: (bloc) => bloc.add(OnAiringTodayTv()),
    expect: () => [
      AiringTodayTvLoading(),
      AiringTodayTvHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTv.execute());
    },
  );

  blocTest<AiringTodayTvBloc, AiringTodayTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetAiringTodayTv.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return airingTodayTvBloc;
    },
    act: (bloc) => bloc.add(OnAiringTodayTv()),
    expect: () => [
      AiringTodayTvLoading(),
      AiringTodayTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTv.execute());
    },
  );
}
