import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:path/path.dart' show dirname, join;

/// See https://github.com/algorand-devrel/demo-avm1/tree/6f2a9ef87162bcb9f7d6db0b085e68191a887d7d/op-pool
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

  // App call with 1 transaction
  await appCallWithOneTransaction(
    algorand: algorand,
    account: account,
    applicationId: applicationId,
  );

  // App call with 3 transactions
  // Only the first transaction passes the verify args,
  // the others are used to increase pooled opcode budget
  await appCallWithThreeTransactions(
    algorand: algorand,
    account: account,
    applicationId: applicationId,
  );
}

Future appCallWithOneTransaction({
  required Algorand algorand,
  required Account account,
  required int applicationId,
}) async {
  try {
    final verify = 'a' * 64;

    // Group the transactions
    final transactions = [
      await getApplicationCallTransaction(
        algorand: algorand,
        account: account,
        applicationId: applicationId,
        arguments: [
          Uint8List.fromList(utf8.encode(verify)),
          Uint8List.fromList(utf8.encode(verify)),
        ],
      )
    ];

    // Sign the transactions
    final futures =
        transactions.map((tx) async => await tx.sign(account)).toList();
    final signedTxs = await Future.wait(futures);

    // Broadcast the transactions
    final txId = await algorand.sendTransactions(signedTxs);
    print('Sending single transaction with tx id: $txId');

    // Wait for confirmation
    final pendingTx = await algorand.waitForConfirmation(txId);
    print('Result confirmed in round: ${pendingTx.confirmedRound}');
  } catch (ex) {
    print('failed to call single app call: $ex');
  }
}

Future appCallWithThreeTransactions({
  required Algorand algorand,
  required Account account,
  required int applicationId,
}) async {
  try {
    final verify = 'r' * 64;

    // Group the transactions
    final transactions = AtomicTransfer.group([
      await getApplicationCallTransaction(
        algorand: algorand,
        account: account,
        applicationId: applicationId,
        arguments: [
          Uint8List.fromList(utf8.encode(verify)),
          Uint8List.fromList(utf8.encode(verify)),
        ],
      ),
      await getApplicationCallTransaction(
        algorand: algorand,
        account: account,
        applicationId: applicationId,
        arguments: [],
      ),
      await getApplicationCallTransaction(
        algorand: algorand,
        account: account,
        applicationId: applicationId,
        arguments: [],
      )
    ]);

    // Sign the transactions
    final futures =
        transactions.map((tx) async => await tx.sign(account)).toList();
    final signedTxs = await Future.wait(futures);

    // Broadcast the transactions
    final txId = await algorand.sendTransactions(signedTxs);
    print('Sending grouped transactions with tx id: $txId');

    // Wait for confirmation
    final pendingTx = await algorand.waitForConfirmation(txId);
    print('Result confirmed in round: ${pendingTx.confirmedRound}');
  } catch (ex) {
    print('failed to call single app call: $ex');
  }
}

Future<Account> getAccount() async {
  final words1 =
      // ignore: lines_longer_than_80_chars
      'clip weird cement usual lecture move expose key later boat romance barely maple trip matrix shy boy now erosion snap warm emerge borrow abandon adult';

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

Future<ApplicationBaseTransaction> getApplicationCallTransaction({
  required Algorand algorand,
  required Account account,
  required int applicationId,
  required List<Uint8List> arguments,
}) async {
  // Get the suggested transaction parameters
  final params = await algorand.getSuggestedTransactionParams();

  // Create the application
  // Add random note field to prevent dupe transaction ids
  final transaction = await (ApplicationCallTransactionBuilder()
        ..sender = account.address
        ..onCompletion = OnCompletion.NO_OP_OC
        ..applicationId = applicationId
        ..arguments = arguments
        ..noteText = getRandomString(10)
        ..suggestedParams = params)
      .build();

  return transaction;
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
