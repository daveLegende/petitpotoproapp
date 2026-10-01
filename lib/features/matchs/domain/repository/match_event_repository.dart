import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_event_entity.dart';

abstract class MatchEventRepository {
  Future<Either<Failure, List<MatchEventEntity>>> getForMatch({
    required String matchId,
    required String tournoiId,
  });
}
