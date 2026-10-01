import 'package:petitpotopro/core/utils/json_utils.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_leg.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';

class UserCouponModel extends UserCoupon {
  const UserCouponModel({
    required super.id,
    required super.kind,
    required super.status,
    required super.totalOdds,
    required super.amount,
    required super.gains,
    required super.betCount,
    required super.isPaid,
    super.legs,
  });

  factory UserCouponModel.fromJson(
    Map<String, dynamic> json, {
    required UserCouponKind kind,
  }) {
    final bets =
        json[kind == UserCouponKind.match ? 'couponBets' : 'tournoiCouponBets'];
    final legs = bets is List
        ? bets
              .map((bet) {
                if (bet is Map)
                  return _parseLeg(Map<String, dynamic>.from(bet));
                if (bet is String) return _parseLeg({'bet': bet});
                return null;
              })
              .whereType<CouponLeg>()
              .toList(growable: false)
        : const <CouponLeg>[];
    return UserCouponModel(
      id: asString(json['id'] ?? json['_id']) ?? '',
      kind: kind,
      status: asString(json['etat'] ?? json['status']) ?? 'PENDING',
      totalOdds: json['totalOdds'] is num ? json['totalOdds'] as num : null,
      amount: json['amount'] is num ? json['amount'] as num : null,
      gains: json['gains'] is num ? json['gains'] as num : null,
      betCount: legs.length,
      isPaid: json['isPaid'] == true,
      legs: legs,
    );
  }

  static CouponLeg _parseLeg(Map<String, dynamic> json) {
    final rawBet = json['bet'];
    final bet = asMap(rawBet);
    final rawMatch = bet?['match'] ?? json['match'];
    final match = asMap(rawMatch);
    final selectedOptions = <String, num>{};
    final rawOptions = json['selectedOptions'] ?? json['options'];
    if (rawOptions is Map) {
      for (final entry in rawOptions.entries) {
        final value = entry.value;
        if (value is num) {
          selectedOptions['${entry.key}'] = value;
        } else if (value is Map) {
          final option = asMap(value);
          final odd = option?['odd'] ?? option?['cote'] ?? option?['value'];
          if (odd is num) selectedOptions['${entry.key}'] = odd;
        }
      }
    }

    final matchId =
        match?['id'] ??
        match?['_id'] ??
        bet?['matchId'] ??
        (rawMatch is String ? rawMatch : null);
    return CouponLeg(
      betId: asString(bet?['id'] ?? bet?['_id'] ?? rawBet) ?? '',
      selectedOptions: selectedOptions,
      status: asString(json['etat'] ?? json['status']) ?? 'PENDING',
      category: asString(bet?['category'] ?? json['category']),
      label: asString(
        bet?['label'] ?? bet?['name'] ?? json['label'] ?? json['description'],
      ),
      matchId: asString(matchId),
    );
  }
}
