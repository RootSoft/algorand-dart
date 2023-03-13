import 'package:algorand_dart/src/exceptions/algorand_factory.dart';
import 'package:algorand_dart/src/exceptions/exceptions.dart';
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

  factory AlgorandException.fromDioError(DioError error) {
    return AlgorandException(
      statusCode: error.response?.statusCode,
      message: error.message,
      cause: error,
    );
  }

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

  AlgorandError? get error {
    return AlgorandFactory().tryParse(message);
  }
}
