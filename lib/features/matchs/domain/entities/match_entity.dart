import 'package:equatable/equatable.dart';
import 'package:petitpotopro/features/bet/domain/entities/bet_entity.dart';
import 'package:petitpotopro/features/score/domain/entities/score_entity.dart';
import 'package:petitpotopro/features/team/domain/entities/team_entity.dart';

class MatchEntity extends Equatable {
  const MatchEntity({
    required this.id,
    required this.type,
    required this.lieu,
    required this.etat,
    required this.journee,
    required this.date,
    required this.home,
    required this.away,
    required this.scores,
    required this.bets,
    required this.isProlongation,
    required this.isTirAuxButs,
    required this.homePenalty,
    required this.awayPenalty,
    this.teamQualify,
    this.referee,
  });

  final String id;
  final String type;
  final String etat;
  final String lieu;
  final int journee;
  final DateTime date;
  final TeamEntity home;
  final TeamEntity away;
  final ScoreEntity scores;
  final List<BetEntity> bets;
  final bool isProlongation;
  final bool isTirAuxButs;
  final int homePenalty;
  final int awayPenalty;
  final String? teamQualify;
  final String? referee;

  @override
  List<Object?> get props => [
    id,
    type,
    lieu,
    etat,
    journee,
    date,
    home,
    away,
    scores,
    bets,
    isProlongation,
    isTirAuxButs,
    homePenalty,
    awayPenalty,
    teamQualify,
    referee,
  ];
}
