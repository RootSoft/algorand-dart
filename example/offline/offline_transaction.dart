import 'dart:io';

import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final algodClient = AlgodClient(
    apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL,
  );

  final algorand = Algorand(algodClient: algodClient);

  final words1 =
      // ignore: lines_longer_than_80_chars
      'year crumble opinion local grid injury rug happy away castle minimum bitter upon romance federal entire rookie net fabric soft comic trouble business above talent';

  final account = await Account.fromSeedPhrase(words1.split(' '));

  print('Account: ${account.publicAddress}');

  final fileName = 'signed.txn';

  // Export the signed transaction
  final file = await exportSignedTransaction(
    algorand: algorand,
    account: account,
    fileName: fileName,
  );

  print(file.path);

  // Import the signed transaction
  final signedTx = await importSignedTransaction(fileName: fileName);

  // Broadcast the transaction
  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(txId);
  print(response);
}

Future<File> exportSignedTransaction({
  required Algorand algorand,
  required Account account,
  required String fileName,
}) async {
  final receiver = Address.fromAlgorandAddress(
    address: 'L5EUPCF4ROKNZMAE37R5FY2T5DF2M3NVYLPKSGWTUKVJRUGIW4RKVPNPD4',
  );

  // Fetch the suggested params
  final params = await algorand.getSuggestedTransactionParams();

  // Create the transaction
  final tx = await (PaymentTransactionBuilder()
        ..sender = account.address
        ..receiver = receiver
        ..amount = 100000
        ..noteText = 'Hello world'
        ..suggestedParams = params)
      .build();

  // Sign the transaction
  final signedTx = await tx.sign(account);

  // Export the signed transaction
  final file = await signedTx.export(fileName);

  return file;
}

Future<SignedTransaction> importSignedTransaction({
  required String fileName,
}) async {
  final b = await File(fileName).readAsBytes();
  return SignedTransaction.fromJson(Encoder.decodeMessagePack(b));
}

void printBalance({
  required Algorand algorand,
  required Account account,
}) async {
  final balance = await algorand.getBalance(account.publicAddress);
  print(balance);
}
