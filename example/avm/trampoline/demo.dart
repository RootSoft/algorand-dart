import 'dart:io';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' show dirname, join;

void main() async {
  final algorand = Algorand();

  // Get the contract
  final contract = await getContract();
  print(contract.toString());

  // Get the account
  final accounts = await getAccounts();
  final account1 = accounts[0];
  print('Account 1: ${account1.publicAddress}');

  // Deploy the application - 104370363
  final fundProxyAppId =
      104370363; //await createApp(algorand: algorand, account: account1);
  final fundAppAddress = Address.forApplication(fundProxyAppId);
  print('Created application with id: $fundProxyAppId');

  // Get the suggested transaction params
  var params = await algorand.getSuggestedTransactionParams();
  final payTx = await algorand.createPaymentTransaction(
    sender: account1.address,
    receiver: fundAppAddress,
    amount: BigInt.from(1e5.toInt()),
  );

  // Fund to proxy app
  final sTx = await payTx.sign(account1);
  await algorand.sendTransaction(sTx, waitForConfirmation: true);

  params = params.copyWith(fee: params.minFee * BigInt.from(4));
  final appCreateTx =
      await getAppCreateTx(algorand: algorand, account: account1);
  final pay2Tx = await algorand.createPaymentTransaction(
    sender: account1.address,
    receiver: fundAppAddress,
    amount: BigInt.from(1e5.toInt()),
  );

  // Create atc to handle method calling for us
  final atc = AtomicTransactionComposer();
  atc.addTransaction(
      TransactionWithSigner(transaction: appCreateTx, signer: account1));
  atc.addTransaction(
      TransactionWithSigner(transaction: pay2Tx, signer: account1));

  // Add a method call to "fund" method
  await atc.addMethodCall(MethodCallParams(
    applicationId: fundProxyAppId,
    sender: account1.address,
    method: findMethod(contract, 'fund'),
    params: params,
    signer: account1,
    methodArgs: [],
  ));

  // Run the transaction and wait for the results
  final result = await atc.execute(algorand, waitRounds: 4);

  final appCreateTxn =
      await algorand.getPendingTransactionById(result.transactionIds[0]);
  final appFundTxn =
      await algorand.getPendingTransactionById(result.transactionIds[1]);
  final fundedAppId = appCreateTxn.applicationIndex;
  print('Created new application $fundedAppId');

  // Print out the results
  print('Result of inner app call: ${result.methodResults[0]}');
  print(appFundTxn);
}

Future<AbiContract> getContract() async {
  // Read in the contract
  final contractPath = join(dirname(Platform.script.path), 'contract.json');
  return AbiContract.fromFile(contractPath);
}

AbiMethod? findMethod(AbiContract contract, String name) {
  return contract.methods.firstWhereOrNull((m) => m.name == name);
}

Future<List<Account>> getAccounts() async {
  final words1 =
      'clip weird cement usual lecture move expose key later boat romance barely maple trip matrix shy boy now erosion snap warm emerge borrow abandon adult';

  final words2 =
      'veteran vital shadow enable arena client face icon couch frog solar crash moral settle spice provide exile awake clarify seek apple sunset leisure absorb young';

  final words3 =
      'shoulder gesture spoon gasp earth question dwarf wagon manage deny belt struggle vacant avocado donor resist convince main practice frequent van eight senior abstract nature';

  final account1 = await Account.fromSeedPhrase(words1.split(' '));
  final account2 = await Account.fromSeedPhrase(words2.split(' '));
  final account3 = await Account.fromSeedPhrase(words3.split(' '));

  print((await account2.seedPhrase).join(' '));
  print((await account3.seedPhrase).join(' '));

  return [account1, account2, account3];
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

Future<ApplicationCreateTransaction> getAppCreateTx({
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

  return transaction;
}
