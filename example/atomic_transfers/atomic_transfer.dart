import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final algodClient = AlgodClient(
    apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL,
  );

  final algorand = Algorand(algodClient: algodClient);

  final words1 =
      // ignore: lines_longer_than_80_chars
      'year crumble opinion local grid injury rug happy away castle minimum bitter upon romance federal entire rookie net fabric soft comic trouble business above talent';

  final words2 =
      // ignore: lines_longer_than_80_chars
      'beauty nurse season autumn curve slice cry strategy frozen spy panic hobby strong goose employ review love fee pride enlist friend enroll clip ability runway';

  final words3 =
      // ignore: lines_longer_than_80_chars
      'picnic bright know ticket purity pluck stumble destroy ugly tuna luggage quote frame loan wealth edge carpet drift cinnamon resemble shrimp grain dynamic absorb edge';

  final account1 = await Account.fromSeedPhrase(words1.split(' '));
  final account2 = await Account.fromSeedPhrase(words2.split(' '));
  final account3 = await Account.fromSeedPhrase(words3.split(' '));

  print('Account 1: ${account1.publicAddress}');
  print('Account 2: ${account2.publicAddress}');
  print('Account 3: ${account3.publicAddress}');

  // Get the suggested transaction params
  final params = await algorand.getSuggestedTransactionParams();

  // Create the first transaction
  final tx1 = await (PaymentTransactionBuilder()
        ..sender = account1.address
        ..receiver = account3.address
        ..amount = 10000
        ..suggestedParams = params)
      .build();

  // Create the second transaction
  final tx2 = await (PaymentTransactionBuilder()
        ..sender = account2.address
        ..receiver = account1.address
        ..amount = 20000
        ..suggestedParams = params)
      .build();

  // Group the transaction
  AtomicTransfer.group([tx1, tx2]);

  // Sign the transaction
  final signedTx1 = await tx1.sign(account1);
  final signedTx2 = await tx2.sign(account2);

  final txId = await algorand.sendTransactions([signedTx1, signedTx2]);
  final response = await algorand.waitForConfirmation(txId);
  print(response);
  print(txId);
}
