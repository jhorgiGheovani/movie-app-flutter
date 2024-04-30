import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_event.dart';
import 'package:ditonton/presentation/bloc/detail_page_bloc/detail_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPageBloc extends Bloc<DetailPageEvent, DetailPageState> {
  final GetMovieDetail _getMovieDetail;
  final GetTvSeriesDetail _getTvSeriesDetail;

  DetailPageBloc(this._getMovieDetail, this._getTvSeriesDetail)
      : super(DetailPageEmptyState()) {
    on<FetchMovieDetail>((event, emit) async {
      final id = event.id;

      emit(DetailPageLoadingState());
      final result = await _getMovieDetail.execute(id);
      result.fold((failure) {
        emit(DetailPageErrorState(failure.message));
      }, (data) {
        emit(DetailPageLoadedState(data));
      });
    });

    on<FetchTvSeriesDetail>((event, emit) async {
      final id = event.id;

      emit(DetailPageLoadingState());
      final result = await _getTvSeriesDetail.execute(id);
      result.fold((failure) {
        emit(DetailPageErrorState(failure.message));
      }, (data) {
        emit(DetailPageLoadedState(data));
      });
    });
  }
}
