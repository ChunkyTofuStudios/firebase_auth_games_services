import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:logging/logging.dart';

import 'firebase_auth_games_services_platform_interface.dart';

/// An implementation of [FirebaseAuthGamesServicesPlatform] that uses method channels.
class MethodChannelFirebaseAuthGamesServices
    extends FirebaseAuthGamesServicesPlatform {
  static final Logger _log = Logger('MethodChannelFirebaseAuthGamesServices');

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
  Future<String?> login() async {
    final playerId = await methodChannel.invokeMethod<String>('signInSilently');
    _log.fine('Player ID is: $playerId');
    return 'done';
  }
}
