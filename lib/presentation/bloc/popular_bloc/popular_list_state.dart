//state: loading, loaded, error, empty

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class PopularListState extends Equatable {
  const PopularListState();

  @override
  List<Object> get props => [];
}

class PopularListResultEmpty extends PopularListState {}

class PopularListResultLoading extends PopularListState {}

class PopularListResultError extends PopularListState {
  final String message;

  PopularListResultError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularListResultLoadedMovie extends PopularListState {
  final List<Movie> result;

  PopularListResultLoadedMovie(this.result);

  @override
  List<Object> get props => [result];
}

class PopularListResultLoadedTvSeries extends PopularListState {
  final List<TvSeries> result;

  PopularListResultLoadedTvSeries(this.result);

  @override
  List<Object> get props => [result];
}

class PopularListUnknownState extends PopularListState {}
