import 'package:equatable/equatable.dart';
import 'package:petitpotopro/features/auth/domain/entities/otp_contact.dart';

enum RegisterStep { contact, otp, form }

/// Résultat final de l'inscription.
enum RegisterOutcome {
  /// Compte créé ET session ouverte -> direction l'accueil.
  signedIn,

  /// Compte créé, mais il faut se connecter -> direction la page de connexion.
  needsLogin,
}

class RegisterState extends Equatable {
  const RegisterState({
    this.step = RegisterStep.contact,
    this.isLoading = false,
    this.contact,
    this.resendIn = 0,
    this.errorMessage,
    this.outcome,
  });

  final RegisterStep step;
  final bool isLoading;

  /// Email/téléphone auquel le code a été envoyé.
  final OtpContact? contact;

  /// Secondes restantes avant de pouvoir renvoyer le code.
  final int resendIn;

  /// Erreur à afficher une fois (snackbar). Elle disparaît à l'état suivant.
  final String? errorMessage;

  final RegisterOutcome? outcome;

  RegisterState copyWith({
    RegisterStep? step,
    bool? isLoading,
    OtpContact? contact,
    int? resendIn,
    String? errorMessage,
    RegisterOutcome? outcome,
  }) =>
      RegisterState(
        step: step ?? this.step,
        isLoading: isLoading ?? this.isLoading,
        contact: contact ?? this.contact,
        resendIn: resendIn ?? this.resendIn,
        // Volontairement SANS "?? this.errorMessage" : une erreur ne vit qu'un seul état.
        errorMessage: errorMessage,
        outcome: outcome ?? this.outcome,
      );

  @override
  List<Object?> get props =>
      [step, isLoading, contact, resendIn, errorMessage, outcome];
}
