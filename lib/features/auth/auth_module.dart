import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petitpotopro/core/storage/secure_storage.dart';
import 'package:petitpotopro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:petitpotopro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:petitpotopro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:petitpotopro/features/auth/domain/repositories/auth_repository.dart';
import 'package:petitpotopro/features/auth/domain/usecases/login_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/logout_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/register_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_cubit.dart';

void registerAuthModule(GetIt sl) {
  sl
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl<SecureStorage>()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<Dio>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: sl<AuthRemoteDataSource>(),
        local: sl<AuthLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<RestoreSessionUseCase>(
      () => RestoreSessionUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SendOtpUseCase>(
      () => SendOtpUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(sl<AuthRepository>()),
    )
    // Singleton : partagé entre le BlocProvider, le routeur et l'intercepteur.
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        login: sl<LoginUseCase>(),
        logout: sl<LogoutUseCase>(),
        restoreSession: sl<RestoreSessionUseCase>(),
      ),
    )
    // Factory : un nouveau RegisterCubit (état vierge) à chaque ouverture de la page.
    ..registerFactory<RegisterCubit>(
      () => RegisterCubit(
        sendOtp: sl<SendOtpUseCase>(),
        verifyOtp: sl<VerifyOtpUseCase>(),
        register: sl<RegisterUseCase>(),
      ),
    );
}
