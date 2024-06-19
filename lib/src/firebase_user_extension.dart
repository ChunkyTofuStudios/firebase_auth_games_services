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

  Future<UserCredential> linkWithGamesServices({bool silent = false}) async {
    if (Platform.isAndroid) {
      return linkWithPlayGames(silent: silent);
    } else if (Platform.isIOS) {
      return linkWithGameCenter(silent: silent);
    } else {
      throw UnimplementedError('Platform not supported.');
    }
  }

  bool isLinkedWithGamesServices() {
    if (Platform.isAndroid) {
      return providerData.any((UserInfo info) =>
          info.providerId == PlayGamesAuthProvider.PROVIDER_ID);
    } else if (Platform.isIOS) {
      return providerData.any((UserInfo info) =>
          info.providerId == GameCenterAuthProvider.PROVIDER_ID);
    } else {
      throw UnimplementedError('Platform not supported.');
    }
  }
}
