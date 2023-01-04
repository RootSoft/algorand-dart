import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final options = AlgorandOptions();
  final algorand = Algorand(options: options);

  try {
    final block = await algorand.getBlockByRound(
      26031514,
    );

    final block2 = await algorand.indexer().getBlockByRound(26031514);
    print(block);
    print(block2);
  } on AlgorandException catch (ex) {
    print(ex);
  }
}
