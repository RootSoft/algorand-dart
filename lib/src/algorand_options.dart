import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

class AlgorandOptions {
  final AlgodClient algodClient;

  final IndexerClient indexerClient;

  /// The timeout parameter indicates how many rounds you wish to check
  /// pending transactions for. Defaults to 5.
  final int timeout;

  /// The timeout parameter indicates how many rounds you wish to check
  /// pending transactions for. Defaults to 5.
  final bool debug;

  AlgorandOptions._({
    required this.algodClient,
    required this.indexerClient,
    required this.timeout,
    required this.debug,
  });

  factory AlgorandOptions({
    AlgodClient? algodClient,
    IndexerClient? indexerClient,
    bool mainnet = false,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    int timeout = 5,
    bool debug = false,
    bool enableGzip = true,
    Interceptor? logInterceptor,
    Transformer? transformer,
  }) {
    final _algodClient = algodClient ??
        AlgodClient(
          apiUrl: mainnet
              ? AlgoExplorer.MAINNET_ALGOD_API_URL
              : AlgoExplorer.TESTNET_ALGOD_API_URL,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
          debug: debug,
          enableGzip: enableGzip,
          logInterceptor: logInterceptor,
          transformer: transformer,
        );

    final _indexerClient = indexerClient ??
        IndexerClient(
          apiUrl: mainnet
              ? AlgoExplorer.MAINNET_INDEXER_API_URL
              : AlgoExplorer.TESTNET_INDEXER_API_URL,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
          debug: debug,
          enableGzip: enableGzip,
          logInterceptor: logInterceptor,
          transformer: transformer,
        );

    return AlgorandOptions._(
      algodClient: _algodClient,
      indexerClient: _indexerClient,
      timeout: timeout,
      debug: debug,
    );
  }

  AlgorandOptions copyWith({
    AlgodClient Function()? algodClient,
    IndexerClient Function()? indexerClient,
    int Function()? timeout,
    bool Function()? debug,
  }) {
    return AlgorandOptions(
      algodClient: algodClient != null ? algodClient() : this.algodClient,
      indexerClient:
          indexerClient != null ? indexerClient() : this.indexerClient,
      timeout: timeout != null ? timeout() : this.timeout,
      debug: debug != null ? debug() : this.debug,
    );
  }
}
