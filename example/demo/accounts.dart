import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

void main() async {
  final options = AlgorandOptions(
    algodClient: AlgodClient(apiUrl: AlgoExplorer.MAINNET_ALGOD_API_URL),
    indexerClient: IndexerClient(apiUrl: AlgoExplorer.MAINNET_INDEXER_API_URL),
  );
  final algorand = Algorand(options: options);

  try {
    final account = await algorand.indexer().getAccountByAddress(
          'GOOSEKPIKOZPEPBMFO7TRRR2EPXLWKOIBLKXJKXWMK2J56SOXWRC3FLNSU',
          round: 26054963,
          includeAll: false,
          cancelToken: CancelToken(),
          onSendProgress: (count, total) {},
          onReceiveProgress: (count, total) {},
        );

    print(account);
  } on AlgorandException catch (ex) {
    print(ex.message);
  }
}
