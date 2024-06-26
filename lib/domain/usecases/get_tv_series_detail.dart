import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/detail_entity.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvSeriesDetail {
  final TvSeriesRepository repository;

  GetTvSeriesDetail(this.repository);

  Future<Either<Failure, DetailEntity>> execute(int id) {
    return repository.getTvSeriesDetail(id);
  }
}
