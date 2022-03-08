import 'package:dio/dio.dart';

class AlgorandException implements Exception {
  final String _message;
  final Object? cause;

  AlgorandException({String message = '', this.cause}) : _message = message;

  String get message {
    final cause = this.cause;
    if (cause is! DioError) {
      return _message;
    }

    final message = cause.response?.data['message'];

    if (message is! String) {
      return _message;
    }

    return message;
  }
}
