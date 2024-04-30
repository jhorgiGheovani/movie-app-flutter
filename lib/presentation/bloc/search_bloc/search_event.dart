import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

//observe on query change
class OnQueryChangedMovie extends SearchEvent {
  final String query;

  OnQueryChangedMovie(this.query);

  @override
  List<Object> get props => [query];
}

class OnQueryChangedTvSeries extends SearchEvent {
  final String query;

  OnQueryChangedTvSeries(this.query);

  @override
  List<Object> get props => [query];
}
