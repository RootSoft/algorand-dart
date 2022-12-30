import 'package:algorand_dart/algorand_dart.dart';

class AlgorandOptions {
  final AlgodClient algodClient;

  final IndexerClient indexerClient;

  final KmdClient? kmdClient;

  AlgorandOptions._({
    required this.algodClient,
    required this.indexerClient,
    required this.kmdClient,
  });

  factory AlgorandOptions({
    AlgodClient? algodClient,
    IndexerClient? indexerClient,
    KmdClient? kmdClient,
  }) {
    final _algodClient =
        algodClient ?? AlgodClient(apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL);

    final _indexerClient = indexerClient ??
        IndexerClient(apiUrl: AlgoExplorer.TESTNET_INDEXER_API_URL);

    return AlgorandOptions._(
      algodClient: _algodClient,
      indexerClient: _indexerClient,
      kmdClient: kmdClient,
    );
  }
  AlgorandOptions copyWith({
    AlgodClient Function()? algodClient,
    IndexerClient Function()? indexerClient,
    KmdClient Function()? kmdClient,
  }) {
    return AlgorandOptions(
      algodClient: algodClient != null ? algodClient() : this.algodClient,
      indexerClient:
          indexerClient != null ? indexerClient() : this.indexerClient,
      kmdClient: kmdClient != null ? kmdClient() : this.kmdClient,
    );
  }
}
