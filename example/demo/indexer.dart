import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final options = AlgorandOptions(
    mainnet: false,
  );
  final algorand = Algorand(options: options);

  try {
    final transactions = await algorand.indexer().getAssetById(
          408947,
          includeAll: false,
        );
    print(transactions);
  } on AlgorandException catch (ex) {
    print(ex.message);
  }
}
