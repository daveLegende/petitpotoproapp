import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/features/auth/domain/entities/auth_user.dart';
import 'package:petitpotopro/features/auth/domain/entities/otp_contact.dart';
import 'package:petitpotopro/features/auth/domain/entities/register_data.dart';

abstract class AuthRepository {
  /// [identifier] : email ou téléphone.
  Future<Either<Failure, AuthUser>> login({
    required String identifier,
    required String password,
  });

  /// Lecture 100 % locale (aucun appel réseau) : `null` si pas de session.
  Future<Either<Failure, AuthUser?>> restoreSession();

  Future<Either<Failure, void>> logout();

  // --- Inscription ---------------------------------------------------------

  /// Étape 1 : envoie le code OTP.
  Future<Either<Failure, void>> sendOtp(OtpContact contact);

  /// Étape 2 : vérifie le code reçu.
  Future<Either<Failure, void>> verifyOtp(OtpContact contact, String code);

  /// Étape 3 : crée le compte.
  /// Renvoie l'utilisateur si une session a été ouverte, `null` sinon
  /// (compte créé mais l'utilisateur doit se connecter).
  Future<Either<Failure, AuthUser?>> register(RegisterData data);
}
