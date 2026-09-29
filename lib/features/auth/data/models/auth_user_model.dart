import 'package:petitpotopro/core/utils/json_utils.dart';
import 'package:petitpotopro/features/auth/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.firstname,
    required super.lastname,
    super.email,
    super.phone,
    super.avatar,
  });

  /// ⚠️ Adapte les clés si ton API diffère (ici : id/_id, firstname, lastname, email, phone, avatar).
  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        id: '${json['id'] ?? json['_id']}',
        firstname: asString(json['firstname']) ?? '',
        lastname: asString(json['lastname']) ?? '',
        email: asString(json['email']),
        phone: asString(json['phone']),
        avatar: asString(json['avatar']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'avatar': avatar,
      };

  /// Cherche l'utilisateur dans une réponse : {user}, {data:{user}}, {account}, {data}, ou la racine.
  static AuthUserModel? tryFromBody(dynamic body) {
    final root = asMap(body);
    if (root == null) return null;

    final data = asMap(root['data']);
    final candidates = [root['user'], data?['user'], root['account'], data, root];

    for (final c in candidates) {
      final map = asMap(c);
      if (map != null && (map['id'] != null || map['_id'] != null)) {
        return AuthUserModel.fromJson(map);
      }
    }
    return null;
  }
}
