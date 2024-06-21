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

  /// Sign in with Play Games on Android or Game Center on iOS.
  ///
  /// Throws [UnimplementedError] when called outside of Android and iOS.
  /// Throws [FirebaseAuthGamesServicesException] when authenticating with Games
  /// Services fails.
  /// Throws [FirebaseAuthException] when authenticating with Firebase fails.
  /// See [signInWithCredential] for possible causes.
  Future<UserCredential> signInWithGamesServices({bool silent = false}) async {
    if (Platform.isAndroid) {
      return signInWithPlayGames(silent: silent);
    }
    if (Platform.isIOS) {
      return signInWithGameCenter(silent: silent);
    }
    throw UnimplementedError('Platform not supported.');
  }
}
