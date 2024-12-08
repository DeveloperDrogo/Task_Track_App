class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message; // This will return the message instead of the instance type
}

