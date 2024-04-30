import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_bloc.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_state.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_bloc.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_state.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_state.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_page_test.mocks.dart';

@GenerateMocks([DetailPageBloc, WatchlistBloc, RecommendationListBloc])
void main() {
  late MockDetailPageBloc mockDetailPageBloc;
  late MockWatchlistBloc mockWatchlistBloc;
  late MockRecommendationListBloc mockRecommendationListBloc;

  setUp(() {
    mockDetailPageBloc = MockDetailPageBloc();
    when(mockDetailPageBloc.stream).thenAnswer((_) => Stream.empty());
    mockWatchlistBloc = MockWatchlistBloc();
    when(mockWatchlistBloc.stream).thenAnswer((_) => Stream.empty());
    mockRecommendationListBloc = MockRecommendationListBloc();
    when(mockRecommendationListBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailPageBloc>.value(
          value: mockDetailPageBloc,
        ),
        BlocProvider<WatchlistBloc>.value(
          value: mockWatchlistBloc,
        ),
        BlocProvider<RecommendationListBloc>.value(
          value: mockRecommendationListBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      "Watchlist button should dispay check icon when movie is added to wathclist",
      (WidgetTester tester) async {
    when(mockDetailPageBloc.state)
        .thenReturn(DetailPageLoadedState(testDetailEntityObject));
    when(mockRecommendationListBloc.state)
        .thenReturn(RecommendationLoadedMovieState(dummy_data_testMovieList));
    when(mockWatchlistBloc.state).thenReturn(StatusState(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(_makeTestableWidget(DetailPage(
      id: 1,
      type: MOVIE_TYPE,
    )));
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      "Watchlist button should display add icon when movie not added to watchlist",
      (WidgetTester tester) async {
    when(mockDetailPageBloc.state)
        .thenReturn(DetailPageLoadedState(testDetailEntityObject));
    when(mockRecommendationListBloc.state)
        .thenReturn(RecommendationLoadedMovieState(dummy_data_testMovieList));
    when(mockWatchlistBloc.state).thenReturn(StatusState(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);
    await tester.pumpWidget(_makeTestableWidget(DetailPage(
      id: 1,
      type: MOVIE_TYPE,
    )));
    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets("Add item to watchlist when press the add watchlist button",
      (WidgetTester tester) async {
    when(mockDetailPageBloc.state)
        .thenReturn(DetailPageLoadedState(testDetailEntityObject));
    when(mockRecommendationListBloc.state)
        .thenReturn(RecommendationLoadedMovieState(dummy_data_testMovieList));
    when(mockWatchlistBloc.state).thenReturn(StatusState(false));

    final data = DetailPage(
      id: 1,
      type: MOVIE_TYPE,
    );
    await tester.pumpWidget(_makeTestableWidget(data));
    expect(find.byIcon(Icons.add), findsOneWidget);

    final watchlistButton = find.byType(ElevatedButton);
    await tester.tap(watchlistButton);
    await tester.pump();
    verify(mockWatchlistBloc
        .add(AddItemToWatchlist(testDetailEntityObject, MOVIE_TYPE)));
  });
}
