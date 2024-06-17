import 'firebase_auth_games_services_platform_interface.dart';

class FirebaseAuthGamesServices {
  Future<String?> getPlatformVersion() {
    return FirebaseAuthGamesServicesPlatform.instance.getPlatformVersion();
  }

  Future<String?> login() {
    return FirebaseAuthGamesServicesPlatform.instance.login();
  }
}
