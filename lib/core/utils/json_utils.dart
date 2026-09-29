Map<String, dynamic>? asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

String? asString(dynamic value) => value == null ? null : '$value';

String string0(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) return value;
  throw FormatException('Champ "$key" invalide dans la réponse tournoi.');
}

int integer0(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  throw FormatException('Champ "$key" invalide dans la réponse tournoi.');
}

DateTime date0(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) {
    final date = DateTime.tryParse(value);
    if (date != null) return date;
  }
  throw FormatException('Champ "$key" invalide dans la réponse tournoi.');
}

bool boolean0(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is bool) return value;
  throw FormatException('Champ "$key" invalide dans la réponse tournoi.');
}