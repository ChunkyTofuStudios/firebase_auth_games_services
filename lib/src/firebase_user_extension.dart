import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_games_services/firebase_auth_games_services.dart';

import 'package:firebase_auth_games_services/src/credentials.dart';
import 'package:flutter/foundation.dart';

extension FirebaseUserPlayGames on User {
  bool get isGamesServicesAvailable =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<UserCredential> linkWithPlayGames({bool silent = false}) async {
    return linkWithCredential(await getPlayGamesCredential(silent: silent));
  }

  Future<UserCredential> linkWithGameCenter({bool silent = false}) async {
    return linkWithCredential(await getGameCenterCredential(silent: silent));
  }

  /// Link currently signed in user with Play Games on Android or Game Center on
  /// iOS.
  ///
  /// Throws [FirebaseAuthGamesServicesException] when authenticating with Games
  /// Services fails.
  /// Throws [FirebaseAuthException] when linking with Firebase fails. See
  /// [signInWithCredential] for possible causes.
  Future<UserCredential> linkWithGamesServices({bool silent = false}) async {
    if (!kIsWeb && Platform.isAndroid) {
      return linkWithPlayGames(silent: silent);
    }
    if (!kIsWeb && Platform.isIOS) {
      return linkWithGameCenter(silent: silent);
    }
    throw FirebaseAuthGamesServicesException(
      code: FirebaseAuthGamesServicesExceptionCode.gamesServicesNotAvailable,
      message: 'Games Services are not available on this platform.',
    );
  }

  /// Check if the user is linked with Games Services.
  bool isLinkedWithGamesServices() {
    if (!isGamesServicesAvailable) return false;
    if (Platform.isAndroid) {
      return providerData.any((UserInfo info) =>
          info.providerId == PlayGamesAuthProvider.PROVIDER_ID);
    }
    if (Platform.isIOS) {
      return providerData.any((UserInfo info) =>
          info.providerId == GameCenterAuthProvider.PROVIDER_ID);
    }
    return false;
  }

  /// Fetches the Games Services UID of the user.
  String? getGamesServicesId() {
    if (!isGamesServicesAvailable) return null;
    try {
      if (Platform.isAndroid) {
        return providerData
            .firstWhere((UserInfo info) =>
                info.providerId == PlayGamesAuthProvider.PROVIDER_ID)
            .uid;
      }
      if (Platform.isIOS) {
        return providerData
            .firstWhere((UserInfo info) =>
                info.providerId == GameCenterAuthProvider.PROVIDER_ID)
            .uid;
      }
    } on StateError catch (_) {
      return null;
    }
    return null;
  }
}
