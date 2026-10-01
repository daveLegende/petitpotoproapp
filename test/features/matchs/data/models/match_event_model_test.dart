import 'package:flutter_test/flutter_test.dart';
import 'package:petitpotopro/features/matchs/data/models/match_event_model.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_event_entity.dart';

void main() {
  test('maps nested match event details', () {
    final event = MatchEventModel.fromJson({
      'type': 'BUT',
      'minute': 37,
      'description': 'Frappe du pied droit',
      'player': {'firstname': 'Afi', 'lastname': 'Mensah'},
      'team': {'name': 'Étoile FC'},
    });

    expect(event, isA<MatchEventEntity>());
    expect(event.type, 'BUT');
    expect(event.minute, '37');
    expect(event.playerName, 'Afi Mensah');
    expect(event.teamName, 'Étoile FC');
    expect(event.description, 'Frappe du pied droit');
  });
}
