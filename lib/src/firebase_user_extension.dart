import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_games_services/firebase_auth_games_services.dart';

import 'package:firebase_auth_games_services/src/credentials.dart';
import 'package:flutter/foundation.dart';

extension FirebaseUserPlayGames on User {
  Future<UserCredential> linkWithPlayGames({bool silent = false}) async {
    if (kIsWeb || !Platform.isAndroid) {
      throw FirebaseAuthGamesServicesException(
        code: FirebaseAuthGamesServicesExceptionCode.gamesServicesNotAvailable,
        message: 'Play Games is only available on Android.',
      );
    }
    return linkWithCredential(await getPlayGamesCredential(silent: silent));
  }

  Future<UserCredential> linkWithGameCenter({bool silent = false}) async {
    if (kIsWeb || !Platform.isIOS) {
      throw FirebaseAuthGamesServicesException(
        code: FirebaseAuthGamesServicesExceptionCode.gamesServicesNotAvailable,
        message: 'Game Center is only available on iOS.',
      );
    }
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
  bool get isLinkedWithGamesServices => providerData.any((info) =>
      info.providerId == PlayGamesAuthProvider.PROVIDER_ID ||
      info.providerId == GameCenterAuthProvider.PROVIDER_ID);

  /// Fetches the Games Services UID of the user.
  String? get gamesServicesId {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        return providerData
            .firstWhere(
                (info) => info.providerId == PlayGamesAuthProvider.PROVIDER_ID)
            .uid;
      }
      if (!kIsWeb && Platform.isIOS) {
        return providerData
            .firstWhere(
                (info) => info.providerId == GameCenterAuthProvider.PROVIDER_ID)
            .uid;
      }
      // Fallback to either provider if not on Android or iOS.
      return providerData
          .firstWhere((info) =>
              info.providerId == PlayGamesAuthProvider.PROVIDER_ID ||
              info.providerId == GameCenterAuthProvider.PROVIDER_ID)
          .uid;
    } on StateError catch (_) {
      return null;
    }
  }
}
