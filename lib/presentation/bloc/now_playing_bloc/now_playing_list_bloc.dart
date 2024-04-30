import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_event.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc/now_playing_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingListBloc
    extends Bloc<NowPlayingListEvent, NowPlayingListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetNowPlayingTvSeries _getNowPlayingTvSeries;

  NowPlayingListBloc(this._getNowPlayingMovies, this._getNowPlayingTvSeries)
      : super(NowPlayingListResultEmpty()) {
    on<FetchNowPlayingMovie>((event, emit) async {
      emit(NowPlayingListResultLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold((failure) {
        emit(NowPlayingListResultError(failure.message));
      }, (data) {
        emit(NowPlayingListResultLoadedMovie(data));
      });
    });

    on<FetchNowPlayingTvSeries>((event, emit) async {
      //loading
      emit(NowPlayingListResultLoading());
      final result = await _getNowPlayingTvSeries.execute();

      result.fold((failure) {
        emit(NowPlayingListResultError(failure.message));
      }, (data) {
        emit(NowPlayingListResultLoadedTvSeries(data));
      });
    });
  }
}
