import 'package:equatable/equatable.dart';
import 'package:petitpotopro/features/player/domain/entities/player_entity.dart';

class TeamEntity extends Equatable {
  const TeamEntity({
    required this.id,
    required this.name,
    required this.inscriptions,
    this.coach,
    this.commune,
    this.logo,
    this.points = 0,
    this.matchJoues = 0,
    this.butMarques = 0,
    this.butConcedes = 0,
  });

  final String id;
  final String name;
  final String? coach;
  final String? commune;
  final String? logo;
  final int points;
  final int matchJoues;
  final int butMarques;
  final int butConcedes;
  final List<PlayerRegistrationEntity> inscriptions;

  @override
  List<Object?> get props => [
    id,
    name,
    coach,
    commune,
    logo,
    points,
    matchJoues,
    butMarques,
    butConcedes,
    inscriptions,
  ];
}
