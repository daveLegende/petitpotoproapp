import 'package:flutter_test/flutter_test.dart';
import 'package:petitpotopro/features/bet/domain/entities/bet_entity.dart';
import 'package:petitpotopro/features/matchs/data/models/match_model.dart';
import 'package:petitpotopro/features/player/domain/entities/player_entity.dart';
import 'package:petitpotopro/features/score/domain/entities/score_entity.dart';
import 'package:petitpotopro/features/team/domain/entities/team_entity.dart';

void main() {
  test('maps match teams, player inscriptions, and score', () {
    final match = MatchModel.fromJson({
      'id': 'match-1',
      'type': 'PHASE DE POULE',
      'lieu': 'Stade municipal',
      'etat': 'EN_COURS',
      'journee': 1,
      'date': '2026-09-01T15:00:00.000Z',
      'home': {
        'id': 'team-home',
        'name': 'Étoile FC',
        'inscriptions': [
          {
            'id': 'registration-1',
            'numeroMaillot': 10,
            'poste': 'ATTAQUANT',
            'buts': 2,
            'passes': 1,
            'statut': 'ACTIF',
            'player': {
              'id': 'player-1',
              'name': 'Koffi Mensah',
              'age': 22,
              'phone': '+22890000000',
              'avatar': 'https://example.com/player.svg',
            },
          },
        ],
      },
      'away': {'id': 'team-away', 'name': 'Dynamique FC'},
      'scores': {'home': 2, 'away': 1},
      'bets': [
        {
          'id': 'bet-1',
          'category': 'MATCH_RESULT',
          'odds': {'V1': 1.85, 'X': 3.2, 'V2': 4.1},
          'isActive': true,
          'closedAt': null,
        },
      ],
      'isProlongation': false,
      'isTirAuxButs': false,
    });

    expect(match.home, isA<TeamEntity>());
    expect(match.home.inscriptions.single, isA<PlayerRegistrationEntity>());
    expect(match.home.inscriptions.single.player, isA<PlayerEntity>());
    expect(match.home.inscriptions.single.player.name, 'Koffi Mensah');
    expect(match.home.inscriptions.single.numeroMaillot, 10);
    expect(match.scores, isA<ScoreEntity>());
    expect(match.scores.home, 2);
    expect(match.scores.away, 1);
    expect(match.bets.single, isA<BetEntity>());
    expect(match.bets.single.category, 'MATCH_RESULT');
    expect(match.bets.single.odds['V1'], 1.85);
  });
}
