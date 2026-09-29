import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';

abstract class MatchRepository {
  Future<Either<Failure, List<MatchEntity>>> getAll(String tournoiId);
}
