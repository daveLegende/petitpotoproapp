/// Validations simples côté client. Chaque méthode renvoie `null` si OK,
/// sinon le message d'erreur à afficher.
class Validators {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');

  static const passwordMinLength = 8;

  /// Retire espaces, tirets, points et parenthèses (ex : "+33 6 12" devient "+33612").
  static String normalizePhone(String value) =>
      value.replaceAll(RegExp(r'[\s\-.()]'), '');

  static String? email(String value) =>
      _emailRegex.hasMatch(value.trim()) ? null : 'Adresse email invalide.';

  static String? phone(String value) => _phoneRegex.hasMatch(normalizePhone(value))
      ? null
      : 'Numéro invalide : saisissez-le avec l\'indicatif du pays.';

  static String? password(String value) => value.length >= passwordMinLength
      ? null
      : 'Le mot de passe doit contenir au moins $passwordMinLength caractères.';
}
