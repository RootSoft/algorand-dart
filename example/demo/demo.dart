import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

void main() async {
  final options = AlgorandOptions();
  final algorand = Algorand(options: options);

  try {
    final round = BigInt.from(26031514);
    final block = await algorand.getBlockByRound(
      round,
      cancelToken: CancelToken(),
      onSendProgress: (count, total) {},
      onReceiveProgress: (count, total) {},
    );

    final block2 = await algorand.indexer().getBlockByRound(round);
    print(block);
    print(block2);
  } on AlgorandException catch (ex) {
    print(ex);
  }
}
