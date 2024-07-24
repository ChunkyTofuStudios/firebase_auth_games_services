import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:logging/logging.dart';

import 'package:firebase_auth_games_services/src/firebase_auth_games_services_platform_interface.dart';

/// An implementation of [FirebaseAuthGamesServicesPlatform] that uses method channels.
class MethodChannelFirebaseAuthGamesServices
    extends FirebaseAuthGamesServicesPlatform {
  static final Logger _log = Logger('FirebaseAuthGamesServices');

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('firebase_auth_games_services');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> isSignedIn() async {
    final bool result;
    try {
      result = await methodChannel.invokeMethod<bool>('isSignedIn') ?? false;
    } on PlatformException catch (e) {
      _log.severe('Failed to check if user is signed in: ${e.message}');
      return false;
    }
    return result;
  }

  @override
  Future<String?> getAuthCode() async {
    final String? authCode;
    try {
      authCode = await methodChannel.invokeMethod<String>('getAuthCode');
    } on PlatformException catch (e) {
      _log.severe('Failed to get auth code: ${e.message}');
      return null;
    }
    _log.fine('AuthCode is: $authCode');
    return authCode;
  }

  @override
  Future<String?> signIn() async {
    final String? authCode;
    try {
      authCode = await methodChannel.invokeMethod<String>('signIn');
    } on PlatformException catch (e) {
      _log.severe('Failed to get auth code: ${e.message}');
      return null;
    }
    _log.fine('AuthCode is: $authCode');
    return authCode;
  }
}
