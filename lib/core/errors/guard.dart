import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:petitpotopro/core/errors/api_exceptions.dart';
import 'package:petitpotopro/core/errors/failure.dart';

/// Enveloppe UN appel data et renvoie `Either<Failure, T>`.
/// Remplace tous les try/catch répétés dans les repositories.
Future<Either<Failure, T>> guard<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on DioException catch (e) {
    // L'intercepteur place déjà une ApiException dans `e.error`.
    final api = e.error is ApiException
        ? e.error as ApiException
        : ApiException.fromDioException(e);
    return Left(_toFailure(api));
  } on FormatException catch (e, st) {
    debugPrint('guard FormatException: $e\n$st');
    return const Left(
      ServerFailure(message: 'Réponse inattendue du serveur.'),
    );
  } catch (e, st) {
    debugPrint('guard error: $e\n$st');
    return const Left(ServerFailure(message: 'Une erreur est survenue.'));
  }
}

Failure _toFailure(ApiException e) => switch (e.type) {
      ApiExceptionType.network ||
      ApiExceptionType.timeout =>
        NetworkFailure(message: e.message),
      ApiExceptionType.unauthorized =>
        UnauthorizedFailure(message: e.message, code: e.statusCode),
      ApiExceptionType.notFound =>
        NotFoundFailure(message: e.message, code: e.statusCode),
      ApiExceptionType.badRequest ||
      ApiExceptionType.validation =>
        ValidationFailure(message: e.message, code: e.statusCode),
      _ => ServerFailure(message: e.message, code: e.statusCode),
    };
