import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth_games_services/firebase_auth_games_services.dart';
import 'package:firebase_auth_games_services_example/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = FirebaseAuthGamesServices()..enableDebugLogging(true);

  String _platformVersion = 'Unknown';
  User? _user;
  StreamSubscription<User?>? _authStateListener;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    listenForAuthChanges();
  }

  @override
  void dispose() {
    _authStateListener?.cancel();
    _authStateListener = null;
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _plugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void listenForAuthChanges() {
    _authStateListener?.cancel();
    _authStateListener = null;

    _authStateListener =
        FirebaseAuth.instance.userChanges().listen((User? user) {
      if (!mounted) return;
      setState(() {
        _user = user;
      });
      log('User changed: ${user?.uid}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Auth Games Services demo'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion'),
              const SizedBox(height: 6),
              Text('Logged in: ${_user != null}'),
              const SizedBox(height: 6),
              Text(
                'Login providers:\n${_user?.providerData.map((provider) => '${provider.providerId} -> ${provider.uid}').toList().join('\n')}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text('Is anonymous: ${_user?.isAnonymous}'),
              const SizedBox(height: 6),
              Text('UID: ${_user?.uid}'),
              const SizedBox(height: 6),
              Text('Display name: ${_user?.displayName}'),
              const SizedBox(height: 6),
              Text('Email: ${_user?.email}'),
              const SizedBox(height: 6),
              Text('Email verified: ${_user?.emailVerified}'),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Photo: ${_user?.photoURL == null ? 'null' : ''}'),
                  if (_user?.photoURL != null)
                    Image.network(_user!.photoURL!, width: 150),
                ],
              ),
              const SizedBox(height: 6),
              Text('Account creation: ${_user?.metadata.creationTime}'),
              const SizedBox(height: 6),
              Text('Last sign in: ${_user?.metadata.lastSignInTime}'),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithGamesServices();
                  } catch (e) {
                    debugPrint('Sign in failed: ${e.toString()}');
                  }
                },
                child: const Text('Sign in'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    debugPrint('Sign out failed: ${e.toString()}');
                  }
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
