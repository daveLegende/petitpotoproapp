import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/auth/domain/entities/auth_user.dart';
import 'package:petitpotopro/features/auth/domain/repositories/auth_repository.dart';

class RestoreSessionUseCase
    implements UseCase<Either<Failure, AuthUser?>, NoParams> {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser?>> call(NoParams params) =>
      _repository.restoreSession();
}
