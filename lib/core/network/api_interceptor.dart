import 'package:dio/dio.dart';
import 'package:petitpotopro/core/auth/auth_tokens.dart';
import 'package:petitpotopro/core/errors/api_exceptions.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/core/storage/secure_storage.dart';

/// - Ajoute le Bearer token.
/// - Sur 401 : rafraîchit le token (une seule fois à la fois) puis rejoue la requête.
/// - Convertit toute erreur en [ApiException] (dans `DioException.error`).
///
/// Pour ignorer l'auth sur une requête (login, refresh) :
///   Options(extra: {ApiInterceptor.skipAuthKey: true})
class ApiInterceptor extends QueuedInterceptor {
  ApiInterceptor({
    required this.storage,
    required this.retryDio,
    required this.onSessionExpired,
  });

  static const skipAuthKey = 'skipAuth';
  static const _retriedKey = 'retried';

  final SecureStorage storage;
  final Dio retryDio;
  final void Function() onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthKey] != true) {
      final token = await storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final canRefresh = err.response?.statusCode == 401 &&
        request.extra[skipAuthKey] != true &&
        request.extra[_retriedKey] != true;

    if (!canRefresh) {
      _reject(err, handler);
      return;
    }

    // Si une requête précédente a déjà renouvelé le token, on rejoue directement.
    final sentAuth = request.headers['Authorization'];
    final currentToken = await storage.getAccessToken();
    final alreadyRefreshed = currentToken != null &&
        currentToken.isNotEmpty &&
        'Bearer $currentToken' != sentAuth;

    if (alreadyRefreshed || await _refresh()) {
      try {
        final token = await storage.getAccessToken();
        request.headers['Authorization'] = 'Bearer $token';
        request.extra[_retriedKey] = true;
        if (request.data is FormData) {
          request.data = (request.data as FormData).clone();
        }
        final response = await retryDio.fetch<dynamic>(request);
        handler.resolve(response);
        return;
      } on DioException catch (e) {
        _reject(e, handler);
        return;
      }
    }

    // Refresh impossible : la session est terminée.
    await storage.clear();
    onSessionExpired();
    _reject(err, handler);
  }

  Future<bool> _refresh() async {
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      // ⚠️ Vérifie le nom du champ attendu par ton API (refreshToken / refresh_token).
      final response = await retryDio.post<dynamic>(
        ApiUrl.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final tokens = AuthTokens.tryFromBody(response.data);
      if (tokens == null) return false;

      await storage.saveAccessToken(tokens.accessToken);
      if (tokens.refreshToken != null) {
        await storage.saveRefreshToken(tokens.refreshToken!);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  void _reject(DioException err, ErrorInterceptorHandler handler) {
    final apiException = err.error is ApiException
        ? err.error as ApiException
        : ApiException.fromDioException(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
        message: apiException.message,
      ),
    );
  }
}
