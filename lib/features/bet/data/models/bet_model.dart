import 'package:petitpotopro/features/bet/domain/entities/bet_entity.dart';

class BetModel extends BetEntity {
  const BetModel({
    required super.id,
    required super.category,
    required super.odds,
    required super.isActive,
    super.closedAt,
  });

  factory BetModel.fromJson(Map<String, dynamic> json) {
    final odds = <String, double>{};
    final rawOdds = json['odds'];
    if (rawOdds is Map) {
      for (final entry in rawOdds.entries) {
        if (entry.value is num) {
          odds['${entry.key}'] = (entry.value as num).toDouble();
        }
      }
    }

    return BetModel(
      id: _requiredString(json, 'id'),
      category: _requiredString(json, 'category'),
      odds: odds,
      isActive: json['isActive'] is bool && json['isActive'] as bool,
      closedAt: _date(json['closedAt']),
    );
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value;
    throw FormatException('Champ "$key" invalide dans la réponse pari.');
  }

  static DateTime? _date(dynamic value) {
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
