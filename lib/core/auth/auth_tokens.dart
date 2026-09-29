import 'package:petitpotopro/core/utils/json_utils.dart';

class AuthTokens {
  const AuthTokens({required this.accessToken, this.refreshToken});

  final String accessToken;
  final String? refreshToken;

  /// ⚠️ Seul endroit à adapter si ton API nomme les champs autrement.
  /// Accepte : {accessToken, refreshToken} | {access_token, refresh_token} | {token},
  /// à la racine, sous "data" ou sous "tokens".
  static AuthTokens? tryFromBody(dynamic body) {
    final root = asMap(body);
    if (root == null) return null;

    final data = asMap(root['data']);
    final candidates = [
      root,
      data,
      asMap(root['tokens']),
      asMap(data?['tokens']),
    ];

    for (final c in candidates) {
      if (c == null) continue;
      final access =
          asString(c['accessToken'] ?? c['access_token'] ?? c['token']);
      if (access == null || access.isEmpty) continue;
      return AuthTokens(
        accessToken: access,
        refreshToken: asString(c['refreshToken'] ?? c['refresh_token']),
      );
    }
    return null;
  }
}
