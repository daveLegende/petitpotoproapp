import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petitpotopro/features/coupons/data/datasources/coupon_management_remote_data_source.dart';
import 'package:petitpotopro/features/coupons/data/datasources/user_coupon_remote_data_source.dart';
import 'package:petitpotopro/features/coupons/data/repositories/user_coupon_repository_impl.dart';
import 'package:petitpotopro/features/coupons/domain/repository/user_coupon_repository.dart';
import 'package:petitpotopro/features/coupons/domain/usecases/create_coupon_usecase.dart';
import 'package:petitpotopro/features/coupons/domain/usecases/create_tournament_coupon_usecase.dart';
import 'package:petitpotopro/features/coupons/domain/usecases/get_user_coupons_usecase.dart';
import 'package:petitpotopro/features/coupons/presentation/cubit/user_coupons_cubit.dart';

void registerCouponsModule(GetIt sl) {
  sl.registerLazySingleton<UserCouponRemoteDataSource>(
    () => UserCouponRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<CouponManagementRemoteDataSource>(
    () => CouponManagementRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<UserCouponRepository>(
    () => UserCouponRepositoryImpl(
      sl<UserCouponRemoteDataSource>(),
      sl<CouponManagementRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetUserCouponsUseCase>(
    () => GetUserCouponsUseCase(sl<UserCouponRepository>()),
  );
  sl.registerLazySingleton<CreateCouponUseCase>(
    () => CreateCouponUseCase(sl<UserCouponRepository>()),
  );
  sl.registerLazySingleton<CreateTournamentCouponUseCase>(
    () => CreateTournamentCouponUseCase(sl<UserCouponRepository>()),
  );
  sl.registerFactory<UserCouponsCubit>(
    () => UserCouponsCubit(
      sl<GetUserCouponsUseCase>(),
      sl<CreateCouponUseCase>(),
      sl<CreateTournamentCouponUseCase>(),
    ),
  );
}
