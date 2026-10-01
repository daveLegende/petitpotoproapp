import 'package:equatable/equatable.dart';

class CouponLeg extends Equatable {
  const CouponLeg({
    required this.betId,
    required this.selectedOptions,
    required this.status,
    this.category,
    this.label,
    this.matchId,
  });

  final String betId;
  final Map<String, num> selectedOptions;
  final String status;
  final String? category;
  final String? label;
  final String? matchId;

  @override
  List<Object?> get props => [
    betId,
    selectedOptions,
    status,
    category,
    label,
    matchId,
  ];
}
