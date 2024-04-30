import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/detail_entity.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class MovieTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String? type;

  MovieTable(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.overview,
      required this.type});

  factory MovieTable.fromEntity(DetailEntity movie, String type) => MovieTable(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      type: type);

  //use to get data from db
  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      overview: map['overview'],
      type: map['type']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'type': type
      };

  Movie toEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );
  TvSeries toEntityTv() => TvSeries.watchlist(
      id: id, overview: overview, posterPath: posterPath, name: title);

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview];
}
