import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final privateKey =
      'ef3cf725a3b4eb3067e2b468eec172ff4ef9333460b811cd04cdd877306500a6';
  final account = await Account.fromPrivateKey(privateKey);
  final assetId = 154661774;
  print(account.publicAddress);

  final options = AlgorandOptions(
    mainnet: false,
    debug: true,
  );

  final algorand = Algorand(options: options);

  try {
    final params = await algorand.getSuggestedTransactionParams();

    final tx1 = await algorand.createAssetCreationTransaction(
      sender: account.address,
      assetName: 'test',
      unitName: 'test',
      decimals: 0,
      note: '1',
      totalAssetsToCreate: BigInt.from(10),
      suggestedParams: params,
    );

    final tx2 = await algorand.createAssetCreationTransaction(
      sender: account.address,
      assetName: 'test',
      unitName: 'test',
      decimals: 0,
      note: '2',
      totalAssetsToCreate: BigInt.from(10),
      suggestedParams: params,
    );

    final txs = AtomicTransfer.group([tx1, tx2]);
    final signedTxs = await Future.wait(txs.map((tx) => tx.sign(account)));

    final txId = await algorand.sendTransactions(signedTxs);
    final pendingTx = await algorand.waitForConfirmation(txId);
    print(pendingTx);
    //final tx1 = await algorand.createAssetTransferTransaction(sender: sender);
  } on AlgorandException catch (ex) {
    print(ex.message);
  }
}
