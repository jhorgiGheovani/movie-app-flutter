import 'package:ditonton/domain/entities/detail_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DetailPageState extends Equatable {
  const DetailPageState();

  @override
  List<Object> get props => [];
}

class DetailPageEmptyState extends DetailPageState {}

class DetailPageLoadingState extends DetailPageState {}

class DetailPageErrorState extends DetailPageState {
  final String message;

  DetailPageErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class DetailPageLoadedState extends DetailPageState {
  final DetailEntity result;
  // final bool status;

  DetailPageLoadedState(this.result);

  @override
  List<Object> get props => [result];
}

// class StatusState extends DetailPageState {
//   final bool status;

//   StatusState(this.status);
//   @override
//   List<Object> get props => [status];
// }
