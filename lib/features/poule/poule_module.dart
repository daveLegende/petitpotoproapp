import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petitpotopro/features/poule/data/datasources/poule_remote_data_source.dart';

void registerPouleModule(GetIt sl) {
  sl.registerLazySingleton<PouleRemoteDataSource>(
    () => PouleRemoteDataSource(sl<Dio>()),
  );
}