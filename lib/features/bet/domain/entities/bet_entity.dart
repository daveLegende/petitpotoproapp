import 'package:equatable/equatable.dart';

class BetEntity extends Equatable {
  const BetEntity({
    required this.id,
    required this.category,
    required this.odds,
    required this.isActive,
    this.closedAt,
  });

  final String id;
  final String category;
  final Map<String, double> odds;
  final bool isActive;
  final DateTime? closedAt;

  @override
  List<Object?> get props => [id, category, odds, isActive, closedAt];
}
