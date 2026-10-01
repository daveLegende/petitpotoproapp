import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/errors/guard.dart';
import 'package:petitpotopro/core/network/api_dto.dart';
import 'package:petitpotopro/features/coupons/data/datasources/coupon_management_remote_data_source.dart';
import 'package:petitpotopro/features/coupons/data/datasources/user_coupon_remote_data_source.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_draft.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';
import 'package:petitpotopro/features/coupons/domain/repository/user_coupon_repository.dart';

class UserCouponRepositoryImpl implements UserCouponRepository {
  const UserCouponRepositoryImpl(
    this._userDataSource,
    this._managementDataSource,
  );

  final UserCouponRemoteDataSource _userDataSource;
  final CouponManagementRemoteDataSource _managementDataSource;

  @override
  Future<Either<Failure, List<UserCoupon>>> getHistory() =>
      guard<List<UserCoupon>>(() async => _userDataSource.getMine());

  @override
  Future<Either<Failure, Unit>> createCoupon(CouponDraft draft) =>
      guard<Unit>(() async {
        await _managementDataSource.createCoupon(
          CouponAccountDto(
            user: draft.userId,
            couponBets: _couponBets(draft),
            totalOdds: draft.totalOdds,
            amount: draft.amount,
            gains: draft.potentialGains,
            etat: CouponEtat.pending,
            isDeleted: false,
            isPaid: false,
          ),
        );
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> createTournamentCoupon(CouponDraft draft) =>
      guard<Unit>(() async {
        await _managementDataSource.createTournamentCoupon(
          TournoiCouponAccountDto(
            user: draft.userId,
            tournoiCouponBets: _couponBets(draft),
            totalOdds: draft.totalOdds,
            amount: draft.amount,
            gains: draft.potentialGains,
            etat: CouponEtat.pending,
            isDeleted: false,
            isPaid: false,
          ),
        );
        return unit;
      });

  List<Map<String, dynamic>> _couponBets(CouponDraft draft) => draft.selections
      .map(
        (selection) => {
          'bet': selection.betId,
          'selectedOptions': {selection.option: selection.odd},
        },
      )
      .toList(growable: false);
}
