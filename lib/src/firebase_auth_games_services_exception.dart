enum FirebaseAuthGamesServicesExceptionCode {
  /// Failed to sign in the user to Games Services.
  notSignedIntoGamesServices,
}

class FirebaseAuthGamesServicesException implements Exception {
  final FirebaseAuthGamesServicesExceptionCode code;
  final String message;
  final Object? details;

  FirebaseAuthGamesServicesException(
      {required this.code, required this.message, this.details});
}
