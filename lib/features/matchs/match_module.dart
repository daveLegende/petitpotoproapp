import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petitpotopro/features/matchs/data/datasources/match_event_remote_data_source.dart';
import 'package:petitpotopro/features/matchs/data/datasources/match_remote_data_source.dart';
import 'package:petitpotopro/features/matchs/data/repositories/match_repository_impl.dart';
import 'package:petitpotopro/features/matchs/data/repositories/match_event_repository_impl.dart';
import 'package:petitpotopro/features/matchs/domain/repository/match_event_repository.dart';
import 'package:petitpotopro/features/matchs/domain/usecases/get_match_events_usecase.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_events_cubit.dart';
import 'package:petitpotopro/features/matchs/domain/repository/match_repository.dart';
import 'package:petitpotopro/features/matchs/domain/usecases/get_all_matches_usecase.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_cubit.dart';

void registerMatchModule(GetIt sl) {
  sl
    ..registerLazySingleton<MatchRemoteDataSource>(
      () => MatchRemoteDataSourceImpl(sl<Dio>()),
    )
    ..registerLazySingleton<MatchEventRemoteDataSource>(
      () => MatchEventRemoteDataSource(sl<Dio>()),
    )
    ..registerLazySingleton<MatchRepository>(
      () => MatchRepositoryImpl(sl<MatchRemoteDataSource>()),
    )
    ..registerLazySingleton<GetAllMatchesUseCase>(
      () => GetAllMatchesUseCase(sl<MatchRepository>()),
    )
    ..registerLazySingleton<MatchEventRepository>(
      () => MatchEventRepositoryImpl(sl<MatchEventRemoteDataSource>()),
    )
    ..registerLazySingleton<GetMatchEventsUseCase>(
      () => GetMatchEventsUseCase(sl<MatchEventRepository>()),
    )
    ..registerFactory<MatchEventsCubit>(
      () => MatchEventsCubit(sl<GetMatchEventsUseCase>()),
    )
    ..registerFactory<MatchCubit>(() => MatchCubit(sl<GetAllMatchesUseCase>()));
}
