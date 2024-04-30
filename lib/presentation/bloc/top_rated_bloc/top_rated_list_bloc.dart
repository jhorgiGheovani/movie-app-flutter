import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_event.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc/top_rated_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedListBloc extends Bloc<TopRatedListEvent, TopRatedListState> {
  final GetTopRatedMovies _getTopRatedMovies;
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TopRatedListBloc(this._getTopRatedMovies, this._getTopRatedTvSeries)
      : super(TopRatedEmptyState()) {
    on<FetchTopRatedMovie>((event, emit) async {
      emit(TopRatedLoadingState());
      final result = await _getTopRatedMovies.execute();

      result.fold((failure) {
        emit(TopRatedErrorState(failure.message));
      }, (data) {
        emit(TopRatedLoadedMovieState(data));
      });
    });

    on<FetchTopRatedTvSeries>((event, emit) async {
      //loading
      emit(TopRatedLoadingState());
      final result = await _getTopRatedTvSeries.execute();

      result.fold((failure) {
        emit(TopRatedErrorState(failure.message));
      }, (data) {
        emit(TopRatedLoadedTvSeriesState(data));
      });
    });
  }
}
