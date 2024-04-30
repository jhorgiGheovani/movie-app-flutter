import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watch_list_tv_series.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_bloc.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'get_watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  late GetWatchListTvSeriesBloc getWatchListTvSeriesBloc;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();

    getWatchListTvSeriesBloc =
        GetWatchListTvSeriesBloc(mockGetWatchlistTvSeries);
  });

  group('Get list Watchlist tv series', () {
    test('initial state should be empty', () {
      expect(getWatchListTvSeriesBloc.state, GetWatchlistTvSeriesEmptyState());
    });

    blocTest<GetWatchListTvSeriesBloc, GetWatchTvSeriesListState>(
      "Should emit [Loading, HasData] when data is gotten successfully",
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(dummy_data_testTvSeriesList));
        return getWatchListTvSeriesBloc;
      },
      act: (bloc) => bloc.add(GetWatchListTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        GetWatchlistTvSeriesLoadingState(),
        GetWatchlistLoadedTvSeriesState(dummy_data_testTvSeriesList)
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );

    blocTest<GetWatchListTvSeriesBloc, GetWatchTvSeriesListState>(
      'Should emit [Loading, Error] when get tv series watchlist is unsuccessful',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return getWatchListTvSeriesBloc;
      },
      act: (bloc) => bloc.add(GetWatchListTvSeries()),
      expect: () => [
        GetWatchlistTvSeriesLoadingState(),
        GetWatchlistTvSeriesErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );
  });
}
