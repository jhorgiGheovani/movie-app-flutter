import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_state.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../top_rated_movie_page/top_rated_movie_page_test.mocks.dart';

void main() {
  late MockTopRatedListBloc mockTopRatedListBloc;
  setUp(() {
    mockTopRatedListBloc = MockTopRatedListBloc();
    when(mockTopRatedListBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedListBloc>.value(
      value: mockTopRatedListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockTopRatedListBloc.state).thenReturn(TopRatedLoadingState());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets("Page should display when data is loaded",
      (WidgetTester tester) async {
    when(mockTopRatedListBloc.state)
        .thenReturn(TopRatedLoadedTvSeriesState(dummy_data_testTvSeriesList));
    final listViewFinder = find.byType(ListView);
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets("Page should display text with message when Error",
      (WidgetTester tester) async {
    when(mockTopRatedListBloc.state)
        .thenReturn(TopRatedErrorState("Error message"));
    final centerFinder = find.byType(Center);
    final textFinder = find.byKey(Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));
    expect(centerFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Page return unknown state", (WidgetTester tester) async {
    when(mockTopRatedListBloc.state).thenReturn(TopRatedUnknownState());
    final centerFinder = find.byType(Center);
    final textFinder = find.text("Something went wrong!");
    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));
    expect(centerFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });
}
