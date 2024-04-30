// part of 'search_bloc.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchMovieHasData extends SearchState {
  final List<Movie> result;

  SearchMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}

class SearchTvSeriesHasData extends SearchState {
  final List<TvSeries> result;

  SearchTvSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
