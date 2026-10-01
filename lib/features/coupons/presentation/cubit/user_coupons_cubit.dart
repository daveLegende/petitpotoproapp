import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_draft.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';
import 'package:petitpotopro/features/coupons/domain/usecases/create_coupon_usecase.dart';
import 'package:petitpotopro/features/coupons/domain/usecases/create_tournament_coupon_usecase.dart';
import 'package:petitpotopro/features/coupons/domain/usecases/get_user_coupons_usecase.dart';

class UserCouponsState {
  const UserCouponsState({
    this.coupons = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final List<UserCoupon> coupons;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
}

class UserCouponsCubit extends Cubit<UserCouponsState> {
  UserCouponsCubit(
    this._getCoupons,
    this._createCoupon,
    this._createTournamentCoupon,
  ) : super(const UserCouponsState());

  final GetUserCouponsUseCase _getCoupons;
  final CreateCouponUseCase _createCoupon;
  final CreateTournamentCouponUseCase _createTournamentCoupon;

  Future<void> load() async {
    emit(UserCouponsState(coupons: state.coupons, isLoading: true));
    final result = await _getCoupons(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        UserCouponsState(coupons: state.coupons, errorMessage: failure.message),
      ),
      (coupons) => emit(UserCouponsState(coupons: coupons)),
    );
  }

  Future<bool> create(CouponDraft draft, {required bool tournament}) async {
    emit(UserCouponsState(coupons: state.coupons, isSubmitting: true));
    final result = tournament
        ? await _createTournamentCoupon(draft)
        : await _createCoupon(draft);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(
          UserCouponsState(
            coupons: state.coupons,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (_) {
        emit(UserCouponsState(coupons: state.coupons));
        return true;
      },
    );
  }
}
