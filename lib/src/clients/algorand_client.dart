import 'package:dio/dio.dart';

abstract class AlgorandClient {
  /// The http client
  late final Dio client;

  AlgorandClient({
    required String apiUrl,
    required String apiKey,
    required String tokenKey,
    bool debug = false,
  }) {
    final options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 30).inMilliseconds,
      receiveTimeout: const Duration(seconds: 30).inMilliseconds,
      headers: {
        tokenKey: apiKey,
      },
    );

    client = Dio(options);
    if (debug) {
      client.interceptors.add(LogInterceptor());
    }
  }

  /// Create a new Algorand Client with the given Dio instance.
  AlgorandClient.dio(Dio dio) : client = dio;
}
