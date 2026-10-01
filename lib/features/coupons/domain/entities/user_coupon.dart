import 'package:petitpotopro/features/coupons/domain/entities/coupon_leg.dart';

enum UserCouponKind { match, tournament }

class UserCoupon {
  const UserCoupon({
    required this.id,
    required this.kind,
    required this.status,
    required this.totalOdds,
    required this.amount,
    required this.gains,
    required this.betCount,
    required this.isPaid,
    this.legs = const [],
  });

  final String id;
  final UserCouponKind kind;
  final String status;
  final num? totalOdds;
  final num? amount;
  final num? gains;
  final int betCount;
  final bool isPaid;
  final List<CouponLeg> legs;
}
