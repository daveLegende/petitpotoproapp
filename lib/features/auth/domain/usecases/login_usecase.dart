import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/auth/domain/entities/auth_user.dart';
import 'package:petitpotopro/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.identifier, required this.password});

  final String identifier;
  final String password;
}

class LoginUseCase implements UseCase<Either<Failure, AuthUser>, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser>> call(LoginParams params) =>
      _repository.login(
        identifier: params.identifier.trim(),
        password: params.password,
      );
}
