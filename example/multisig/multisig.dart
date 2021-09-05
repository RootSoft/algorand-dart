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

  final publicKeys = [account1.address, account2.address, account3.address]
      .map((address) => Ed25519PublicKey(bytes: address.toBytes()))
      .toList();

  final msa = MultiSigAddress(
    version: 1,
    threshold: 2,
    publicKeys: publicKeys,
  );

  print('Multisignature address: ${msa.toString()}');

  // Fetch the suggested params
  final params = await algorand.getSuggestedTransactionParams();

  final tx = await (PaymentTransactionBuilder()
        ..sender = msa.toAddress()
        ..receiver = account3.address
        ..amount = 1000000
        ..noteText = ' These are some notes encoded in some way!'
        ..suggestedParams = params)
      .build();

  // Sign the transaction for two accounts
  final signedTx = await msa.sign(account: account1, transaction: tx);
  final completeTx = await msa.append(account: account2, transaction: signedTx);

  // Broadcast the transaction
  final txId = await algorand.sendTransaction(completeTx);
  final response = await algorand.waitForConfirmation(txId);
  print(txId);
  print(response);
}
