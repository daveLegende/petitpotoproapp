import 'package:petitpotopro/features/player/data/models/player_model.dart';
import 'package:petitpotopro/features/team/domain/entities/team_entity.dart';

class TeamModel extends TeamEntity {
  const TeamModel({
    required super.id,
    required super.name,
    required super.inscriptions,
    super.coach,
    super.commune,
    super.logo,
    super.points,
    super.matchJoues,
    super.butMarques,
    super.butConcedes,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    final rawInscriptions = json['inscriptions'];
    return TeamModel(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      coach: json['coach'] as String?,
      commune: json['commune'] as String?,
      logo: json['logo'] as String?,
      points: _integer(json['points']),
      matchJoues: _integer(json['matchJoues']),
      butMarques: _integer(json['butMarques']),
      butConcedes: _integer(json['butConcedes']),
      inscriptions: rawInscriptions is List
          ? rawInscriptions.map(_registration).toList(growable: false)
          : const [],
    );
  }

  static PlayerRegistrationModel _registration(dynamic value) {
    if (value is! Map) {
      throw const FormatException('Inscription invalide dans une équipe.');
    }
    return PlayerRegistrationModel.fromJson(Map<String, dynamic>.from(value));
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value;
    throw FormatException('Champ "$key" invalide dans la réponse équipe.');
  }

  static int _integer(dynamic value) => value is num ? value.toInt() : 0;
}
