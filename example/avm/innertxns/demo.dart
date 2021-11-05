import 'dart:io';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:path/path.dart' show dirname, join;

void main() async {
  final algodClient = AlgodClient(
    apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL,
  );

  final indexerClient = IndexerClient(
    apiUrl: AlgoExplorer.TESTNET_INDEXER_API_URL,
  );

  final algorand = Algorand(
    algodClient: algodClient,
    indexerClient: indexerClient,
  );

  // Get the account
  final account = await getAccount();
  print('Using account ${account.publicAddress}');

  // Deploy the application
  final applicationId = await createApp(algorand: algorand, account: account);
  print('Created application with id: $applicationId');

  // Get the application address
  final applicationAddress = Address.forApplication(applicationId);
  print('Application address: ${applicationAddress.encodedAddress}');

  // Group the transactions
  final transactions = AtomicTransfer.group([
    await getFundTransaction(
      algorand: algorand,
      sender: account,
      receiver: applicationAddress,
      amount: 500000,
    ),
    await getApplicationCallTransaction(
      algorand: algorand,
      account: account,
      applicationId: applicationId,
      arguments: 'str:inner-txn-demo,str:itxnd,int:1000',
    )
  ]);

  // Sign the transactions
  final futures =
      transactions.map((tx) async => await tx.sign(account)).toList();
  final signedTxs = await Future.wait(futures);

  // TODO Write dryrun

  // Broadcast the transactions
  final txId = await algorand.sendTransactions(signedTxs);
  print('Sending grouped transactions with tx id: $txId');

  // Wait for confirmation
  final pendingTx = await algorand.waitForConfirmation(txId);
  print('Result confirmed in round: ${pendingTx.confirmedRound}');

  // Get the account information from the application address
  final application =
      await algorand.getAccountByAddress(applicationAddress.encodedAddress);
  print('The application account has created: ');
  for (var asa in application.assets) {
    print('\t$asa');
  }
}

Future<Account> getAccount() async {
  final words1 =
      // ignore: lines_longer_than_80_chars
      'differ cupboard cruel enact busy empower fun tonight fog demand pencil zebra tool brick emerge ankle start rude grief certain offer tiny potato abandon dove';

  return Account.fromSeedPhrase(words1.split(' '));
}

Future<int> createApp({
  required Algorand algorand,
  required Account account,
}) async {
  // Get the suggested transaction parameters
  final params = await algorand.getSuggestedTransactionParams();

  // Read in approval teal source & compile
  final approvalPath = join(dirname(Platform.script.path), 'approval.teal');
  final approval = await File(approvalPath).readAsString();
  final appResult = await algorand.applicationManager.compileTEAL(approval);

  // Read in clear teal source & compile
  final clearPath = join(dirname(Platform.script.path), 'clear.teal');
  final clear = await File(clearPath).readAsString();
  final clearResult = await algorand.applicationManager.compileTEAL(clear);

  // Create the application
  final transaction = await (ApplicationCreateTransactionBuilder()
        ..sender = account.address
        ..approvalProgram = appResult.program
        ..clearStateProgram = clearResult.program
        ..globalStateSchema = StateSchema(
          numUint: 0,
          numByteSlice: 0,
        )
        ..localStateSchema = StateSchema(
          numUint: 0,
          numByteSlice: 0,
        )
        ..suggestedParams = params)
      .build();

  // Sign the transaction
  final signedTx = await transaction.sign(account);

  // Broadcast the transaction
  final txId = await algorand.sendTransaction(signedTx);

  // Wait for confirmation
  final pendingTx = await algorand.waitForConfirmation(txId);
  final applicationIndex = pendingTx.applicationIndex;
  if (applicationIndex == null) {
    throw ArgumentError('');
  }

  return applicationIndex;
}

Future<PaymentTransaction> getFundTransaction({
  required Algorand algorand,
  required Account sender,
  required Address receiver,
  required int amount,
}) async {
  // Get the suggested transaction parameters
  final params = await algorand.getSuggestedTransactionParams();

  // Create the application
  final transaction = await (PaymentTransactionBuilder()
        ..sender = sender.address
        ..receiver = receiver
        ..amount = amount
        ..suggestedParams = params)
      .build();

  return transaction;
}

Future<ApplicationBaseTransaction> getApplicationCallTransaction({
  required Algorand algorand,
  required Account account,
  required int applicationId,
  required String arguments,
}) async {
  // Get the suggested transaction parameters
  final params = await algorand.getSuggestedTransactionParams();

  // Create the application
  final transaction = await (ApplicationCallTransactionBuilder()
        ..sender = account.address
        ..onCompletion = OnCompletion.NO_OP_OC
        ..applicationId = applicationId
        ..arguments = arguments.toApplicationArguments()
        ..suggestedParams = params)
      .build();

  return transaction;
}
