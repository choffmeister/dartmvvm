class ValidationError {
  String _message;

  String get message() => _message;

  ValidationError(String message) : _message = message;

  String toString() => message;
}