import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

void main() async {
  final options = AlgorandOptions(
    algodClient: AlgodClient(apiUrl: AlgoExplorer.MAINNET_ALGOD_API_URL),
    indexerClient: IndexerClient(apiUrl: AlgoExplorer.MAINNET_INDEXER_API_URL),
  );
  final algorand = Algorand(options: options);

  // final file = File('/Users/tomas/Downloads/26031514');
  // final bytes = file.readAsBytesSync();
  // final decoded = Encoder.decodeMessagePack(Uint8List.fromList(bytes));
  // final block = AlgodBlock.fromJson(decoded['block'] as Map<String, dynamic>);
  // print(decoded.length);

  // Response<List<int>> rs;
  // rs = await Dio().get<List<int>>(
  //   'https://node.algoexplorerapi.io/v2/blocks/26031514?format=msgpack',
  //   options: Options(
  //       responseType: ResponseType.bytes), // set responseType to `bytes`
  // );
  //
  // print(rs.data?.length);
  //
  /// 26031514 - gd
  /// 26189667 - ld
  ///26190419 - itx
  try {
    final block = await algorand.getBlockByRound(
      17411560,
      cancelToken: CancelToken(),
      onSendProgress: (count, total) {},
      onReceiveProgress: (count, total) {},
    );

    final result = block.transactions
        .where((tx) => tx.applicationTransaction != null)
        .toList();
    print(result);
    print(block);
    //final block2 = await algorand.indexer().getBlockByRound(26031514);
    // print(block);
    //print(block2);
  } on AlgorandException catch (ex) {
    print(ex);
  }
}
