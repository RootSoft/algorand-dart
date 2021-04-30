import 'package:algorand_dart/src/clients/algorand_client.dart';

/// An application connects to the Algorand blockchain through an algod client.
/// The algod client requires a valid algod REST endpoint IP address and
/// algod token from an Algorand node that is connected to the network you plan
/// to interact with.
class AlgodClient extends AlgorandClient {
  static const ALGOD_API_TOKEN = 'X-Algo-API-Token';

  AlgodClient({
    required String apiUrl,
    String apiKey = '',
    String tokenKey = ALGOD_API_TOKEN,
    bool debug = false,
  }) : super(apiUrl: apiUrl, apiKey: apiKey, tokenKey: tokenKey, debug: debug);
}
