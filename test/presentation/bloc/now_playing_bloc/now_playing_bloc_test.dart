import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_event.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetNowPlayingTvSeries])
void main() {
  late NowPlayingListBloc nowPlayingListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();

    nowPlayingListBloc =
        NowPlayingListBloc(mockGetNowPlayingMovies, mockGetNowPlayingTvSeries);
  });

  group("Get now playing movie", () {
    test('initial state should be empty', () {
      expect(nowPlayingListBloc.state, NowPlayingListResultEmpty());
    });

    blocTest<NowPlayingListBloc, NowPlayingListState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(dummy_data_testMovieList));
        return nowPlayingListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovie()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        NowPlayingListResultLoading(),
        NowPlayingListResultLoadedMovie(dummy_data_testMovieList)
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<NowPlayingListBloc, NowPlayingListState>(
      'Should emit [Loading, Error] when get top rated movie is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovie()),
      expect: () => [
        NowPlayingListResultLoading(),
        NowPlayingListResultError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group("Get now playing tv series", () {
    test('initial state should be empty', () {
      expect(nowPlayingListBloc.state, NowPlayingListResultEmpty());
    });

    blocTest<NowPlayingListBloc, NowPlayingListState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(dummy_data_testTvSeriesList));
        return nowPlayingListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        NowPlayingListResultLoading(),
        NowPlayingListResultLoadedTvSeries(dummy_data_testTvSeriesList)
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvSeries.execute());
      },
    );

    blocTest<NowPlayingListBloc, NowPlayingListState>(
      'Should emit [Loading, Error] when get top rated tv series is unsuccessful',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      expect: () => [
        NowPlayingListResultLoading(),
        NowPlayingListResultError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvSeries.execute());
      },
    );
  });
}
