import 'package:petitpotopro/core/auth/auth_tokens.dart';
import 'package:petitpotopro/features/auth/data/models/auth_user_model.dart';

class AuthResultModel {
  const AuthResultModel({required this.tokens, this.user});

  final AuthTokens tokens;
  final AuthUserModel? user;

  factory AuthResultModel.fromBody(dynamic body) {
    final result = tryFromBody(body);
    if (result == null) {
      throw const FormatException('Tokens introuvables dans la réponse de login.');
    }
    return result;
  }

  /// Comme [fromBody], mais renvoie `null` (au lieu de lever) si la réponse
  /// ne contient pas de tokens. Utile pour l'inscription.
  static AuthResultModel? tryFromBody(dynamic body) {
    final tokens = AuthTokens.tryFromBody(body);
    if (tokens == null) return null;
    return AuthResultModel(tokens: tokens, user: AuthUserModel.tryFromBody(body));
  }
}
