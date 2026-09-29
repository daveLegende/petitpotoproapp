import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.email,
    this.phone,
    this.avatar,
  });

  final String id;
  final String firstname;
  final String lastname;
  final String? email;
  final String? phone;
  final String? avatar;

  String get fullName => '$firstname $lastname'.trim();

  @override
  List<Object?> get props => [id, firstname, lastname, email, phone, avatar];
}
