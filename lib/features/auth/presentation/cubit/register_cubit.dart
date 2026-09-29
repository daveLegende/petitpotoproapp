import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/features/auth/domain/entities/otp_contact.dart';
import 'package:petitpotopro/features/auth/domain/entities/register_data.dart';
import 'package:petitpotopro/features/auth/domain/usecases/register_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_state.dart';

/// Gère les 3 étapes : contact -> code OTP -> formulaire.
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required SendOtpUseCase sendOtp,
    required VerifyOtpUseCase verifyOtp,
    required RegisterUseCase register,
  })  : _sendOtp = sendOtp,
        _verifyOtp = verifyOtp,
        _register = register,
        super(const RegisterState());

  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;
  final RegisterUseCase _register;

  /// Délai avant de pouvoir redemander un code (évite le spam de SMS/emails).
  static const resendDelay = 60;

  Timer? _timer;

  /// Étape 1 -> 2 : envoie le code (sert aussi pour "Renvoyer le code").
  Future<void> sendCode(OtpContact contact) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    final result = await _sendOtp(contact);
    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            step: RegisterStep.otp,
            contact: contact,
            resendIn: resendDelay,
          ),
        );
        _startCountdown();
      },
    );
  }

  Future<void> resendCode() async {
    final contact = state.contact;
    if (contact == null || state.resendIn > 0) return;
    await sendCode(contact);
  }

  /// Étape 2 -> 3 : vérifie le code.
  Future<void> verifyCode(String code) async {
    final contact = state.contact;
    if (contact == null || state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    final result =
        await _verifyOtp(VerifyOtpParams(contact: contact, code: code));
    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        _timer?.cancel();
        emit(
          state.copyWith(
            isLoading: false,
            step: RegisterStep.form,
            resendIn: 0,
          ),
        );
      },
    );
  }

  /// Étape 3 : crée le compte.
  Future<void> submit(RegisterData data) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    final result = await _register(data);
    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (user) => emit(
        state.copyWith(
          isLoading: false,
          outcome: user != null
              ? RegisterOutcome.signedIn
              : RegisterOutcome.needsLogin,
        ),
      ),
    );
  }

  /// Retour de l'étape "code" vers l'étape "contact" (numéro/email à corriger).
  void backToContact() {
    _timer?.cancel();
    emit(state.copyWith(step: RegisterStep.contact, isLoading: false, resendIn: 0));
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final left = state.resendIn - 1;
      if (left <= 0) timer.cancel();
      if (!isClosed) emit(state.copyWith(resendIn: left < 0 ? 0 : left));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
