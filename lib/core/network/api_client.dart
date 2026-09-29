import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_interceptor.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/core/storage/secure_storage.dart';

class ApiClient {
  ApiClient(
    SecureStorage storage, {
    required void Function() onSessionExpired,
  }) {
    final options = BaseOptions(
      baseUrl: ApiUrl.baseURL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(options);

    // Client "nu" (sans intercepteur) : sert au refresh et au rejeu d'une requête.
    final retryDio = Dio(options.copyWith());

    dio.interceptors.add(
      ApiInterceptor(
        storage: storage,
        retryDio: retryDio,
        onSessionExpired: onSessionExpired,
      ),
    );
  }

  late final Dio dio;
}
