import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatus,
  GetTvSeriesWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist
])
void main() {
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockGetTvSeriesWatchListStatus mockGetTvSeriesWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  late WatchlistBloc watchlistBloc;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockGetTvSeriesWatchListStatus = MockGetTvSeriesWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    watchlistBloc = WatchlistBloc(mockGetTvSeriesWatchListStatus,
        mockGetWatchListStatus, mockRemoveWatchlist, mockSaveWatchlist);
  });

  int tId = 1;

  group("Add Item to watchlist", () {
    test('initial state should be empty', () {
      expect(watchlistBloc.state, WatchListEmptyState());
    });

    blocTest<WatchlistBloc, WatchlistState>(
      "success result save movie to watchlist",
      build: () {
        when(mockSaveWatchlist.execute(testDetailEntityObject, MOVIE_TYPE))
            .thenAnswer((_) async => Right("Sukses save item"));
        return watchlistBloc;
      },
      act: (bloc) =>
          bloc.add(AddItemToWatchlist(testDetailEntityObject, MOVIE_TYPE)),
      expect: () => [WatchlistSuccessState("Sukses save item")],
      verify: (bloc) => {
        verify(mockSaveWatchlist.execute(testDetailEntityObject, MOVIE_TYPE))
      },
    );
    blocTest<WatchlistBloc, WatchlistState>(
      "failed result save movie to watchlist",
      build: () {
        when(mockSaveWatchlist.execute(testDetailEntityObject, MOVIE_TYPE))
            .thenAnswer(
                (_) async => Left(ServerFailure('Failed to save data!')));
        return watchlistBloc;
      },
      act: (bloc) =>
          bloc.add(AddItemToWatchlist(testDetailEntityObject, MOVIE_TYPE)),
      expect: () => [WatchlistFailedState("Failed to save data!")],
      verify: (bloc) => {
        verify(mockSaveWatchlist.execute(testDetailEntityObject, MOVIE_TYPE))
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      "success result save tv series to watchlist",
      build: () {
        when(mockSaveWatchlist.execute(testDetailEntityObject, TV_SERIES_TYPE))
            .thenAnswer((_) async => Right("Sukses save item"));
        return watchlistBloc;
      },
      act: (bloc) =>
          bloc.add(AddItemToWatchlist(testDetailEntityObject, TV_SERIES_TYPE)),
      expect: () => [WatchlistSuccessState("Sukses save item")],
      verify: (bloc) => {
        verify(
            mockSaveWatchlist.execute(testDetailEntityObject, TV_SERIES_TYPE))
      },
    );
    blocTest<WatchlistBloc, WatchlistState>(
      "failed result save tv series to watchlist",
      build: () {
        when(mockSaveWatchlist.execute(testDetailEntityObject, TV_SERIES_TYPE))
            .thenAnswer(
                (_) async => Left(ServerFailure('Failed to save data!')));
        return watchlistBloc;
      },
      act: (bloc) =>
          bloc.add(AddItemToWatchlist(testDetailEntityObject, TV_SERIES_TYPE)),
      expect: () => [WatchlistFailedState("Failed to save data!")],
      verify: (bloc) => {
        verify(
            mockSaveWatchlist.execute(testDetailEntityObject, TV_SERIES_TYPE))
      },
    );
  });

  group("Remove Item to watchlist", () {
    test('initial state should be empty', () {
      expect(watchlistBloc.state, WatchListEmptyState());
    });
    blocTest<WatchlistBloc, WatchlistState>(
      "success result remove movie from watchlist",
      build: () {
        when(mockRemoveWatchlist.execute(testDetailEntityObject, MOVIE_TYPE))
            .thenAnswer((_) async => Right("Sukses save item"));
        return watchlistBloc;
      },
      act: (bloc) => bloc
          .add(RemoveMovieFromWatchlist(testDetailEntityObject, MOVIE_TYPE)),
      expect: () => [WatchlistSuccessState("Sukses save item")],
      verify: (bloc) => {
        verify(mockRemoveWatchlist.execute(testDetailEntityObject, MOVIE_TYPE))
      },
    );
    blocTest<WatchlistBloc, WatchlistState>(
      "failed result remove movie to watchlist",
      build: () {
        when(mockRemoveWatchlist.execute(testDetailEntityObject, MOVIE_TYPE))
            .thenAnswer(
                (_) async => Left(ServerFailure('Failed to save data!')));
        return watchlistBloc;
      },
      act: (bloc) => bloc
          .add(RemoveMovieFromWatchlist(testDetailEntityObject, MOVIE_TYPE)),
      expect: () => [WatchlistFailedState("Failed to save data!")],
      verify: (bloc) => {
        verify(mockRemoveWatchlist.execute(testDetailEntityObject, MOVIE_TYPE))
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      "success result remove tv series from watchlist",
      build: () {
        when(mockRemoveWatchlist.execute(
                testDetailEntityObject, TV_SERIES_TYPE))
            .thenAnswer((_) async => Right("Sukses save item"));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(
          RemoveMovieFromWatchlist(testDetailEntityObject, TV_SERIES_TYPE)),
      expect: () => [WatchlistSuccessState("Sukses save item")],
      verify: (bloc) => {
        verify(
            mockRemoveWatchlist.execute(testDetailEntityObject, TV_SERIES_TYPE))
      },
    );
    blocTest<WatchlistBloc, WatchlistState>(
      "failed result remove movie to watchlist",
      build: () {
        when(mockRemoveWatchlist.execute(
                testDetailEntityObject, TV_SERIES_TYPE))
            .thenAnswer(
                (_) async => Left(ServerFailure('Failed to save data!')));
        return watchlistBloc;
      },
      act: (bloc) => bloc.add(
          RemoveMovieFromWatchlist(testDetailEntityObject, TV_SERIES_TYPE)),
      expect: () => [WatchlistFailedState("Failed to save data!")],
      verify: (bloc) => {
        verify(
            mockRemoveWatchlist.execute(testDetailEntityObject, TV_SERIES_TYPE))
      },
    );
  });

  group("Check movie watchlist status", () {
    test('initial state should be empty', () {
      expect(watchlistBloc.state, WatchListEmptyState());
    });

    blocTest<WatchlistBloc, WatchlistState>("Get movie watchlist status true",
        build: () {
          when(mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => true);
          return watchlistBloc;
        },
        act: (bloc) => bloc.add(CheckMovieWatchlistStatus(tId)),
        expect: () => [StatusState(true)],
        verify: (bloc) {
          verify(mockGetWatchListStatus.execute(tId));
        });
    blocTest<WatchlistBloc, WatchlistState>("Get movie watchlist status false",
        build: () {
          when(mockGetWatchListStatus.execute(tId))
              .thenAnswer((_) async => false);
          return watchlistBloc;
        },
        act: (bloc) => bloc.add(CheckMovieWatchlistStatus(tId)),
        expect: () => [StatusState(false)],
        verify: (bloc) {
          verify(mockGetWatchListStatus.execute(tId));
        });
  });
  group("Check tvseries watchlit status", () {
    test('initial state should be empty', () {
      expect(watchlistBloc.state, WatchListEmptyState());
    });

    blocTest<WatchlistBloc, WatchlistState>(
        "Get tv series watchlist status true",
        build: () {
          when(mockGetTvSeriesWatchListStatus.execute(tId))
              .thenAnswer((_) async => true);
          return watchlistBloc;
        },
        act: (bloc) => bloc.add(CheckTvSeriesWatchlistStatus(tId)),
        expect: () => [StatusState(true)],
        verify: (bloc) {
          verify(mockGetTvSeriesWatchListStatus.execute(tId));
        });
    blocTest<WatchlistBloc, WatchlistState>(
        "Get tv series watchlist status false",
        build: () {
          when(mockGetTvSeriesWatchListStatus.execute(tId))
              .thenAnswer((_) async => false);
          return watchlistBloc;
        },
        act: (bloc) => bloc.add(CheckTvSeriesWatchlistStatus(tId)),
        expect: () => [StatusState(false)],
        verify: (bloc) {
          verify(mockGetTvSeriesWatchListStatus.execute(tId));
        });
  });
}
