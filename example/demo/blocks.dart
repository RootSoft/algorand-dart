import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

void main() async {
  final options = AlgorandOptions(
    algodClient: AlgodClient(apiUrl: AlgoExplorer.MAINNET_ALGOD_API_URL),
    indexerClient: IndexerClient(apiUrl: AlgoExplorer.MAINNET_INDEXER_API_URL),
  );
  final algorand = Algorand(options: options);

  /// 26031514 - gd
  /// 26189667 - ld
  /// 26190419 - itx
  /// 17411560 - asset config
  try {
    final block = await algorand.getBlockByRound(
      26190419,
      cancelToken: CancelToken(),
      onSendProgress: (count, total) {},
      onReceiveProgress: (count, total) {},
    );

    print(block);
  } on AlgorandException catch (ex) {
    print(ex);
  }
}
