import 'package:firebase_auth/firebase_auth.dart';
import 'package:games_services/games_services.dart';

import 'package:firebase_auth_games_services/firebase_auth_games_services.dart';

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
  if (!(await _signIntoGameCenter(silent: silent))) {
    throw FirebaseAuthGamesServicesException(
      code: FirebaseAuthGamesServicesExceptionCode.notSignedIntoGamesServices,
      message: 'User is not signed into Game Center.',
    );
  }
  return GameCenterAuthProvider.credential();
}

Future<bool> _signIntoGameCenter({bool silent = false}) async {
  try {
    if (await GamesServices.isSignedIn) {
      return true;
    }
    if (silent) {
      return false;
    }
    await GamesServices.signIn();
    return await GamesServices.isSignedIn;
  } catch (e) {
    throw FirebaseAuthGamesServicesException(
      code: FirebaseAuthGamesServicesExceptionCode.notSignedIntoGamesServices,
      message: 'Error when trying to sign into Game Center.',
      details: e,
    );
  }
}
