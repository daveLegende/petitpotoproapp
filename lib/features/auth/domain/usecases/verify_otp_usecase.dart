import 'package:dartz/dartz.dart';
import 'package:petitpotopro/core/errors/failure.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/auth/domain/entities/otp_contact.dart';
import 'package:petitpotopro/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpParams {
  const VerifyOtpParams({required this.contact, required this.code});

  final OtpContact contact;
  final String code;
}

class VerifyOtpUseCase
    implements UseCase<Either<Failure, void>, VerifyOtpParams> {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) =>
      _repository.verifyOtp(params.contact, params.code);
}
