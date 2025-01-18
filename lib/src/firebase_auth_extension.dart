import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth_games_services/src/credentials.dart';
import 'package:firebase_auth_games_services/src/firebase_auth_games_services_exception.dart';
import 'package:flutter/foundation.dart';

extension FirebaseAuthPlayGames on FirebaseAuth {
  bool get isGamesServicesAvailable =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<UserCredential> signInWithPlayGames({bool silent = false}) async {
    return signInWithCredential(await getPlayGamesCredential(silent: silent));
  }

  Future<UserCredential> signInWithGameCenter({bool silent = false}) async {
    return signInWithCredential(await getGameCenterCredential(silent: silent));
  }

  /// Sign in with Play Games on Android or Game Center on iOS.
  ///
  /// Throws [FirebaseAuthGamesServicesException] when authenticating with Games
  /// Services fails.
  /// Throws [FirebaseAuthException] when authenticating with Firebase fails.
  /// See [signInWithCredential] for possible causes.
  Future<UserCredential> signInWithGamesServices({bool silent = false}) async {
    if (!kIsWeb && Platform.isAndroid) {
      return signInWithPlayGames(silent: silent);
    }
    if (!kIsWeb && Platform.isIOS) {
      return signInWithGameCenter(silent: silent);
    }
    throw FirebaseAuthGamesServicesException(
      code: FirebaseAuthGamesServicesExceptionCode.gamesServicesNotAvailable,
      message: 'Games Services are not available on this platform.',
    );
  }
}
