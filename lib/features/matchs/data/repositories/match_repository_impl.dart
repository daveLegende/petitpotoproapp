import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/errors/guard.dart';
import 'package:petitpotopro/features/matchs/data/datasources/match_remote_data_source.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';
import 'package:petitpotopro/features/matchs/domain/repository/match_repository.dart';

class MatchRepositoryImpl implements MatchRepository {
  const MatchRepositoryImpl(this._remoteDataSource);

  final MatchRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<MatchEntity>>> getAll(String tournoiId) =>
      guard<List<MatchEntity>>(() async {
        final matches = await _remoteDataSource.getAll(tournoiId);
        return matches;
      });
}
