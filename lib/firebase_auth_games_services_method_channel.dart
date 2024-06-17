import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'firebase_auth_games_services_platform_interface.dart';

/// An implementation of [FirebaseAuthGamesServicesPlatform] that uses method channels.
class MethodChannelFirebaseAuthGamesServices extends FirebaseAuthGamesServicesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('firebase_auth_games_services');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
