import 'package:flutter_test/flutter_test.dart';
import 'package:petitpotopro/features/tickets/data/models/user_ticket_model.dart';

void main() {
  test("maps a user's ticket fields", () {
    final ticket = UserTicketModel.fromJson({
      '_id': 'ticket-1',
      'type': 'VIP',
      'duree': 'TOURNOI COMPLET',
      'etat': 'VALIDE',
      'position': 'ENTREE',
      'amount': 2500,
      'date': '2026-09-28T12:00:00.000Z',
      'matchs': ['match-1', 'match-2'],
    });

    expect(ticket.id, 'ticket-1');
    expect(ticket.type, 'VIP');
    expect(ticket.duration, 'TOURNOI COMPLET');
    expect(ticket.matchCount, 2);
    expect(ticket.amount, 2500);
  });
}