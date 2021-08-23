import 'package:algorand_dart/src/clients/algorand_client.dart';
import 'package:algorand_kmd/algorand_kmd.dart';

class KmdClient extends AlgorandClient {
  static const KMD_API_TOKEN = 'X-KMD-API-Token';

  late final AlgorandKmd api;

  KmdClient({
    required String apiUrl,
    String apiKey = '',
    String tokenKey = KMD_API_TOKEN,
    bool debug = false,
  }) : super(apiUrl: apiUrl, apiKey: apiKey, tokenKey: tokenKey, debug: debug) {
    api = AlgorandKmd(dio: client);
  }
}
