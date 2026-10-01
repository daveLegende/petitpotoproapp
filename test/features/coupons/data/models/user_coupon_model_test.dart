import 'package:flutter_test/flutter_test.dart';
import 'package:petitpotopro/features/coupons/data/models/user_coupon_model.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';

void main() {
  test('maps tournament coupon totals and bet count', () {
    final coupon = UserCouponModel.fromJson({
      'id': 'coupon-1',
      'etat': 'PENDING',
      'totalOdds': 4.5,
      'amount': 1000,
      'gains': 4500,
      'isPaid': false,
      'tournoiCouponBets': [
        {
          'bet': {'id': 'bet-1', 'category': 'MATCH_RESULT'},
          'selectedOptions': {'V1': 1.85},
          'etat': 'PENDING',
        },
        {
          'bet': 'bet-2',
          'selectedOptions': {'Over 2.5': 2.1},
          'etat': 'GAGNE',
        },
      ],
    }, kind: UserCouponKind.tournament);

    expect(coupon.id, 'coupon-1');
    expect(coupon.kind, UserCouponKind.tournament);
    expect(coupon.betCount, 2);
    expect(coupon.gains, 4500);
    expect(coupon.legs.first.betId, 'bet-1');
    expect(coupon.legs.first.category, 'MATCH_RESULT');
    expect(coupon.legs.first.selectedOptions['V1'], 1.85);
    expect(coupon.legs.last.status, 'GAGNE');
  });
}
