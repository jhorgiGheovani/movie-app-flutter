import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_event.dart';
import 'package:ditonton/presentation/bloc/popular_bloc/popular_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularListBloc extends Bloc<PopularListEvent, PopularListState> {
  final GetPopularMovies _getPopularMovies;
  final GetPopulartTvSeries _getPopulartTvSeries;

  PopularListBloc(this._getPopularMovies, this._getPopulartTvSeries)
      : super(PopularListResultEmpty()) {
    on<FetchPopularMovie>((event, emit) async {
      emit(PopularListResultLoading());
      final result = await _getPopularMovies.execute();

      result.fold((failure) {
        emit(PopularListResultError(failure.message));
      }, (data) {
        emit(PopularListResultLoadedMovie(data));
      });
    });

    on<FetchPopularTvSeries>((event, emit) async {
      //loading
      emit(PopularListResultLoading());
      final result = await _getPopulartTvSeries.execute();

      result.fold((failure) {
        emit(PopularListResultError(failure.message));
      }, (data) {
        emit(PopularListResultLoadedTvSeries(data));
      });
    });
  }
}
