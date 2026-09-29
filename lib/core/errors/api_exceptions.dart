import 'package:dio/dio.dart';

enum ApiExceptionType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  tooManyRequests,
  serverError,
  network,
  timeout,
  cancelled,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ApiExceptionType type;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    required this.type,
    this.data,
  });

  factory ApiException.fromDioException(
    DioException exception,
  ) {
    final statusCode = exception.response?.statusCode;

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'La connexion a expiré.',
          statusCode: statusCode,
          type: ApiExceptionType.timeout,
          data: exception.response?.data,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Impossible de contacter le serveur.',
          statusCode: statusCode,
          type: ApiExceptionType.network,
          data: exception.response?.data,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: 'La requête a été annulée.',
          statusCode: statusCode,
          type: ApiExceptionType.cancelled,
          data: exception.response?.data,
        );

      case DioExceptionType.badResponse:
        return _fromStatusCode(exception);

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Certificat SSL invalide.',
          statusCode: statusCode,
          type: ApiExceptionType.network,
          data: exception.response?.data,
        );

      case DioExceptionType.unknown:
        return ApiException(
          message: 'Une erreur inattendue est survenue.',
          statusCode: statusCode,
          type: ApiExceptionType.unknown,
          data: exception.response?.data,
        );
      case DioExceptionType.transformTimeout:
        throw UnimplementedError();
    }
  }

  static ApiException _fromStatusCode(
    DioException exception,
  ) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;

    switch (statusCode) {
      case 400:
        return ApiException(
          message: _extractMessage(
            data,
            'Requête invalide.',
          ),
          statusCode: statusCode,
          type: ApiExceptionType.badRequest,
          data: data,
        );

      case 401:
        return ApiException(
          message: _extractMessage(
            data,
            'Votre session a expiré.',
          ),
          statusCode: statusCode,
          type: ApiExceptionType.unauthorized,
          data: data,
        );

      case 403:
        return ApiException(
          message: _extractMessage(
            data,
            'Vous n’avez pas les permissions nécessaires.',
          ),
          statusCode: statusCode,
          type: ApiExceptionType.forbidden,
          data: data,
        );

      case 404:
        return ApiException(
          message: _extractMessage(
            data,
            'Ressource introuvable.',
          ),
          statusCode: statusCode,
          type: ApiExceptionType.notFound,
          data: data,
        );

      case 409:
        return ApiException(
          message: _extractMessage(
            data,
            'Cette opération entre en conflit avec une donnée existante.',
          ),
          statusCode: statusCode,
          type: ApiExceptionType.conflict,
          data: data,
        );

      case 422:
        return ApiException(
          message: _extractMessage(
            data,
            'Certaines données sont invalides.',
          ),
          statusCode: statusCode,
          type: ApiExceptionType.validation,
          data: data,
        );

      case 429:
        return ApiException(
          message: 'Trop de requêtes. Veuillez patienter.',
          statusCode: statusCode,
          type: ApiExceptionType.tooManyRequests,
          data: data,
        );

      case final code? when code >= 500:
        return ApiException(
          message: 'Le serveur rencontre un problème.',
          statusCode: statusCode,
          type: ApiExceptionType.serverError,
          data: data,
        );

      default:
        return ApiException(
          message: _extractMessage(
            data,
            'Une erreur est survenue.',
          ),
          statusCode: statusCode,
          type: ApiExceptionType.unknown,
          data: data,
        );
    }
  }

  static String _extractMessage(
    dynamic data,
    String fallback,
  ) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      if (message is List && message.isNotEmpty) {
        return message.join(', ');
      }

      final error = data['error'];

      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    return fallback;
  }

  bool get isUnauthorized =>
      type == ApiExceptionType.unauthorized;

  bool get isNetworkError =>
      type == ApiExceptionType.network;

  bool get isServerError =>
      type == ApiExceptionType.serverError;

  @override
  String toString() {
    return 'ApiException('
        'message: $message, '
        'statusCode: $statusCode, '
        'type: $type'
        ')';
  }
}