import 'package:algorand_dart/src/clients/algorand_client.dart';
import 'package:dio/dio.dart';

/// Algorand provides a standalone daemon algorand-indexer that reads committed
/// blocks from the Algorand blockchain and maintains a local database of
/// transactions and accounts that are searchable and indexed.
///
/// A REST API is available which enables application developers to perform
/// rich and efficient queries on accounts, transactions, assets, and so forth.
class IndexerClient extends AlgorandClient {
  static const INDEXER_API_TOKEN = 'X-Indexer-API-Token';

  IndexerClient({
    required String apiUrl,
    String apiKey = '',
    String tokenKey = INDEXER_API_TOKEN,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    bool debug = false,
    bool enableGzip = true,
    Interceptor? logInterceptor,
    Transformer? transformer,
  }) : super(
          apiUrl: apiUrl,
          apiKey: apiKey,
          tokenKey: tokenKey,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
          debug: debug,
          enableGzip: enableGzip,
          logInterceptor: logInterceptor,
          transformer: transformer,
        );
}
