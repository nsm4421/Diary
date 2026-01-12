class Failure {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  Failure({required this.message, this.error, this.stackTrace});

  Failure copyWith({String? message, Object? error, StackTrace? stackTrace}) {
    return Failure(
      message: message ?? this.message,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }
}
