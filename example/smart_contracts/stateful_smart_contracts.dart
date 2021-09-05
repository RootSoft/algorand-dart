import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final algodClient = AlgodClient(
    apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL,
  );

  final algorand = Algorand(algodClient: algodClient);

  final words =
      // ignore: lines_longer_than_80_chars
      'chronic reason target blood lend major world lottery border top quantum turtle fiber debate impose meadow sport exclude nut window awesome want myself ability chief';
  final account = await Account.fromSeedPhrase(words.split(' '));

  // Create a new application
  final appId = await createApplication(algorand: algorand, account: account);

  // Opt in to the application
  await optIn(algorand: algorand, account: account);

  // Call the application
  final arguments = 'str:arg1,int:12'.toApplicationArguments();
  await callApp(
    algorand: algorand,
    account: account,
    appId: appId,
    arguments: arguments,
  );

  // Read the local state
  await readLocalState(algorand: algorand, account: account, appId: appId);

  // Read the global state
  await readGlobalState(algorand: algorand, account: account, appId: appId);
}

/// Create a new application and return the application id.
Future<int> createApplication({
  required Algorand algorand,
  required Account account,
}) async {
  // declare application state storage (immutable)
  final localInts = 1;
  final localBytes = 1;
  final globalInts = 1;
  final globalBytes = 0;

  final approvalProgram =
      await algorand.applicationManager.compileTEAL(approvalProgramSource);

  final clearProgram =
      await algorand.applicationManager.compileTEAL(clearProgramSource);

  final params = await algorand.getSuggestedTransactionParams();

  final transaction = await (ApplicationCreateTransactionBuilder()
        ..sender = account.address
        ..approvalProgram = approvalProgram.program
        ..clearStateProgram = clearProgram.program
        ..globalStateSchema = StateSchema(
          numUint: globalInts,
          numByteSlice: globalBytes,
        )
        ..localStateSchema = StateSchema(
          numUint: localInts,
          numByteSlice: localBytes,
        )
        ..suggestedParams = params)
      .build();
  final signedTx = await transaction.sign(account);

  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  return response.applicationIndex ?? 0;
}

/// Opt in to the SC
Future<bool> optIn({
  required Algorand algorand,
  required Account account,
}) async {
  final params = await algorand.getSuggestedTransactionParams();

  final transaction = await (ApplicationOptInTransactionBuilder()
        ..sender = account.address
        ..applicationId = 19964146
        ..suggestedParams = params)
      .build();

  final signedTx = await transaction.sign(account);

  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(response);

  return Future.value(true);
}

/// Call application
Future<bool> callApp({
  required Algorand algorand,
  required Account account,
  required int appId,
  required List<Uint8List> arguments,
}) async {
  final params = await algorand.getSuggestedTransactionParams();

  final transaction = await (ApplicationCallTransactionBuilder()
        ..sender = account.address
        ..applicationId = 19964146
        ..arguments = arguments
        ..suggestedParams = params)
      .build();

  final signedTx = await transaction.sign(account);

  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(response);

  return Future.value(true);
}

/// Read local state
Future<bool> readLocalState({
  required Algorand algorand,
  required Account account,
  required int appId,
}) async {
  final addr = 'KTFZ5SQU3AQ6UFYI2QOWF5X5XJTAFRHACWHXAZV6CPLNKS2KSGQWPT4ACE';
  final information = await algorand.getAccountByAddress(addr);
  for (var state in information.appsLocalState) {
    if (state.id == appId) {
      print(state);
    }
  }

  return Future.value(true);
}

/// Read global state
Future<bool> readGlobalState({
  required Algorand algorand,
  required Account account,
  required int appId,
}) async {
  final addr = 'KTFZ5SQU3AQ6UFYI2QOWF5X5XJTAFRHACWHXAZV6CPLNKS2KSGQWPT4ACE';
  final information = await algorand.getAccountByAddress(addr);
  for (var app in information.createdApps) {
    if (app.id == appId) {
      print(app);
    }
  }

  return Future.value(true);
}

/// Close out the app
Future<bool> closeOutApp({
  required Algorand algorand,
  required Account account,
  required int appId,
}) async {
  final params = await algorand.getSuggestedTransactionParams();

  final transaction = await (ApplicationCloseOutTransactionBuilder()
        ..sender = account.address
        ..applicationId = appId
        ..suggestedParams = params)
      .build();

  final signedTx = await transaction.sign(account);

  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(response);

  return Future.value(true);
}

/// Delete the app
Future<bool> deleteApp({
  required Algorand algorand,
  required Account account,
  required int appId,
}) async {
  final params = await algorand.getSuggestedTransactionParams();

  final transaction = await (ApplicationDeleteTransactionBuilder()
        ..sender = account.address
        ..applicationId = appId
        ..suggestedParams = params)
      .build();

  final signedTx = await transaction.sign(account);

  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(response);

  return Future.value(true);
}

/// Clear the state of the app
Future<bool> clearApp({
  required Algorand algorand,
  required Account account,
  required int appId,
}) async {
  final params = await algorand.getSuggestedTransactionParams();

  final transaction = await (ApplicationClearStateTransactionBuilder()
        ..sender = account.address
        ..applicationId = appId
        ..suggestedParams = params)
      .build();

  final signedTx = await transaction.sign(account);

  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(response);

  return Future.value(true);
}

final approvalProgramSource = '''
#pragma version 4

// read global state
byte "counter"
dup
app_global_get

// increment the value
int 1
+

// store to scratch space
dup
store 0

// update global state
app_global_put

// load return value as approval
load 0
return''';

final clearProgramSource = '''
#pragma version 4
int 1
''';
