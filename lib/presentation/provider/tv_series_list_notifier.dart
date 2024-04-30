import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/cupertino.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  TvSeriesListNotifier(
      {required this.getPopulartTvSeries,
      required this.getTopRatedTvSeries,
      required this.getNowPlayingTvSeries});

  //Popular Tv Series
  var _popularTvSeries = <TvSeries>[];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  RequestState _popularTvSeriesState = RequestState.Empty;
  RequestState get popularTvSeriesState => _popularTvSeriesState;

  //Top Rated Tv Series
  var _topRatedTvSeries = <TvSeries>[];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedTvSeriesState = RequestState.Empty;
  RequestState get topRatedTvSeriesState => _topRatedTvSeriesState;

  //Now Playing Tv Series
  var _nowPlayingTvSeries = <TvSeries>[];
  List<TvSeries> get nowPlayingTvSeries => _nowPlayingTvSeries;

  RequestState _nowPlayingTvSeriesState = RequestState.Empty;
  RequestState get nowPlayingTvSeriesState => _nowPlayingTvSeriesState;

  String _message = '';
  String get message => _message;
  final GetPopulartTvSeries getPopulartTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  Future<void> fetchPopularTvSeries() async {
    _popularTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopulartTvSeries.execute();
    result.fold((failure) {
      _popularTvSeriesState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _popularTvSeriesState = RequestState.Loaded;
      _popularTvSeries = tvSeriesData;
      notifyListeners();
    });
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold((failure) {
      _topRatedTvSeriesState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _topRatedTvSeriesState = RequestState.Loaded;
      _topRatedTvSeries = tvSeriesData;
      notifyListeners();
    });
  }

  Future<void> fetchNowPlayingTvSeries() async {
    _nowPlayingTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvSeries.execute();
    result.fold((failure) {
      _nowPlayingTvSeriesState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _nowPlayingTvSeriesState = RequestState.Loaded;
      _nowPlayingTvSeries = tvSeriesData;
      notifyListeners();
    });
  }
}
