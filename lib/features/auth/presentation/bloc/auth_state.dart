import 'package:equatable/equatable.dart';
import 'package:petitpotopro/features/auth/domain/entities/auth_user.dart';

enum AuthStatus { unknown, unauthenticated, loading, authenticated, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
