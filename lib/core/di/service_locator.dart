import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petitpotopro/core/network/api_client.dart';
import 'package:petitpotopro/core/storage/secure_storage.dart';
import 'package:petitpotopro/features/auth/auth_module.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/matchs/match_module.dart';
import 'package:petitpotopro/features/tournoi/tournoi_module.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // --- Core ---
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());

  sl.registerLazySingleton<Dio>(
    () => ApiClient(
      sl<SecureStorage>(),
      // Résolu à l'exécution (pas à la création) : pas de dépendance circulaire.
      onSessionExpired: () => sl<AuthBloc>().add(const AuthSessionExpired()),
    ).dio,
  );

  // --- Features (une ligne par feature) ---
  registerAuthModule(sl);
  registerTournoiModule(sl);
  registerMatchModule(sl);
}
