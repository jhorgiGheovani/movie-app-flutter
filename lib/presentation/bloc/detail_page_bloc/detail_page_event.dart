import 'package:equatable/equatable.dart';

class DetailPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends DetailPageEvent {
  final int id;
  FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class FetchTvSeriesDetail extends DetailPageEvent {
  final int id;
  FetchTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

// class CheckMovieWatchlistStatus extends DetailPageEvent {
//   final int id;
//   CheckMovieWatchlistStatus(this.id);

//   @override
//   List<Object> get props => [id];
// }
