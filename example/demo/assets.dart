import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final options = AlgorandOptions(
    algodClient: AlgodClient(
      apiUrl: AlgoExplorer.MAINNET_ALGOD_API_URL,
    ),
    indexerClient: IndexerClient(
      apiUrl: AlgoExplorer.MAINNET_INDEXER_API_URL,
    ),
  );

  final algorand = Algorand(options: options);

  try {
    final response = await algorand.getCreatedAssetsByAddress(
      'GOOSEKPIKOZPEPBMFO7TRRR2EPXLWKOIBLKXJKXWMK2J56SOXWRC3FLNSU',
      perPage: 500,
    );

    print(response.length);
  } on AlgorandException catch (ex) {
    print(ex);
  }
}
