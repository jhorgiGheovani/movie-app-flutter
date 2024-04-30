import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_event.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_page_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies, GetTopRatedTvSeries])
void main() {
  late TopRatedListBloc topRatedListBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();

    topRatedListBloc =
        TopRatedListBloc(mockGetTopRatedMovies, mockGetTopRatedTvSeries);
  });

  group("Get top rated movie", () {
    test('initial state should be empty', () {
      expect(topRatedListBloc.state, TopRatedEmptyState());
    });

    blocTest<TopRatedListBloc, TopRatedListState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(dummy_data_testMovieList));
        return topRatedListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovie()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TopRatedLoadingState(),
        TopRatedLoadedMovieState(dummy_data_testMovieList)
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<TopRatedListBloc, TopRatedListState>(
      'Should emit [Loading, Error] when get top rated movie is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovie()),
      expect: () => [
        TopRatedLoadingState(),
        TopRatedErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });

  group("Get top rated tv series", () {
    test('initial state should be empty', () {
      expect(topRatedListBloc.state, TopRatedEmptyState());
    });

    blocTest<TopRatedListBloc, TopRatedListState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(dummy_data_testTvSeriesList));
        return topRatedListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TopRatedLoadingState(),
        TopRatedLoadedTvSeriesState(dummy_data_testTvSeriesList)
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );

    blocTest<TopRatedListBloc, TopRatedListState>(
      'Should emit [Loading, Error] when get top rated tv series is unsuccessful',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedLoadingState(),
        TopRatedErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );
  });
}
