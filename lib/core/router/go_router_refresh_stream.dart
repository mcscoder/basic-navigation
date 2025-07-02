import 'dart:async';

import 'package:flutter/material.dart';

// The built-in `GoRouterRefreshStream` has been removed since v5+.
// This is how that class looks like.
// Source: https://github.com/flutter/flutter/issues/108128#issue-1313749003
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
