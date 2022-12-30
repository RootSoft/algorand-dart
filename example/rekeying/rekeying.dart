import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final algorand = Algorand();

  // NNFYGNORBVVIIGI3ZPDBIDR6BQ2AM2K6UTZHIFXB7KBTEVZE337FHDGW6E
  final account1 = await getAccount();
  final account2 = await getAccount2();
  final seedphrase1 = await account1.seedPhrase;
  final seedphrase2 = await account2.seedPhrase;

  print('Account 1: ${account1.publicAddress}');
  print('${seedphrase1.join(' ')}');
  print('Account 2: ${account2.publicAddress}');
  print('${seedphrase2.join(' ')}');

  final params = await algorand.getSuggestedTransactionParams();

  final tx = await (PaymentTransactionBuilder()
        ..sender = account1.address
        ..receiver = account1.address
        ..amount = Algo.toMicroAlgos(0)
        ..rekeyTo = account2.address
        ..suggestedParams = params)
      .build();

  // Sign the transaction
  final signedTx = await tx.sign(account1);

  try {
    // Broadcast the tx
    final txId = await algorand.sendTransaction(signedTx);

    // Wait for confirmation
    final pendingTx = await algorand.waitForConfirmation(txId);
    print(txId);
    print(pendingTx);
  } on AlgorandException catch (ex) {
    print(ex);
  }
}

Future<Account> getAccount() async {
  // NNFYGNORBVVIIGI3ZPDBIDR6BQ2AM2K6UTZHIFXB7KBTEVZE337FHDGW6E
  final words1 =
      // ignore: lines_longer_than_80_chars
      'lake three recipe bag trade barely march hello actress unlock pumpkin garden try pistol theory ability dignity various glad post weasel jeans save abandon zoo';

  return Account.fromSeedPhrase(words1.split(' '));
}

Future<Account> getAccount2() async {
  // IRAQQORQZO6VVI7T3UTKBK5EDKAKYG5EJLEL3BGHAFAIAEPGI6AYPOAO3I
  final words1 =
      // ignore: lines_longer_than_80_chars
      'electric decorate believe bench print rally credit decade carry fashion leave laundry skull little enact goat please turn inmate blossom busy secret faith absent bunker';

  return Account.fromSeedPhrase(words1.split(' '));
}
