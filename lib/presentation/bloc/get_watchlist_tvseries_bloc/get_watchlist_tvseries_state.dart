import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class GetWatchTvSeriesListState extends Equatable {
  const GetWatchTvSeriesListState();
  @override
  List<Object> get props => [];
}

class GetWatchlistTvSeriesEmptyState extends GetWatchTvSeriesListState {}

class GetWatchlistTvSeriesLoadingState extends GetWatchTvSeriesListState {}

class GetWatchlistTvSeriesErrorState extends GetWatchTvSeriesListState {
  final String message;

  GetWatchlistTvSeriesErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class GetWatchlistLoadedTvSeriesState extends GetWatchTvSeriesListState {
  final List<TvSeries> result;

  GetWatchlistLoadedTvSeriesState(this.result);

  @override
  List<Object> get props => [result];
}
