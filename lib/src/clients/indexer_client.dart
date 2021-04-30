import 'package:algorand_dart/src/clients/algorand_client.dart';

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
    bool debug = false,
  }) : super(apiUrl: apiUrl, apiKey: apiKey, tokenKey: tokenKey, debug: debug);
}
