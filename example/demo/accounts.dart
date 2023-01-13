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
          '4SOZXGYC5MGZ4S24LX3MHOLYVBZNOHNUN5MP4E5TLX6TXP22BZ6KNN4UQI',
          round: 26054963,
          exclude: [Exclude.assets, Exclude.createdAssets],
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
