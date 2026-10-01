import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/tickets/domain/entities/ticket_purchase.dart';
import 'package:petitpotopro/features/tickets/domain/repository/user_ticket_repository.dart';

class PurchaseTicketUseCase
    implements UseCase<Either<Failure, Unit>, TicketPurchase> {
  const PurchaseTicketUseCase(this._repository);

  final UserTicketRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(TicketPurchase params) =>
      _repository.purchase(params);
}
