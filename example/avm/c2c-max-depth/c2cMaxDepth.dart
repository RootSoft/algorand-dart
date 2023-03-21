import 'dart:io';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' show dirname, join;

void main() async {
  final algorand = Algorand();

  // Get the account
  final account = await getAccount();
  print('Using account ${account.publicAddress}');

  // Deploy the application - 97954583
  final appId = await createApp(algorand: algorand, account: account);
  final appAddress = Address.forApplication(appId);
  print('Created application with id: $appId');

  const depth = 8;

  // Get the suggested transaction params
  var params = await algorand.getSuggestedTransactionParams();
  final p1Tx = await algorand.createPaymentTransaction(
    sender: account.address,
    receiver: appAddress,
    amount: BigInt.from(1000000),
  );

  final appCallTx = await algorand.createApplicationCallTransaction(
    sender: account.address,
    applicationId: appId,
    onCompletion: OnCompletion.DELETE_APPLICATION_OC,
    arguments: [BigInt.from(depth).toUint8List()],
    suggestedParams: params,
  );

  // Cover $depth inner app creates, pays, calls + this call
  final fee = appCallTx.fee;
  if (fee == null) {
    throw ArgumentError('Invalid fee');
  }

  appCallTx.fee = fee * BigInt.from(((depth * 3) + 1));

  final txs = AtomicTransfer.group([p1Tx, appCallTx]);
  final signedTxs = await Future.wait(txs.map((tx) => tx.sign(account)));
  final ids = signedTxs.map((tx) => tx.transactionId).toList();
  await algorand.sendTransactions(signedTxs);
  final result = await Future.wait(ids.map(algorand.waitForConfirmation));

  // Print out the results
  print('Result of inner app call: $result');
}

Future<AbiContract> getContract() async {
  // Read in the contract
  final contractPath = join(dirname(Platform.script.path), 'contract.json');
  return AbiContract.fromFile(contractPath);
}

AbiMethod? findMethod(AbiContract contract, String name) {
  return contract.methods.firstWhereOrNull((m) => m.name == name);
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
  final appResult = await algorand.compileTEAL(approval);

  // Read in clear teal source & compile
  final clearPath = join(dirname(Platform.script.path), 'clear.teal');
  final clear = await File(clearPath).readAsString();
  final clearResult = await algorand.compileTEAL(clear);

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
