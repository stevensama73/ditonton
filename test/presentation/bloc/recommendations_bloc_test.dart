import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late RecommendationsBloc recommendationsBloc;
  late MockGetMovieRecommendations mockGetRecommendationsMovies;

  setUp(() {
    mockGetRecommendationsMovies = MockGetMovieRecommendations();
    recommendationsBloc = RecommendationsBloc(mockGetRecommendationsMovies);
  });

  test('initial state should be empty', () {
    expect(recommendationsBloc.state, RecommendationsEmpty());
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  final tId = 1;

  blocTest<RecommendationsBloc, RecommendationsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetRecommendationsMovies.execute(tId)).thenAnswer((_) async => Right(tMovieList));
      return recommendationsBloc;
    },
    act: (bloc) => bloc.add(OnRecommendationsMovies(tId)),
    expect: () => [
      RecommendationsLoading(),
      RecommendationsHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetRecommendationsMovies.execute(tId));
    },
  );

  blocTest<RecommendationsBloc, RecommendationsState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetRecommendationsMovies.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return recommendationsBloc;
    },
    act: (bloc) => bloc.add(OnRecommendationsMovies(tId)),
    expect: () => [
      RecommendationsLoading(),
      RecommendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetRecommendationsMovies.execute(tId));
    },
  );
}
