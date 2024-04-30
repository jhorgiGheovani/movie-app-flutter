import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class RecommendationListState extends Equatable {
  const RecommendationListState();

  @override
  List<Object> get props => [];
}

class RecommendationEmptyState extends RecommendationListState {}

class RecommendationLoadingState extends RecommendationListState {}

class RecommendationErrorState extends RecommendationListState {
  final String message;

  RecommendationErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationLoadedMovieState extends RecommendationListState {
  final List<Movie> result;

  RecommendationLoadedMovieState(this.result);

  @override
  List<Object> get props => [result];
}

class RecommendationLoadedTvSeriesState extends RecommendationListState {
  final List<TvSeries> result;

  RecommendationLoadedTvSeriesState(this.result);

  @override
  List<Object> get props => [result];
}
