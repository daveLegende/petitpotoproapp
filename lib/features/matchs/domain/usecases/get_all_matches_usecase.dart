import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';
import 'package:petitpotopro/features/matchs/domain/repository/match_repository.dart';

class GetAllMatchesUseCase
    implements UseCase<Either<Failure, List<MatchEntity>>, String> {
  const GetAllMatchesUseCase(this._repository);

  final MatchRepository _repository;

  @override
  Future<Either<Failure, List<MatchEntity>>> call(String tournoiId) =>
      _repository.getAll(tournoiId);
}
