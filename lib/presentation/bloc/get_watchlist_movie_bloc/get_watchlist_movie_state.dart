import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class GetWatchListMovieState extends Equatable {
  const GetWatchListMovieState();
  @override
  List<Object> get props => [];
}

class GetWatchlistMovieEmptyState extends GetWatchListMovieState {}

class GetWatchlistMovieLoadingState extends GetWatchListMovieState {}

class GetWatchlistMovieErrorState extends GetWatchListMovieState {
  final String message;

  GetWatchlistMovieErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class GetWatchlistLoadedMovieState extends GetWatchListMovieState {
  final List<Movie> result;

  GetWatchlistLoadedMovieState(this.result);

  @override
  List<Object> get props => [result];
}

// class GetWatchlistLoadedTvSeriesState extends GetWatchListMovieState {
//   final List<TvSeries> result;

//   GetWatchlistLoadedTvSeriesState(this.result);

//   @override
//   List<Object> get props => [result];
// }
