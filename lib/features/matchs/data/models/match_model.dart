import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';
import 'package:petitpotopro/features/bet/data/models/bet_model.dart';
import 'package:petitpotopro/features/score/data/models/score_model.dart';
import 'package:petitpotopro/features/team/data/models/team_model.dart';

class MatchModel extends MatchEntity {
  const MatchModel({
    required super.id,
    required super.type,
    required super.lieu,
    required super.etat,
    required super.journee,
    required super.date,
    required super.home,
    required super.away,
    required super.scores,
    required super.bets,
    required super.isProlongation,
    required super.isTirAuxButs,
    required super.homePenalty,
    required super.awayPenalty,
    super.teamQualify,
    super.referee,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final rawScores = _asMap(json['scores']);
    final rawBets = json['bets'];

    return MatchModel(
      id: _requiredString(json, 'id'),
      type: _requiredString(json, 'type'),
      lieu: _requiredString(json, 'lieu'),
      etat: _requiredString(json, 'etat'),
      journee: _requiredInt(json, 'journee'),
      date: _requiredDate(json, 'date'),
      home: TeamModel.fromJson(_requiredMap(json['home'], 'home')),
      away: TeamModel.fromJson(_requiredMap(json['away'], 'away')),
      scores: ScoreModel.fromJson(rawScores ?? const {}),
      bets: rawBets is List
          ? rawBets
                .map((bet) => BetModel.fromJson(_requiredMap(bet, 'bet')))
                .toList(growable: false)
          : const [],
      isProlongation: _boolValue(json['isProlongation']),
      isTirAuxButs: _boolValue(json['isTirAuxButs']),
      homePenalty: _intValue(json['homePenalty'], 'homePenalty', fallback: 0),
      awayPenalty: _intValue(json['awayPenalty'], 'awayPenalty', fallback: 0),
      teamQualify: json['teamQualify'] as String?,
      referee:
          _readReferee(json['referee']) ??
          _readPopulatedReferee(json['arbitre'] ?? json['arbitres']),
    );
  }

  static String? _readReferee(dynamic value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return _readPopulatedReferee(value);
  }

  static String? _readPopulatedReferee(dynamic value) {
    if (value is List) {
      final names = value
          .map(_readPopulatedReferee)
          .whereType<String>()
          .toList(growable: false);
      return names.isEmpty ? null : names.join(', ');
    }
    if (value is Map) {
      final json = _asMap(value)!;
      final first = json['firstname'] ?? json['firstName'];
      final last = json['lastname'] ?? json['lastName'];
      if (first is String && last is String) return '$first $last';
      for (final key in [
        'nom de la Arbitre',
        'nomDeLaArbitre',
        'name',
        'nom',
        'fullName',
      ]) {
        final name = json[key];
        if (name is String && name.trim().isNotEmpty) return name.trim();
      }
      return null;
    }
    return null;
  }

  static Map<String, dynamic>? _asMap(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : null;

  static Map<String, dynamic> _requiredMap(dynamic value, String key) {
    final map = _asMap(value);
    if (map != null) return map;
    throw FormatException('Objet "$key" invalide dans la réponse match.');
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value;
    throw FormatException('Champ "$key" invalide dans la réponse match.');
  }

  static int _requiredInt(Map<String, dynamic> json, String key) =>
      _intValue(json[key], key);

  static int _intValue(dynamic value, String key, {int? fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (fallback != null) return fallback;
    throw FormatException('Champ "$key" invalide dans la réponse match.');
  }

  static DateTime _requiredDate(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Champ "$key" invalide dans la réponse match.');
  }

  static bool _boolValue(dynamic value) => value is bool && value;
}

class MatchPageModel {
  const MatchPageModel({required this.data, required this.totalPages});

  final List<MatchModel> data;
  final int totalPages;

  factory MatchPageModel.fromBody(dynamic body) {
    final json = MatchModel._asMap(body);
    if (json == null || json['data'] is! List) {
      throw const FormatException('Liste des matchs introuvable.');
    }
    final rawData = json['data'] as List;
    return MatchPageModel(
      data: rawData
          .map((item) {
            final match = MatchModel._asMap(item);
            if (match == null) {
              throw const FormatException('Match invalide dans la réponse.');
            }
            return MatchModel.fromJson(match);
          })
          .toList(growable: false),
      totalPages: _pageNumber(json['totalPages']),
    );
  }

  static int _pageNumber(dynamic value) =>
      value is num && value > 0 ? value.toInt() : 1;
}
