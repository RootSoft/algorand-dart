import 'package:dio/dio.dart';

abstract class AlgorandClient {
  /// The API rest endpoint
  final String apiUrl;

  /// The API key
  final String apiKey;

  /// The token header key
  final String tokenKey;

  /// The http client
  late final Dio client;

  AlgorandClient({
    required this.apiUrl,
    required this.apiKey,
    required this.tokenKey,
  }) {
    BaseOptions options = new BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: Duration(seconds: 30).inMilliseconds,
      receiveTimeout: Duration(seconds: 30).inMilliseconds,
      headers: {
        tokenKey: apiKey,
      },
    );

    client = Dio(options);
    client.interceptors.add(LogInterceptor());
  }
}
