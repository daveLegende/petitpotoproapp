import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/errors/guard.dart';
import 'package:petitpotopro/features/tournoi/data/datasources/tournoi_remote_data_source.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';
import 'package:petitpotopro/features/tournoi/domain/repository/tournoi_repository.dart';

class TournoiRepositoryImpl implements TournoiRepository {
  const TournoiRepositoryImpl(this._remoteDataSource);

  final TournoiRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<TournoiEntity>>> getAll() =>
      guard<List<TournoiEntity>>(() async {
        final tournois = await _remoteDataSource.getAll();
        return tournois.map((tournoi) => tournoi.toEntity()).toList();
      });
}
