import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/detail_entity.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, DetailEntity>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
