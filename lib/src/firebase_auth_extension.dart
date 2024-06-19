import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth_games_services/src/credentials.dart';

extension FirebaseAuthPlayGames on FirebaseAuth {
  Future<UserCredential> signInWithPlayGames({bool silent = false}) async {
    return signInWithCredential(await getPlayGamesCredential(silent: silent));
  }

  Future<UserCredential> signInWithGameCenter({bool silent = false}) async {
    return signInWithCredential(await getGameCenterCredential(silent: silent));
  }

  Future<UserCredential> signInWithGamesServices({bool silent = false}) async {
    if (Platform.isAndroid) {
      return signInWithPlayGames(silent: silent);
    } else if (Platform.isIOS) {
      return signInWithGameCenter(silent: silent);
    } else {
      throw UnimplementedError('Platform not supported.');
    }
  }
}
