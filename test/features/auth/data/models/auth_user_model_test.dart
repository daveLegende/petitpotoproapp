import 'package:flutter_test/flutter_test.dart';
import 'package:petitpotopro/features/auth/data/models/auth_user_model.dart';

void main() {
  test('reads balance from supported user response keys', () {
    final direct = AuthUserModel.fromJson({
      'id': 'user-1',
      'firstname': 'Afi',
      'lastname': 'Mensah',
      'balance': 1250,
    });
    final nested = AuthUserModel.fromJson({
      'id': 'user-2',
      'firstname': 'Kofi',
      'lastname': 'Doe',
      'wallet': {'solde': '2400.50'},
    });

    expect(direct.balance, 1250);
    expect(nested.balance, 2400.5);
  });
}
