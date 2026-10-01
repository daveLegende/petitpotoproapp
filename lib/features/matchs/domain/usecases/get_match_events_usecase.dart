import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_event_entity.dart';
import 'package:petitpotopro/features/matchs/domain/repository/match_event_repository.dart';

class MatchEventsParams {
  const MatchEventsParams({required this.matchId, required this.tournoiId});

  final String matchId;
  final String tournoiId;
}

class GetMatchEventsUseCase
    implements
        UseCase<Either<Failure, List<MatchEventEntity>>, MatchEventsParams> {
  const GetMatchEventsUseCase(this._repository);

  final MatchEventRepository _repository;

  @override
  Future<Either<Failure, List<MatchEventEntity>>> call(
    MatchEventsParams params,
  ) => _repository.getForMatch(
    matchId: params.matchId,
    tournoiId: params.tournoiId,
  );
}
