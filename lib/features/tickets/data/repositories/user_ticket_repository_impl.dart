import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/errors/guard.dart';
import 'package:petitpotopro/core/network/api_dto.dart';
import 'package:petitpotopro/features/tickets/data/datasources/user_ticket_remote_data_source.dart';
import 'package:petitpotopro/features/tickets/domain/entities/ticket_purchase.dart';
import 'package:petitpotopro/features/tickets/domain/entities/user_ticket.dart';
import 'package:petitpotopro/features/tickets/domain/repository/user_ticket_repository.dart';

class UserTicketRepositoryImpl implements UserTicketRepository {
  const UserTicketRepositoryImpl(this._remoteDataSource);

  final UserTicketRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<UserTicket>>> getHistory() =>
      guard<List<UserTicket>>(() async => _remoteDataSource.getMine());

  @override
  Future<Either<Failure, Unit>> purchase(TicketPurchase ticket) =>
      guard<Unit>(() async {
        await _remoteDataSource.purchase(
          TicketAccountDto(
            type: TicketType.values.firstWhere(
              (value) => value.value == ticket.type,
            ),
            duree: TicketDuree.values.firstWhere(
              (value) => value.value == ticket.duration,
            ),
            user: ticket.userId,
            amount: ticket.amount,
            matchs: ticket.matchIds,
            etat: TicketEtat.valide,
            isDeleted: false,
          ),
        );
        return unit;
      });
}
