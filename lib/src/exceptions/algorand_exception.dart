class AlgorandException implements Exception {
  final String message;
  final Object? cause;

  AlgorandException({this.message = '', this.cause});
}
