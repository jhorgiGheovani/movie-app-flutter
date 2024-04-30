//state: loading, loaded, error, empty

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class NowPlayingListState extends Equatable {
  const NowPlayingListState();

  @override
  List<Object> get props => [];
}

class NowPlayingListResultEmpty extends NowPlayingListState {}

class NowPlayingListResultLoading extends NowPlayingListState {}

class NowPlayingListResultError extends NowPlayingListState {
  final String message;

  NowPlayingListResultError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingListResultLoadedMovie extends NowPlayingListState {
  final List<Movie> result;

  NowPlayingListResultLoadedMovie(this.result);

  @override
  List<Object> get props => [result];
}

class NowPlayingListResultLoadedTvSeries extends NowPlayingListState {
  final List<TvSeries> result;

  NowPlayingListResultLoadedTvSeries(this.result);

  @override
  List<Object> get props => [result];
}

class NowPlayingUnknownState extends NowPlayingListState {}
