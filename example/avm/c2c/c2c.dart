import 'dart:io';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' show dirname, join;

void main() async {
  final algorand = Algorand();

  // Get the account
  final account = await getAccount();
  print('Using account ${account.publicAddress}');

  final tx = await algorand.createPaymentTransaction(
    sender: account.address,
    receiver: account.address,
    amount: BigInt.zero,
    note: 'note',
  );

  final signedTx = await tx.sign(account);
  print(signedTx.toBase64());

  // Get the contract
  final contract = await getContract();
  print(contract.toString());

  // Deploy the application - 97954583
  final firstAppId = 97954583;
  final firstAddress = Address.forApplication(firstAppId);
  print('Created application with id: $firstAppId');

  //final secondAppId = await createApp(algorand: algorand, account: account);
  final secondAppId = 104134362;
  final secondAddress = Address.forApplication(secondAppId);
  print('Created application with id: $secondAppId');

  // Get the suggested transaction params
  var params = await algorand.getSuggestedTransactionParams();
  final p1Tx = await algorand.createPaymentTransaction(
    sender: account.address,
    receiver: firstAddress,
    amount: BigInt.from(1000000),
  );

  final p2Tx = await algorand.createPaymentTransaction(
    sender: account.address,
    receiver: secondAddress,
    amount: BigInt.from(1000000),
  );

  final txs = AtomicTransfer.group([p1Tx, p2Tx]);
  final signedTxs = await Future.wait(txs.map((tx) => tx.sign(account)));
  await algorand.sendTransactions(signedTxs, waitForConfirmation: true);

  // Set the fee to 2x min fee, this allows the inner app call to proceed even though the app address is not funded
  params = await algorand.getSuggestedTransactionParams();
  params = params.copyWith(fee: params.minFee * BigInt.from(3));

  // Create atc to handle method calling for us
  final atc = AtomicTransactionComposer();
  await atc.addMethodCall(MethodCallParams(
    applicationId: firstAppId,
    sender: account.address,
    method: findMethod(contract, 'call'),
    params: params,
    signer: account,
    methodArgs: [secondAppId],
  ));

  // Run the transaction and wait for the results
  final result = await atc.execute(algorand, waitRounds: 4);

  // Print out the results
  print('Result of inner app call: ${result.methodResults[0]}');
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
