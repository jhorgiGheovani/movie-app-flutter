import 'package:equatable/equatable.dart';

class TopRatedListEvent extends Equatable {
  const TopRatedListEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTvSeries extends TopRatedListEvent {}

class FetchTopRatedMovie extends TopRatedListEvent {}
