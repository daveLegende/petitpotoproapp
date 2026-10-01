import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_draft.dart';
import 'package:petitpotopro/features/coupons/domain/repository/user_coupon_repository.dart';

class CreateCouponUseCase
    implements UseCase<Either<Failure, Unit>, CouponDraft> {
  const CreateCouponUseCase(this._repository);

  final UserCouponRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CouponDraft params) =>
      _repository.createCoupon(params);
}
