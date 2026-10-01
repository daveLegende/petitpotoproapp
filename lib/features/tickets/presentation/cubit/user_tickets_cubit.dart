import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/tickets/domain/entities/ticket_purchase.dart';
import 'package:petitpotopro/features/tickets/domain/entities/user_ticket.dart';
import 'package:petitpotopro/features/tickets/domain/usecases/get_user_tickets_usecase.dart';
import 'package:petitpotopro/features/tickets/domain/usecases/purchase_ticket_usecase.dart';

class UserTicketsState {
  const UserTicketsState({
    this.tickets = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final List<UserTicket> tickets;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
}

class UserTicketsCubit extends Cubit<UserTicketsState> {
  UserTicketsCubit(this._getTickets, this._purchaseTicket)
    : super(const UserTicketsState());

  final GetUserTicketsUseCase _getTickets;
  final PurchaseTicketUseCase _purchaseTicket;

  Future<void> load() async {
    emit(UserTicketsState(tickets: state.tickets, isLoading: true));
    final result = await _getTickets(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        UserTicketsState(tickets: state.tickets, errorMessage: failure.message),
      ),
      (tickets) => emit(UserTicketsState(tickets: tickets)),
    );
  }

  Future<bool> purchase(TicketPurchase ticket) async {
    emit(UserTicketsState(tickets: state.tickets, isSubmitting: true));
    final result = await _purchaseTicket(ticket);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(
          UserTicketsState(
            tickets: state.tickets,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (_) {
        emit(UserTicketsState(tickets: state.tickets));
        load();
        return true;
      },
    );
  }
}
