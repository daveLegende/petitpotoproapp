import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/auth/domain/entities/otp_contact.dart';
import 'package:petitpotopro/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase implements UseCase<Either<Failure, void>, OtpContact> {
  const SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(OtpContact params) =>
      _repository.sendOtp(params);
}
