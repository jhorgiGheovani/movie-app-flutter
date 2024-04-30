import 'package:ditonton/domain/usecases/get_watch_list_tv_series.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tvseries_bloc/get_watchlist_tvseries_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetWatchListTvSeriesBloc
    extends Bloc<GetWatchListTvSeriesEvent, GetWatchTvSeriesListState> {
  final GetWatchlistTvSeries _getWatchlistTvSeries;

  GetWatchListTvSeriesBloc(this._getWatchlistTvSeries)
      : super(GetWatchlistTvSeriesEmptyState()) {
    on<GetWatchListTvSeries>((event, emit) async {
      emit(GetWatchlistTvSeriesLoadingState());
      final result = await _getWatchlistTvSeries.execute();

      result.fold((failure) {
        emit(GetWatchlistTvSeriesErrorState(failure.message));
      }, (data) {
        emit(GetWatchlistLoadedTvSeriesState(data));
      });
    });
  }
}
