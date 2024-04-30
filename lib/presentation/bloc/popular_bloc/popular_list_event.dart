import 'package:equatable/equatable.dart';

class PopularListEvent extends Equatable {
  const PopularListEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvSeries extends PopularListEvent {}

class FetchPopularMovie extends PopularListEvent {}
