import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/detail_bloc.dart';
import 'package:ditonton/presentation/bloc/recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class MockDetailBloc extends MockBloc<DetailEvent, DetailState> implements DetailBloc {}

class DetailEventFake extends Fake implements DetailEvent {}

class DetailStateFake extends Fake implements DetailState {}

class MockWatchlistBloc extends MockBloc<WatchlistEvent, WatchlistState> implements WatchlistBloc {}

class WatchlistEventFake extends Fake implements WatchlistEvent {}

class WatchlistStateFake extends Fake implements WatchlistState {}

class MockRecommendationsBloc extends MockBloc<RecommendationsEvent, RecommendationsState> implements RecommendationsBloc {}

class RecommendationsEventFake extends Fake implements RecommendationsEvent {}

class RecommendationsStateFake extends Fake implements RecommendationsState {}

void main() {
  late final detailMockBloc;
  late final watchlistMockBloc;
  late final recommendationsMockBloc;

  setUpAll(() {
    registerFallbackValue(DetailEventFake());
    registerFallbackValue(DetailStateFake());
    detailMockBloc = MockDetailBloc();
    watchlistMockBloc = MockWatchlistBloc();
    recommendationsMockBloc = MockRecommendationsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailBloc>(create: (_) => detailMockBloc),
        BlocProvider<WatchlistBloc>(create: (_) => watchlistMockBloc),
        BlocProvider<RecommendationsBloc>(create: (_) => recommendationsMockBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Watchlist button should display add icon when tv not added to watchlist', (WidgetTester tester) async {
    when(() => detailMockBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => recommendationsMockBloc.state).thenReturn(RecommendationsHasData([testMovie]));
    when(() => watchlistMockBloc.state).thenReturn(WatchlistStatus(false));
    when(() => watchlistMockBloc.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should dispay check icon when tv is added to wathclist', (WidgetTester tester) async {
    when(() => detailMockBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => recommendationsMockBloc.state).thenReturn(RecommendationsHasData([testMovie]));
    when(() => watchlistMockBloc.state).thenReturn(WatchlistStatus(true));
    when(() => watchlistMockBloc.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should display Snackbar when added to watchlist', (WidgetTester tester) async {
    when(() => detailMockBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => recommendationsMockBloc.state).thenReturn(RecommendationsHasData([testMovie]));
    when(() => watchlistMockBloc.state).thenReturn(WatchlistStatus(false));
    when(() => watchlistMockBloc.isAddedToWatchlist).thenReturn(false);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('Watchlist button should display AlertDialog when add to watchlist failed', (WidgetTester tester) async {
    when(() => detailMockBloc.state).thenReturn(DetailHasData(testMovieDetail));
    when(() => recommendationsMockBloc.state).thenReturn(RecommendationsHasData([testMovie]));
    when(() => watchlistMockBloc.state).thenReturn(WatchlistStatus(false));
    when(() => watchlistMockBloc.isAddedToWatchlist).thenReturn(false);
    when(() => watchlistMockBloc.state).thenReturn(WatchlistError('Failed'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
