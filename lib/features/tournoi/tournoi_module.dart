import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petitpotopro/features/tournoi/data/datasources/tournoi_remote_data_source.dart';
import 'package:petitpotopro/features/tournoi/data/repositories/tournoi_repository_impl.dart';
import 'package:petitpotopro/features/tournoi/domain/repository/tournoi_repository.dart';
import 'package:petitpotopro/features/tournoi/domain/usecases/tournoi_usecase.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_cubit.dart';

void registerTournoiModule(GetIt sl) {
  sl
    ..registerLazySingleton<TournoiRemoteDataSource>(
      () => TournoiRemoteDataSourceImpl(sl<Dio>()),
    )
    ..registerLazySingleton<TournoiRepository>(
      () => TournoiRepositoryImpl(sl<TournoiRemoteDataSource>()),
    )
    ..registerLazySingleton<TournoiUseCase>(
      () => TournoiUseCase(sl<TournoiRepository>()),
    )
    ..registerFactory<TournoiCubit>(() => TournoiCubit(sl<TournoiUseCase>()));
}
