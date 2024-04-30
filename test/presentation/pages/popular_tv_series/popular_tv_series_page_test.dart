import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_state.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../popular_movie_page/popular_movie_page_test.mocks.dart';

void main() {
  late MockPopularListBloc mockPopularListBloc;

  setUp(() {
    mockPopularListBloc = MockPopularListBloc();
    when(mockPopularListBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularListBloc>.value(
      value: mockPopularListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group("test popular tv series page", () {
    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      when(mockPopularListBloc.state).thenReturn(PopularListResultLoading());

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    });

    testWidgets("Page should display when data is loaded",
        (WidgetTester tester) async {
      when(mockPopularListBloc.state).thenReturn(
          PopularListResultLoadedTvSeries(dummy_data_testTvSeriesList));
      final listViewFinder = find.byType(ListView);
      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets("Page should display text with message when Error",
        (WidgetTester tester) async {
      when(mockPopularListBloc.state)
          .thenReturn(PopularListResultError("Error message"));
      final centerFinder = find.byType(Center);
      final textFinder = find.byKey(Key('error_message'));
      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
      expect(centerFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    });

    testWidgets("Page return unknown state", (WidgetTester tester) async {
      when(mockPopularListBloc.state).thenReturn(PopularListUnknownState());
      final centerFinder = find.byType(Center);
      final textFinder = find.text("Something went wrong!");
      await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
      expect(centerFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    });
  });
}
