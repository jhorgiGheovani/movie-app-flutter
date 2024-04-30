import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_state.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_series_page_test.mocks.dart';

@GenerateMocks([NowPlayingListBloc])
void main() {
  late MockNowPlayingListBloc mockNowPlayingListBloc;

  setUp(() {
    mockNowPlayingListBloc = MockNowPlayingListBloc();
    when(mockNowPlayingListBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingListBloc>.value(
      value: mockNowPlayingListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group("Now playing tv series test", () {
    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      when(mockNowPlayingListBloc.state)
          .thenReturn(NowPlayingListResultLoading());

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    });

    testWidgets("Page should display when data is loaded",
        (WidgetTester tester) async {
      when(mockNowPlayingListBloc.state).thenReturn(
          NowPlayingListResultLoadedTvSeries(dummy_data_testTvSeriesList));
      final listViewFinder = find.byType(ListView);
      await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets("Page should display text with message when Error",
        (WidgetTester tester) async {
      when(mockNowPlayingListBloc.state)
          .thenReturn(NowPlayingListResultError("Error message"));
      final centerFinder = find.byType(Center);
      final textFinder = find.byKey(Key('error_message'));
      await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));
      expect(centerFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    });

    testWidgets("Page return unknown state", (WidgetTester tester) async {
      when(mockNowPlayingListBloc.state).thenReturn(NowPlayingUnknownState());
      final centerFinder = find.byType(Center);
      final textFinder = find.text("Something went wrong!");
      await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));
      expect(centerFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    });
  });
}
