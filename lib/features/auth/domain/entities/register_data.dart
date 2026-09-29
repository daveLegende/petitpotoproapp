import 'package:equatable/equatable.dart';

enum Gender { male, female }

/// Toutes les infos du formulaire d'inscription.
class RegisterData extends Equatable {
  const RegisterData({
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.country,
    required this.password,
    this.email,
    this.gender,
  });

  final String firstname;
  final String lastname;
  final String phone;
  final String country;
  final String password;

  final String? email;
  final Gender? gender;

  @override
  List<Object?> get props =>
      [firstname, lastname, phone, country, password, email, gender];
}
