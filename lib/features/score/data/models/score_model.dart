import 'package:petitpotopro/features/score/domain/entities/score_entity.dart';

class ScoreModel extends ScoreEntity {
  const ScoreModel({required super.home, required super.away});

  factory ScoreModel.fromJson(Map<String, dynamic> json) =>
      ScoreModel(home: _score(json['home']), away: _score(json['away']));

  static int _score(dynamic value) => value is num ? value.toInt() : 0;
}
