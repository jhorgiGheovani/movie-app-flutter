import 'package:equatable/equatable.dart';

class NowPlayingListEvent extends Equatable {
  const NowPlayingListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTvSeries extends NowPlayingListEvent {}

class FetchNowPlayingMovie extends NowPlayingListEvent {}
