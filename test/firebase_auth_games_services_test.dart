import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:firebase_auth_games_services/firebase_auth_games_services.dart';
import 'package:firebase_auth_games_services/firebase_auth_games_services_method_channel.dart';
import 'package:firebase_auth_games_services/firebase_auth_games_services_platform_interface.dart';

class MockFirebaseAuthGamesServicesPlatform
    with MockPlatformInterfaceMixin
    implements FirebaseAuthGamesServicesPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> login() => Future.value('abc123');
}

void main() {
  final FirebaseAuthGamesServicesPlatform initialPlatform =
      FirebaseAuthGamesServicesPlatform.instance;

  test('$MethodChannelFirebaseAuthGamesServices is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelFirebaseAuthGamesServices>());
  });

  test('getPlatformVersion', () async {
    FirebaseAuthGamesServices firebaseAuthGamesServicesPlugin =
        FirebaseAuthGamesServices();
    MockFirebaseAuthGamesServicesPlatform fakePlatform =
        MockFirebaseAuthGamesServicesPlatform();
    FirebaseAuthGamesServicesPlatform.instance = fakePlatform;

    expect(await firebaseAuthGamesServicesPlugin.getPlatformVersion(), '42');
  });
}
