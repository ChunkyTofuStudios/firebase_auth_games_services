import 'package:firebase_auth_games_services/src/logging.dart';

import 'firebase_auth_games_services_platform_interface.dart';

class FirebaseAuthGamesServices {
  static final FirebaseAuthGamesServices _instance =
      FirebaseAuthGamesServices._internal();

  FirebaseAuthGamesServices._internal();

  factory FirebaseAuthGamesServices() {
    return _instance;
  }

  void enableDebugLogging(bool enabled) {
    setLogging(enabled: enabled);
  }

  Future<String?> getPlatformVersion() {
    return FirebaseAuthGamesServicesPlatform.instance.getPlatformVersion();
  }

  Future<String?> getAuthCode() {
    return FirebaseAuthGamesServicesPlatform.instance.getAuthCode();
  }

  Future<String?> signIn() {
    return FirebaseAuthGamesServicesPlatform.instance.signIn();
  }
}
