import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/presentation/bloc/recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/recommendations_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendations_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main() {
  late RecommendationsTvBloc recommendationsTvBloc;
  late MockGetTvRecommendations mockGetRecommendationsTv;

  setUp(() {
    mockGetRecommendationsTv = MockGetTvRecommendations();
    recommendationsTvBloc = RecommendationsTvBloc(mockGetRecommendationsTv);
  });

  test('initial state should be empty', () {
    expect(recommendationsTvBloc.state, RecommendationsTvEmpty());
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
  final tId = 1;

  blocTest<RecommendationsTvBloc, RecommendationsTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetRecommendationsTv.execute(tId)).thenAnswer((_) async => Right(tTvList));
      return recommendationsTvBloc;
    },
    act: (bloc) => bloc.add(OnRecommendationsTv(tId)),
    expect: () => [
      RecommendationsTvLoading(),
      RecommendationsTvHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetRecommendationsTv.execute(tId));
    },
  );

  blocTest<RecommendationsTvBloc, RecommendationsTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetRecommendationsTv.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return recommendationsTvBloc;
    },
    act: (bloc) => bloc.add(OnRecommendationsTv(tId)),
    expect: () => [
      RecommendationsTvLoading(),
      RecommendationsTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetRecommendationsTv.execute(tId));
    },
  );
}
