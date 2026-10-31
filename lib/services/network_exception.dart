class FetchException implements Exception {
  const FetchException(this.message);

  final String message;

  @override
  String toString() => message;
}
