import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'cached_user';

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: accessTokenKey, value: token);

  Future<String?> getAccessToken() => _storage.read(key: accessTokenKey);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: refreshTokenKey, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: refreshTokenKey);

  /// Profil en cache (JSON) : permet de démarrer sans appel réseau.
  Future<void> saveUser(String json) =>
      _storage.write(key: userKey, value: json);

  Future<String?> getUser() => _storage.read(key: userKey);

  Future<void> clear() => _storage.deleteAll();
}
