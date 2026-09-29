import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/login_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/logout_usecase.dart';
import 'package:petitpotopro/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase login,
    required LogoutUseCase logout,
    required RestoreSessionUseCase restoreSession,
  })  : _login = login,
        _logout = logout,
        _restoreSession = restoreSession,
        super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionExpired>(_onSessionExpired);
  }

  final LoginUseCase _login;
  final LogoutUseCase _logout;
  final RestoreSessionUseCase _restoreSession;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _restoreSession(const NoParams());

    // Échec ou pas de session : on considère l'utilisateur déconnecté.
    final user = result.fold((_) => null, (user) => user);
    emit(
      user == null
          ? const AuthState(status: AuthStatus.unauthenticated)
          : AuthState(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));

    final result = await _login(
      LoginParams(identifier: event.identifier, password: event.password),
    );

    emit(
      result.fold(
        (failure) => AuthState(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
        (user) => AuthState(status: AuthStatus.authenticated, user: user),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout(const NoParams());
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void _onSessionExpired(AuthSessionExpired event, Emitter<AuthState> emit) {
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
