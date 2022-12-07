import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/bloc/detail_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/recommendations_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class MockDetailTvBloc extends MockBloc<DetailTvEvent, DetailTvState> implements DetailTvBloc {}

class DetailTvEventFake extends Fake implements DetailTvEvent {}

class DetailTvStateFake extends Fake implements DetailTvState {}

class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState> implements WatchlistTvBloc {}

class WatchlistTvEventFake extends Fake implements WatchlistTvEvent {}

class WatchlistTvStateFake extends Fake implements WatchlistTvState {}

class MockRecommendationsTvBloc extends MockBloc<RecommendationsTvEvent, RecommendationsTvState> implements RecommendationsTvBloc {}

class RecommendationsTvEventFake extends Fake implements RecommendationsTvEvent {}

class RecommendationsTvStateFake extends Fake implements RecommendationsTvState {}

void main() {
  late final detailMockBloc;
  late final watchlistMockBloc;
  late final recommendationsMockBloc;

  setUpAll(() {
    registerFallbackValue(DetailTvEventFake());
    registerFallbackValue(DetailTvStateFake());
    detailMockBloc = MockDetailTvBloc();
    watchlistMockBloc = MockWatchlistTvBloc();
    recommendationsMockBloc = MockRecommendationsTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailTvBloc>(create: (_) => detailMockBloc),
        BlocProvider<WatchlistTvBloc>(create: (_) => watchlistMockBloc),
        BlocProvider<RecommendationsTvBloc>(create: (_) => recommendationsMockBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Watchlist button should display add icon when tv not added to watchlist', (WidgetTester tester) async {
    when(() => detailMockBloc.state).thenReturn(DetailTvHasData(testTvDetail));
    when(() => recommendationsMockBloc.state).thenReturn(RecommendationsTvHasData([testTv]));
    when(() => watchlistMockBloc.state).thenReturn(WatchlistTvStatus(false));
    when(() => watchlistMockBloc.isAddedToWatchlistTv).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should dispay check icon when tv is added to wathclist', (WidgetTester tester) async {
    when(() => detailMockBloc.state).thenReturn(DetailTvHasData(testTvDetail));
    when(() => recommendationsMockBloc.state).thenReturn(RecommendationsTvHasData([testTv]));
    when(() => watchlistMockBloc.state).thenReturn(WatchlistTvStatus(true));
    when(() => watchlistMockBloc.isAddedToWatchlistTv).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Watchlist button should display Snackbar when added to watchlist', (WidgetTester tester) async {
    when(() => detailMockBloc.state).thenReturn(DetailTvHasData(testTvDetail));
    when(() => recommendationsMockBloc.state).thenReturn(RecommendationsTvHasData([testTv]));
    when(() => watchlistMockBloc.state).thenReturn(WatchlistTvStatus(false));
    when(() => watchlistMockBloc.isAddedToWatchlistTv).thenReturn(false);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('Watchlist button should display AlertDialog when add to watchlist failed', (WidgetTester tester) async {
    when(() => detailMockBloc.state).thenReturn(DetailTvHasData(testTvDetail));
    when(() => recommendationsMockBloc.state).thenReturn(RecommendationsTvHasData([testTv]));
    when(() => watchlistMockBloc.state).thenReturn(WatchlistTvStatus(false));
    when(() => watchlistMockBloc.isAddedToWatchlistTv).thenReturn(false);
    when(() => watchlistMockBloc.state).thenReturn(WatchlistTvError('Failed'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
