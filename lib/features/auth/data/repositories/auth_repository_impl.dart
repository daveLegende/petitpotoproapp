import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/errors/guard.dart';
import 'package:petitpotopro/core/network/api_dto.dart';
import 'package:petitpotopro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:petitpotopro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:petitpotopro/features/auth/domain/entities/auth_user.dart';
import 'package:petitpotopro/features/auth/domain/entities/otp_contact.dart';
import 'package:petitpotopro/features/auth/domain/entities/register_data.dart';
import 'package:petitpotopro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.remote, required this.local});

  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  @override
  Future<Either<Failure, AuthUser>> login({
    required String identifier,
    required String password,
  }) =>
      guard<AuthUser>(() async {
        final result = await remote.login(
          SigninAccountDto(identifier: identifier, password: password),
        );

        // Les tokens d'abord : l'appel suivant en a besoin.
        await local.saveTokens(result.tokens);

        final user = result.user ?? await remote.currentUser();
        await local.saveUser(user);
        return user;
      });

  @override
  Future<Either<Failure, AuthUser?>> restoreSession() =>
      guard<AuthUser?>(() async {
        if (!await local.hasSession()) return null;
        return local.readUser();
      });

  @override
  Future<Either<Failure, void>> logout() => guard<void>(local.clear);

  // --- Inscription ---------------------------------------------------------

  @override
  Future<Either<Failure, void>> sendOtp(OtpContact contact) => guard<void>(
        () => remote.sendOtp(
          SendOtpDto(email: contact.email, phone: contact.phone),
        ),
      );

  @override
  Future<Either<Failure, void>> verifyOtp(OtpContact contact, String code) =>
      guard<void>(
        () => remote.verifyOtp(
          VerifyOtpDto(email: contact.email, phone: contact.phone, code: code),
        ),
      );

  @override
  Future<Either<Failure, AuthUser?>> register(RegisterData data) =>
      guard<AuthUser?>(() async {
        final result = await remote.register(
          UserRegisterDto(
            firstname: data.firstname,
            lastname: data.lastname,
            sex: _toSex(data.gender),
            email: data.email,
            phone: data.phone,
            country: data.country,
            password: data.password,
            confirmPass: data.password, // déjà vérifié dans le formulaire
          ),
        );

        // Le compte existe maintenant. Tout ce qui suit est "du confort" :
        // s'il échoue, on ne renvoie SURTOUT PAS une erreur (l'utilisateur
        // réessaierait et obtiendrait "compte déjà existant").
        if (result == null) return null;
        try {
          await local.saveTokens(result.tokens);
          final user = result.user ?? await remote.currentUser();
          await local.saveUser(user);
          return user;
        } catch (_) {
          await local.clear(); // pas de session à moitié créée
          return null; // -> l'UI envoie l'utilisateur vers la page de connexion
        }
      });

  Sex? _toSex(Gender? gender) => switch (gender) {
        Gender.male => Sex.male,
        Gender.female => Sex.female,
        null => null,
      };
}
