import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/features/tickets/domain/entities/ticket_purchase.dart';
import 'package:petitpotopro/features/tickets/domain/entities/user_ticket.dart';

abstract class UserTicketRepository {
  Future<Either<Failure, List<UserTicket>>> getHistory();
  Future<Either<Failure, Unit>> purchase(TicketPurchase ticket);
}
