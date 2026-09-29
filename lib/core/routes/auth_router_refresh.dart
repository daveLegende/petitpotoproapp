import 'dart:async';

import 'package:flutter/foundation.dart';

/// Notifie GoRouter à chaque émission du flux, pour qu'il ré-évalue `redirect`.
class AuthRouterRefresh extends ChangeNotifier {
  AuthRouterRefresh(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
