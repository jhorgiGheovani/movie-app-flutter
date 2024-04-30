import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistState extends Equatable {
  WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchListEmptyState extends WatchlistState {}

class WatchlistSuccessState extends WatchlistState {
  final String message;
  // final bool status;

  WatchlistSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistFailedState extends WatchlistState {
  final String message;

  WatchlistFailedState(this.message);

  @override
  List<Object> get props => [message];
}

class StatusState extends WatchlistState {
  final bool status;

  StatusState(this.status);
  @override
  List<Object> get props => [status];
}

class MovieWatchListLoadedState extends WatchlistState {
  final List<Movie> result;

  MovieWatchListLoadedState(this.result);
  @override
  List<Object> get props => [result];
}

class TvSeriesWatchListLoadedState extends WatchlistState {
  final List<TvSeries> result;

  TvSeriesWatchListLoadedState(this.result);
  @override
  List<Object> get props => [result];
}
