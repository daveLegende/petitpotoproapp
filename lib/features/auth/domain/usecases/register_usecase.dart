import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/auth/domain/entities/auth_user.dart';
import 'package:petitpotopro/features/auth/domain/entities/register_data.dart';
import 'package:petitpotopro/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase
    implements UseCase<Either<Failure, AuthUser?>, RegisterData> {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser?>> call(RegisterData params) =>
      _repository.register(params);
}
