import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth_games_services/firebase_auth_games_services.dart';
import 'package:firebase_auth_games_services/src/firebase_auth_games_services_exception.dart';

extension FirebaseAuthPlayGames on FirebaseAuth {
  Future<UserCredential> signInWithPlayGames() async {
    final String? authCode = await FirebaseAuthGamesServices().getAuthCode();
    if (authCode == null) {
      throw FirebaseAuthGamesServicesException(
        code: FirebaseAuthGamesServicesExceptionCode.notSignedIntoGamesServices,
        message: 'Failed to get auth code from Play Games Services.',
      );
    }

    final credential =
        PlayGamesAuthProvider.credential(serverAuthCode: authCode);
    return signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGameCenter() async {
    final String? authCode = await FirebaseAuthGamesServices().getAuthCode();
    if (authCode == null) {
      throw FirebaseAuthGamesServicesException(
        code: FirebaseAuthGamesServicesExceptionCode.notSignedIntoGamesServices,
        message: 'Failed to get auth code from iOS Game Center.',
      );
    }

    final credential = GameCenterAuthProvider.credential();
    return signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGamesServices() async {
    if (Platform.isAndroid) {
      return signInWithPlayGames();
    } else if (Platform.isIOS) {
      return signInWithGameCenter();
    } else {
      throw UnimplementedError('Platform not supported.');
    }
  }
}
