import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';
import 'package:petitpotopro/features/tournoi/domain/repository/tournoi_repository.dart';

class TournoiUseCase
    implements UseCase<Either<Failure, List<TournoiEntity>>, NoParams> {
  const TournoiUseCase(this._repository);

  final TournoiRepository _repository;

  @override
  Future<Either<Failure, List<TournoiEntity>>> call(NoParams params) =>
      _repository.getAll();
}
