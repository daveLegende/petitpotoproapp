import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';
import 'package:petitpotopro/features/coupons/domain/repository/user_coupon_repository.dart';

class GetUserCouponsUseCase
    implements UseCase<Either<Failure, List<UserCoupon>>, NoParams> {
  const GetUserCouponsUseCase(this._repository);

  final UserCouponRepository _repository;

  @override
  Future<Either<Failure, List<UserCoupon>>> call(NoParams params) =>
      _repository.getHistory();
}
