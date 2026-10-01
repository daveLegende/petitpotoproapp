import 'package:petitpotopro/core/utils/json_utils.dart';
import 'package:petitpotopro/features/tickets/domain/entities/user_ticket.dart';

class UserTicketModel extends UserTicket {
  const UserTicketModel({
    required super.id,
    required super.type,
    required super.duration,
    required super.status,
    required super.position,
    required super.amount,
    required super.date,
    required super.matchCount,
  });

  factory UserTicketModel.fromJson(Map<String, dynamic> json) {
    final matches = json['matchs'] ?? json['matches'] ?? json['match'];
    final dateValue = json['date'];
    return UserTicketModel(
      id: asString(json['id'] ?? json['_id']) ?? '',
      type: asString(json['type']) ?? 'STANDARD',
      duration: asString(json['duree'] ?? json['duration']) ?? '',
      status: asString(json['etat'] ?? json['status']) ?? 'VALIDE',
      position: asString(json['position']) ?? '',
      amount: json['amount'] is num ? json['amount'] as num : null,
      date: dateValue is String ? DateTime.tryParse(dateValue) : null,
      matchCount: matches is List
          ? matches.length
          : matches == null
          ? 0
          : 1,
    );
  }
}
