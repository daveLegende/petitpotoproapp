import 'package:equatable/equatable.dart';

/// Où le code OTP est envoyé : un email OU un téléphone.
class OtpContact extends Equatable {
  const OtpContact.email(String value)
      : email = value,
        phone = null;

  const OtpContact.phone(String value)
      : phone = value,
        email = null;

  final String? email;
  final String? phone;

  bool get isEmail => email != null;

  String get value => email ?? phone!;

  @override
  List<Object?> get props => [email, phone];
}
