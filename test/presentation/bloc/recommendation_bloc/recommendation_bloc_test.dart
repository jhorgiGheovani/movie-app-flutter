import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_bloc.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_event.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations, GetTvSeriesRecommendations])
void main() {
  late RecommendationListBloc recommendationListBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();

    recommendationListBloc = RecommendationListBloc(
        mockGetMovieRecommendations, mockGetTvSeriesRecommendations);
  });

  final int tId = 1;

  group("Get Movie Recommendation", () {
    test('initial state should be empty', () {
      expect(recommendationListBloc.state, RecommendationEmptyState());
    });

    blocTest<RecommendationListBloc, RecommendationListState>(
        "Should emit [Loading, HasData] when data is gotten successfully",
        build: () {
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(dummy_data_testMovieList));
          return recommendationListBloc;
        },
        act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              RecommendationLoadingState(),
              RecommendationLoadedMovieState(dummy_data_testMovieList)
            ],
        verify: (bloc) {
          verify(mockGetMovieRecommendations.execute(tId));
        });

    blocTest<RecommendationListBloc, RecommendationListState>(
      'Should emit [Loading, Error] when get recommendation movie is unsuccessful',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return recommendationListBloc;
      },
      act: (bloc) => bloc.add(FetchMovieRecommendation(tId)),
      expect: () => [
        RecommendationLoadingState(),
        RecommendationErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group("Get Tv Series Recommendation", () {
    test('initial state should be empty', () {
      expect(recommendationListBloc.state, RecommendationEmptyState());
    });

    blocTest<RecommendationListBloc, RecommendationListState>(
        "Should emit [Loading, HasData] when data is gotten successfully",
        build: () {
          when(mockGetTvSeriesRecommendations.execute(tId))
              .thenAnswer((_) async => Right(dummy_data_testTvSeriesList));
          return recommendationListBloc;
        },
        act: (bloc) => bloc.add(FetchTvSeriesRecommendation(tId)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              RecommendationLoadingState(),
              RecommendationLoadedTvSeriesState(dummy_data_testTvSeriesList)
            ],
        verify: (bloc) {
          verify(mockGetTvSeriesRecommendations.execute(tId));
        });

    blocTest<RecommendationListBloc, RecommendationListState>(
      'Should emit [Loading, Error] when get recommendation tv series is unsuccessful',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return recommendationListBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesRecommendation(tId)),
      expect: () => [
        RecommendationLoadingState(),
        RecommendationErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );
  });
}
