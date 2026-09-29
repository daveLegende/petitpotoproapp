import 'dart:convert';

import 'package:petitpotopro/core/auth/auth_tokens.dart';
import 'package:petitpotopro/core/storage/secure_storage.dart';
import 'package:petitpotopro/features/auth/data/models/auth_user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokens tokens);

  Future<void> saveUser(AuthUserModel user);

  Future<bool> hasSession();

  Future<AuthUserModel?> readUser();

  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    await _storage.saveAccessToken(tokens.accessToken);
    if (tokens.refreshToken != null) {
      await _storage.saveRefreshToken(tokens.refreshToken!);
    }
  }

  @override
  Future<void> saveUser(AuthUserModel user) =>
      _storage.saveUser(jsonEncode(user.toJson()));

  @override
  Future<bool> hasSession() async {
    final token = await _storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<AuthUserModel?> readUser() async {
    final raw = await _storage.getUser();
    if (raw == null) return null;
    try {
      return AuthUserModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return null; // cache corrompu : on repart sans session
    }
  }

  @override
  Future<void> clear() => _storage.clear();
}
