//state: loading, loaded, error, empty

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class TopRatedListState extends Equatable {
  const TopRatedListState();

  @override
  List<Object> get props => [];
}

class TopRatedEmptyState extends TopRatedListState {}

class TopRatedLoadingState extends TopRatedListState {}

class TopRatedErrorState extends TopRatedListState {
  final String message;

  TopRatedErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedLoadedMovieState extends TopRatedListState {
  final List<Movie> result;

  TopRatedLoadedMovieState(this.result);

  @override
  List<Object> get props => [result];
}

class TopRatedLoadedTvSeriesState extends TopRatedListState {
  final List<TvSeries> result;

  TopRatedLoadedTvSeriesState(this.result);

  @override
  List<Object> get props => [result];
}

class TopRatedUnknownState extends TopRatedListState {}
