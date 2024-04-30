import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_bloc.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_event.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_page_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail, GetTvSeriesDetail])
void main() {
  late DetailPageBloc detailPageBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();

    detailPageBloc = DetailPageBloc(mockGetMovieDetail, mockGetTvSeriesDetail);
  });

  final tId = 1;

  group("Get Movie Detail", () {
    test("initial state should be empty", () {
      expect(detailPageBloc.state, DetailPageEmptyState());
    });

    blocTest<DetailPageBloc, DetailPageState>(
        "Should emit [Loading, HasData] when data is gotten successfully",
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testDetailEntityObject));
          return detailPageBloc;
        },
        act: (bloc) => bloc.add(FetchMovieDetail(tId)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              DetailPageLoadingState(),
              DetailPageLoadedState(testDetailEntityObject)
            ],
        verify: (bloc) {
          verify(mockGetMovieDetail.execute(tId));
        });

    blocTest<DetailPageBloc, DetailPageState>(
      'Should emit [Loading, Error] when get detail movie is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return detailPageBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        DetailPageLoadingState(),
        DetailPageErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });

  group("Get Tv Series Detail", () {
    test("initial state should be empty", () {
      expect(detailPageBloc.state, DetailPageEmptyState());
    });

    blocTest<DetailPageBloc, DetailPageState>(
        "Should emit [Loading, HasData] when data is gotten successfully",
        build: () {
          when(mockGetTvSeriesDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvSeriesDetail));
          return detailPageBloc;
        },
        act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
              DetailPageLoadingState(),
              DetailPageLoadedState(testTvSeriesDetail)
            ],
        verify: (bloc) {
          verify(mockGetTvSeriesDetail.execute(tId));
        });

    blocTest<DetailPageBloc, DetailPageState>(
      'Should emit [Loading, Error] when get detail tv series is unsuccessful',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return detailPageBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        DetailPageLoadingState(),
        DetailPageErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
      },
    );
  });
}
