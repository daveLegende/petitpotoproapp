import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/tickets/domain/entities/user_ticket.dart';
import 'package:petitpotopro/features/tickets/domain/repository/user_ticket_repository.dart';

class GetUserTicketsUseCase
    implements UseCase<Either<Failure, List<UserTicket>>, NoParams> {
  const GetUserTicketsUseCase(this._repository);

  final UserTicketRepository _repository;

  @override
  Future<Either<Failure, List<UserTicket>>> call(NoParams params) =>
      _repository.getHistory();
}
