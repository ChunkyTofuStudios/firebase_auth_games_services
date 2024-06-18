enum FirebaseAuthGamesServicesExceptionCode {
  notSignedIntoGamesServices,
}

class FirebaseAuthGamesServicesException implements Exception {
  final FirebaseAuthGamesServicesExceptionCode code;
  final String message;
  final Object? details;

  FirebaseAuthGamesServicesException(
      {required this.code, required this.message, this.details});
}
