import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_event.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_list_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies, GetPopulartTvSeries])
void main() {
  late PopularListBloc popularListBloc;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetPopulartTvSeries mockGetPopulartTvSeries;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetPopulartTvSeries = MockGetPopulartTvSeries();

    popularListBloc =
        PopularListBloc(mockGetPopularMovies, mockGetPopulartTvSeries);
  });

  group("Get popular movie", () {
    test('initial state should be empty', () {
      expect(popularListBloc.state, PopularListResultEmpty());
    });

    blocTest<PopularListBloc, PopularListState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(dummy_data_testMovieList));
        return popularListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovie()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        PopularListResultLoading(),
        PopularListResultLoadedMovie(dummy_data_testMovieList)
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularListBloc, PopularListState>(
      'Should emit [Loading, Error] when get top rated movie is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovie()),
      expect: () => [
        PopularListResultLoading(),
        PopularListResultError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group("Get popular tv series", () {
    test('initial state should be empty', () {
      expect(popularListBloc.state, PopularListResultEmpty());
    });

    blocTest<PopularListBloc, PopularListState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockGetPopulartTvSeries.execute())
            .thenAnswer((_) async => Right(dummy_data_testTvSeriesList));
        return popularListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        PopularListResultLoading(),
        PopularListResultLoadedTvSeries(dummy_data_testTvSeriesList)
      ],
      verify: (bloc) {
        verify(mockGetPopulartTvSeries.execute());
      },
    );

    blocTest<PopularListBloc, PopularListState>(
      'Should emit [Loading, Error] when get top rated tv series is unsuccessful',
      build: () {
        when(mockGetPopulartTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        PopularListResultLoading(),
        PopularListResultError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopulartTvSeries.execute());
      },
    );
  });
}
