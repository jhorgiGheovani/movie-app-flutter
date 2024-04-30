import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movie_bloc/get_watchlist_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetWatchListMovieBloc
    extends Bloc<GetWatchListEvent, GetWatchListMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;

  GetWatchListMovieBloc(this._getWatchlistMovies)
      : super(GetWatchlistMovieEmptyState()) {
    on<GetWatchListMovie>((event, emit) async {
      emit(GetWatchlistMovieLoadingState());
      final result = await _getWatchlistMovies.execute();

      result.fold((failure) {
        emit(GetWatchlistMovieErrorState(failure.message));
      }, (data) {
        emit(GetWatchlistLoadedMovieState(data));
      });
    });
  }
}
