import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton/presentation/pages/airing_today_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAiringTodayTvBloc extends MockBloc<AiringTodayTvEvent, AiringTodayTvState> implements AiringTodayTvBloc {}

class AiringTodayTvEventFake extends Fake implements AiringTodayTvEvent {}

class AiringTodayTvStateFake extends Fake implements AiringTodayTvState {}

void main() {
  late final mockBloc;

  setUpAll(() {
    registerFallbackValue(AiringTodayTvEventFake());
    registerFallbackValue(AiringTodayTvStateFake());
    mockBloc = MockAiringTodayTvBloc();
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

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<AiringTodayTvBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(AiringTodayTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(AiringTodayTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(AiringTodayTvHasData(tTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(AiringTodayTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(AiringTodayTvError('Error Message'));

    final textFinder = find.text('Error Message');

    await tester.pumpWidget(_makeTestableWidget(AiringTodayTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
