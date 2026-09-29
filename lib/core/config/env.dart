/// Configuration injectée au build, plus rien en dur dans le code.
///
///   flutter run --dart-define=API_BASE_URL=https://xxxx.ngrok-free.app/api/v1
///   flutter build apk --dart-define=API_BASE_URL=https://zemoz-api-oxtf.onrender.com/api/v1
class Env {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // defaultValue: 'https://de7b-2c0f-f0f8-60a-3100-f45f-a8e2-78f2-4e83.ngrok-free.app/api/v1',
    defaultValue: 'http://192.168.1.66:3333/api/v1',
  );
}
