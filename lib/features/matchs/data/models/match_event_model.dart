import 'package:petitpotopro/features/matchs/domain/entities/match_event_entity.dart';

class MatchEventModel extends MatchEventEntity {
  const MatchEventModel({
    required super.type,
    super.minute,
    super.description,
    super.playerName,
    super.teamName,
  });

  factory MatchEventModel.fromJson(Map<String, dynamic> json) {
    return MatchEventModel(
      type:
          _readText(json['type'] ?? json['event'] ?? json['action']) ??
          'Événement',
      minute: _readText(json['minute'] ?? json['min'] ?? json['time']),
      description: _readText(
        json['description'] ??
            json['details'] ??
            json['detail'] ??
            json['label'],
      ),
      playerName: _readName(json['player'] ?? json['joueur'] ?? json['scorer']),
      teamName: _readName(json['team'] ?? json['equipe']),
    );
  }

  static String? _readName(dynamic value) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final first = _readText(map['firstname'] ?? map['firstName']);
      final last = _readText(map['lastname'] ?? map['lastName']);
      if (first != null && last != null) return '$first $last';
      return _readText(
        map['name'] ?? map['nom'] ?? map['fullName'] ?? map['fullname'],
      );
    }
    return _readText(value);
  }

  static String? _readText(dynamic value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value is num) return '$value';
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return _readText(map['name'] ?? map['nom'] ?? map['minute']);
    }
    return null;
  }
}
