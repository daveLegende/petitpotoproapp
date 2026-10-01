import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_draft.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';

abstract class UserCouponRepository {
  Future<Either<Failure, List<UserCoupon>>> getHistory();
  Future<Either<Failure, Unit>> createCoupon(CouponDraft draft);
  Future<Either<Failure, Unit>> createTournamentCoupon(CouponDraft draft);
}
