/// Core exceptions for the Weesh application interacting with external services
class WeeshNetworkException implements Exception {
  const WeeshNetworkException(this.message);
  final String message;

  @override
  String toString() => 'WeeshNetworkException: $message';
}

class WeeshAuthException implements Exception {
  const WeeshAuthException(this.message);
  final String message;

  @override
  String toString() => 'WeeshAuthException: $message';
}

class WeeshAuthCancelledException implements Exception {
  const WeeshAuthCancelledException();

  @override
  String toString() => 'WeeshAuthCancelledException: User cancelled the flow.';
}
