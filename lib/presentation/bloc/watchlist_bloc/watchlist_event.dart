import 'package:ditonton/domain/entities/detail_entity.dart';
import 'package:equatable/equatable.dart';

abstract class WatchListEvent extends Equatable {
  WatchListEvent();

  @override
  List<Object> get props => [];
}

class AddItemToWatchlist extends WatchListEvent {
  final DetailEntity item;
  final String type;

  AddItemToWatchlist(this.item, this.type);

  @override
  List<Object> get props => [item];
}

class RemoveMovieFromWatchlist extends WatchListEvent {
  final DetailEntity item;
  final String type;
  RemoveMovieFromWatchlist(this.item, this.type);

  @override
  List<Object> get props => [item];
}

class CheckMovieWatchlistStatus extends WatchListEvent {
  final int id;
  CheckMovieWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class CheckTvSeriesWatchlistStatus extends WatchListEvent {
  final int id;
  CheckTvSeriesWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class GetMovieWatchList extends WatchListEvent {}

class GetTvSeriesWatchList extends WatchListEvent {}
