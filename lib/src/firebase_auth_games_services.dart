import 'package:firebase_auth_games_services/src/firebase_auth_games_services_platform_interface.dart';
import 'package:firebase_auth_games_services/src/logging.dart';

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

  /// Fetches Android or iOS version. Used for debugging.
  Future<String?> getPlatformVersion() {
    return FirebaseAuthGamesServicesPlatform.instance.getPlatformVersion();
  }

  /// Checks if the user is signed in using Game Center SDK on iOS.
  /// iOS only.
  Future<bool> isSignedIn() {
    return FirebaseAuthGamesServicesPlatform.instance.isSignedIn();
  }

  /// Gets the server auth code from Play Games SDK on Android.
  /// Android only.
  Future<String?> getAuthCode() {
    return FirebaseAuthGamesServicesPlatform.instance.getAuthCode();
  }

  /// Requests explicit sign in from the user via a pop-up dialog on Android and iOS.
  Future<String?> signIn() {
    return FirebaseAuthGamesServicesPlatform.instance.signIn();
  }
}
