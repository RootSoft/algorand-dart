import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

void main() async {
  final options = AlgorandOptions(
    mainnet: true,
    debug: true,
    connectTimeout: const Duration(seconds: 5),
  );

  final algorand = Algorand(options: options);

  final client = IndexerClient(apiUrl: AlgoExplorer.MAINNET_INDEXER_API_URL);
  final response = await client.client.get(
      '/v2/accounts/GOOSEKPIKOZPEPBMFO7TRRR2EPXLWKOIBLKXJKXWMK2J56SOXWRC3FLNSU?exclude=assets,created-assets');
  print(response);

  try {
    final x = await Account.random();
    print(x.publicAddress);
    final account = await algorand.indexer().getAccountByAddress(
          '4SOZXGYC5MGZ4S24LX3MHOLYVBZNOHNUN5MP4E5TLX6TXP22BZ6KNN4UQI',
          throwOnEmptyBalance: false,
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
