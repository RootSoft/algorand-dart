import 'package:dio/dio.dart';

class AlgorandException implements Exception {
  final int errorCode;
  final int? statusCode;
  final String _message;
  final Object? cause;

  AlgorandException({
    this.errorCode = 0,
    String message = '',
    this.statusCode,
    this.cause,
  }) : _message = message;

  String get message {
    final cause = this.cause;
    if (cause is! DioError) {
      return _message;
    }

    final message = cause.response?.data?['message'];

    if (message is! String) {
      return _message;
    }

    return message;
  }

  TxError get error {
    if (message.contains('overspend')) {
      return TxError.overspend;
    }

    return TxError.generic;
  }
}

enum TxError {
  generic,
  overspend,
}
