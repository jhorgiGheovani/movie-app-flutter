import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc/watchlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistBloc extends Bloc<WatchListEvent, WatchlistState> {
  final GetWatchListStatus _getWatchListStatus;
  final GetTvSeriesWatchListStatus _getTvSeriesWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  WatchlistBloc(this._getTvSeriesWatchListStatus, this._getWatchListStatus,
      this._removeWatchlist, this._saveWatchlist)
      : super(WatchListEmptyState()) {
    on<AddItemToWatchlist>((event, emit) async {
      final item = event.item;
      final type = event.type;

      final result = await _saveWatchlist.execute(item, type);

      await result.fold((failure) {
        emit(WatchlistFailedState(failure.message));
      }, (success) {
        emit(WatchlistSuccessState(success));
      });
      // }
    });

    on<RemoveMovieFromWatchlist>((event, emit) async {
      final item = event.item;
      final type = event.type;

      final result = await _removeWatchlist.execute(item, type);
      await result.fold((failure) {
        emit(WatchlistFailedState(failure.message));
      }, (success) {
        emit(WatchlistSuccessState(success));
      });
    });

    on<CheckMovieWatchlistStatus>((event, emit) async {
      final id = event.id;
      final result = await _getWatchListStatus.execute(id);
      emit(StatusState(result));
    });

    on<CheckTvSeriesWatchlistStatus>((event, emit) async {
      final id = event.id;
      final result = await _getTvSeriesWatchListStatus.execute(id);
      emit(StatusState(result));
    });
  }
}
