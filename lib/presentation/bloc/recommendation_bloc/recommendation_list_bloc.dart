import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_event.dart';
import 'package:ditonton/presentation/bloc/recommendation_bloc/recommendation_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendationListBloc
    extends Bloc<RecommendationListEvent, RecommendationListState> {
  final GetMovieRecommendations _getMovieRecommendations;
  final GetTvSeriesRecommendations _getTvSeriesRecommendations;

  RecommendationListBloc(
      this._getMovieRecommendations, this._getTvSeriesRecommendations)
      : super(RecommendationEmptyState()) {
    on<FetchMovieRecommendation>((event, emit) async {
      final id = event.id;

      emit(RecommendationLoadingState());
      final result = await _getMovieRecommendations.execute(id);

      result.fold((failure) {
        emit(RecommendationErrorState(failure.message));
      }, (data) {
        emit(RecommendationLoadedMovieState(data));
      });
    });

    on<FetchTvSeriesRecommendation>((event, emit) async {
      final id = event.id;

      emit(RecommendationLoadingState());
      final result = await _getTvSeriesRecommendations.execute(id);

      result.fold((failure) {
        emit(RecommendationErrorState(failure.message));
      }, (data) {
        emit(RecommendationLoadedTvSeriesState(data));
      });
    });
  }
}
