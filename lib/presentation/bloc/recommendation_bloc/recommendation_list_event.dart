import 'package:equatable/equatable.dart';

class RecommendationListEvent extends Equatable {
  const RecommendationListEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieRecommendation extends RecommendationListEvent {
  final int id;
  FetchMovieRecommendation(this.id);
  @override
  List<Object> get props => [id];
}

class FetchTvSeriesRecommendation extends RecommendationListEvent {
  final int id;
  FetchTvSeriesRecommendation(this.id);
  @override
  List<Object> get props => [id];
}
