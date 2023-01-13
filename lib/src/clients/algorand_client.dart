import 'package:dio/dio.dart';

abstract class AlgorandClient {
  /// The http client
  late final Dio client;

  AlgorandClient({
    required String apiUrl,
    required String apiKey,
    required String tokenKey,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    bool debug = false,
    Interceptor? logInterceptor,
  }) {
    final options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: connectTimeout.inMilliseconds,
      receiveTimeout: receiveTimeout.inMilliseconds,
      sendTimeout: sendTimeout.inMilliseconds,
      headers: {
        tokenKey: apiKey,
      },
    );

    client = Dio(options);

    if (debug) {
      client.interceptors.add(logInterceptor ?? LogInterceptor());
    }
  }

  /// Create a new Algorand Client with the given Dio instance.
  AlgorandClient.dio(Dio dio) : client = dio;
}
