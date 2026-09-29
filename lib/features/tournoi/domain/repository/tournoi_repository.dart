import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';

abstract class TournoiRepository {
  Future<Either<Failure, List<TournoiEntity>>> getAll();
}
