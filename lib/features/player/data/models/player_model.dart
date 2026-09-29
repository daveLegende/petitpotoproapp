import 'package:petitpotopro/features/player/domain/entities/player_entity.dart';

class PlayerModel extends PlayerEntity {
  const PlayerModel({
    required super.id,
    required super.name,
    super.age,
    super.phone,
    super.avatar,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
    id: _string(json, 'id'),
    name: _string(json, 'name'),
    age: _optionalInt(json['age']),
    phone: json['phone'] as String?,
    avatar: json['avatar'] as String?,
  );

  static String _string(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value;
    throw FormatException('Champ "$key" invalide dans la réponse joueur.');
  }

  static int? _optionalInt(dynamic value) =>
      value is num ? value.toInt() : null;
}

class PlayerRegistrationModel extends PlayerRegistrationEntity {
  const PlayerRegistrationModel({
    required super.id,
    required super.numeroMaillot,
    required super.poste,
    required super.buts,
    required super.passes,
    required super.statut,
    required super.player,
  });

  factory PlayerRegistrationModel.fromJson(Map<String, dynamic> json) {
    final rawPlayer = json['player'];
    if (rawPlayer is! Map) {
      throw const FormatException('Joueur introuvable dans son inscription.');
    }
    return PlayerRegistrationModel(
      id: PlayerModel._string(json, 'id'),
      numeroMaillot: _int(json['numeroMaillot'], 'numeroMaillot'),
      poste: PlayerModel._string(json, 'poste'),
      buts: _int(json['buts'], 'buts', fallback: 0),
      passes: _int(json['passes'], 'passes', fallback: 0),
      statut: PlayerModel._string(json, 'statut'),
      player: PlayerModel.fromJson(Map<String, dynamic>.from(rawPlayer)),
    );
  }

  static int _int(dynamic value, String key, {int? fallback}) {
    if (value is num) return value.toInt();
    if (fallback != null) return fallback;
    throw FormatException('Champ "$key" invalide dans une inscription joueur.');
  }
}
