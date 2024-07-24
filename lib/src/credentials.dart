import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth_games_services/src/firebase_auth_games_services.dart';
import 'package:firebase_auth_games_services/src/firebase_auth_games_services_exception.dart';

Future<OAuthCredential> getPlayGamesCredential({bool silent = false}) async {
  final String? authCode = silent
      ? await FirebaseAuthGamesServices().getAuthCode()
      : await FirebaseAuthGamesServices().signIn();
  if (authCode == null) {
    throw FirebaseAuthGamesServicesException(
      code: FirebaseAuthGamesServicesExceptionCode.notSignedIntoGamesServices,
      message: 'Failed to get auth code from Play Games Services.',
    );
  }

  return PlayGamesAuthProvider.credential(serverAuthCode: authCode);
}

Future<OAuthCredential> getGameCenterCredential({bool silent = false}) async {
  if (await FirebaseAuthGamesServices().isSignedIn()) {
    return GameCenterAuthProvider.credential();
  }
  if (silent) {
    throw FirebaseAuthGamesServicesException(
      code: FirebaseAuthGamesServicesExceptionCode.notSignedIntoGamesServices,
      message: 'User is not signed into Game Center.',
    );
  }
  if ((await FirebaseAuthGamesServices().signIn()) == null) {
    throw FirebaseAuthGamesServicesException(
      code: FirebaseAuthGamesServicesExceptionCode.notSignedIntoGamesServices,
      message: 'Error when trying to sign into Game Center.',
    );
  }
  return GameCenterAuthProvider.credential();
}
