import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'get_watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late GetWatchListMovieBloc getWatchListMovieBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();

    getWatchListMovieBloc = GetWatchListMovieBloc(mockGetWatchlistMovies);
  });

  group('Get list Watchlist movie', () {
    test('initial state should be empty', () {
      expect(getWatchListMovieBloc.state, GetWatchlistMovieEmptyState());
    });

    blocTest<GetWatchListMovieBloc, GetWatchListMovieState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(dummy_data_testMovieList));
        return getWatchListMovieBloc;
      },
      act: (bloc) => bloc.add(GetWatchListMovie()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        GetWatchlistMovieLoadingState(),
        GetWatchlistLoadedMovieState(dummy_data_testMovieList)
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<GetWatchListMovieBloc, GetWatchListMovieState>(
      'Should emit [Loading, Error] when get tv series watchlist is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return getWatchListMovieBloc;
      },
      act: (bloc) => bloc.add(GetWatchListMovie()),
      expect: () => [
        GetWatchlistMovieLoadingState(),
        GetWatchlistMovieErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });
}
