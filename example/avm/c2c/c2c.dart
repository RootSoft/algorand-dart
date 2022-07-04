import 'dart:convert';
import 'dart:io';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/abi/abi_contract.dart';
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

  // Get the contract
  final contract = await getContract();
  print(contract.toString());

  // Get the account
  final account = await getAccount();
  print('Using account ${account.publicAddress}');

  // Deploy the application - 97954583
  final applicationId = await createApp(algorand: algorand, account: account);
  print('Created application with id: $applicationId');

  final address = Address.forApplication(applicationId);
}

Future<AbiContract> getContract() async {
  // Read in the contract
  final contractPath = join(dirname(Platform.script.path), 'contract.json');
  final contractSrc = await File(contractPath).readAsString();
  final data = jsonDecode(contractSrc) as Map<String, dynamic>;
  return AbiContract.fromJson(data);
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
