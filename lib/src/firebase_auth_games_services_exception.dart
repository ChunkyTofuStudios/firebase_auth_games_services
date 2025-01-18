enum FirebaseAuthGamesServicesExceptionCode {
  /// The platform is not supported.
  /// Note that this plugin only supports Android and iOS.
  gamesServicesNotAvailable,

  /// Failed to sign in the user to Games Services.
  /// This might be because the user cancelled sign-in or because of a more
  /// serious configuration issue.
  notSignedIntoGamesServices,
}

/// Exception thrown when an error occurs in the FirebaseAuthGamesServices
/// plugin.
class FirebaseAuthGamesServicesException implements Exception {
  /// The error code for the exception.
  final FirebaseAuthGamesServicesExceptionCode code;

  /// A developer-facing error message describing what went wrong.
  final String message;

  /// Additional details about the error; such as stack trace or underlying
  /// exception.
  final Object? details;

  FirebaseAuthGamesServicesException(
      {required this.code, required this.message, this.details});

  @override
  String toString() {
    return 'FirebaseAuthGamesServicesException($code, msg=$message, details=$details)';
  }
}
