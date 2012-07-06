class ValidationError extends ViewModel {
  String get message() => this['message'];

  ValidationError(String message) {
    this['message'] = message;
  }

  String toString() => message;
}