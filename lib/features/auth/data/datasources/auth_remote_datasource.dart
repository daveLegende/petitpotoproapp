import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_dto.dart';
import 'package:petitpotopro/core/network/api_interceptor.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/features/auth/data/models/auth_result_model.dart';
import 'package:petitpotopro/features/auth/data/models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResultModel> login(SigninAccountDto dto);

  Future<AuthUserModel> currentUser();

  Future<void> sendOtp(SendOtpDto dto);

  Future<void> verifyOtp(VerifyOtpDto dto);

  /// `null` si le serveur crée le compte sans ouvrir de session
  /// (pas de tokens dans la réponse).
  Future<AuthResultModel?> register(UserRegisterDto dto);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Requêtes faites avant d'être connecté : pas de token, pas de refresh.
  Options _noAuth() => Options(
        extra: {ApiInterceptor.skipAuthKey: true},
      );

  @override
  Future<AuthResultModel> login(SigninAccountDto dto) async {
    final response = await _dio.post<dynamic>(
      ApiUrl.login,
      data: dto.toJson(),
      // Un 401 ici = mauvais identifiants, pas un token expiré : pas de refresh.
      options: _noAuth(),
    );
    return AuthResultModel.fromBody(response.data);
  }

  @override
  Future<AuthUserModel> currentUser() async {
    final response = await _dio.get<dynamic>(ApiUrl.currentUser);
    final user = AuthUserModel.tryFromBody(response.data);
    if (user == null) {
      throw const FormatException('Utilisateur introuvable dans la réponse.');
    }
    return user;
  }

  @override
  Future<void> sendOtp(SendOtpDto dto) async {
    await _dio.post<dynamic>(
      ApiUrl.sendOtp,
      data: dto.toJson(),
      options: _noAuth(),
    );
  }

  @override
  Future<void> verifyOtp(VerifyOtpDto dto) async {
    await _dio.post<dynamic>(
      ApiUrl.verifyOtp,
      data: dto.toJson(),
      options: _noAuth(),
    );
  }

  @override
  Future<AuthResultModel?> register(UserRegisterDto dto) async {
    final response = await _dio.post<dynamic>(
      ApiUrl.register,
      data: dto.toJson(),
      options: _noAuth(),
    );
    return AuthResultModel.tryFromBody(response.data);
  }
}
