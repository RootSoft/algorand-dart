import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final options = AlgorandOptions(
    algodClient: AlgodClient(apiUrl: AlgoExplorer.MAINNET_ALGOD_API_URL),
    indexerClient: IndexerClient(apiUrl: AlgoExplorer.MAINNET_INDEXER_API_URL),
  );
  final algorand = Algorand(options: options);

  try {
    final transactions =
        await algorand.indexer().transactions().next(null).search();
    print(transactions);
  } on AlgorandException catch (ex) {
    print(ex.message);
  }
}
