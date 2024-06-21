import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth_games_services/src/credentials.dart';

extension FirebaseUserPlayGames on User {
  Future<UserCredential> linkWithPlayGames({bool silent = false}) async {
    return linkWithCredential(await getPlayGamesCredential(silent: silent));
  }

  Future<UserCredential> linkWithGameCenter({bool silent = false}) async {
    return linkWithCredential(await getGameCenterCredential(silent: silent));
  }

  /// Link currently signed in user with Play Games on Android or Game Center on
  /// iOS.
  ///
  /// Throws [UnimplementedError] when called outside of Android and iOS.
  /// Throws [FirebaseAuthGamesServicesException] when authenticating with Games
  /// Services fails.
  /// Throws [FirebaseAuthException] when linking with Firebase fails. See
  /// [signInWithCredential] for possible causes.
  Future<UserCredential> linkWithGamesServices({bool silent = false}) async {
    if (Platform.isAndroid) {
      return linkWithPlayGames(silent: silent);
    }
    if (Platform.isIOS) {
      return linkWithGameCenter(silent: silent);
    }
    throw UnimplementedError('Platform not supported.');
  }

  /// Check if the user is linked with Games Services.
  bool isLinkedWithGamesServices() {
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
