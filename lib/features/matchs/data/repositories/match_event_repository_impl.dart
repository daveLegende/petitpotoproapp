import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/errors/guard.dart';
import 'package:petitpotopro/features/matchs/data/datasources/match_event_remote_data_source.dart';
import 'package:petitpotopro/features/matchs/data/models/match_event_model.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_event_entity.dart';
import 'package:petitpotopro/features/matchs/domain/repository/match_event_repository.dart';

class MatchEventRepositoryImpl implements MatchEventRepository {
  const MatchEventRepositoryImpl(this._remoteDataSource);

  final MatchEventRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<MatchEventEntity>>> getForMatch({
    required String matchId,
    required String tournoiId,
  }) => guard<List<MatchEventEntity>>(() async {
    final rows = await _remoteDataSource.getForMatch(
      matchId: matchId,
      tournoiId: tournoiId,
    );
    return rows.map(MatchEventModel.fromJson).toList(growable: false);
  });
}
