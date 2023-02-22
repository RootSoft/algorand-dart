import 'dart:io';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:convert/convert.dart';
import 'package:path/path.dart' show dirname, join;

void main() async {
  final seed = hex.decode(
      'c802e0424ee04151c0aafeae335ef79c45e3d06b51b1c69dae160c2f96271b6a');

  final account = await Account.fromSeed(seed);
  print(account.publicAddress);
  print(account.address.encodedAddress);

  final options = AlgorandOptions(
    debug: true,
  );

  final algorand = Algorand(options: options);

  try {
    final appId = await createApp(algorand: algorand, account: account);
    print(appId);
    //final appId = 160489385;
    final appAddress = Address.forApplication(appId);

    final tx = await algorand.createApplicationCallTransaction(
      sender: account.address,
      applicationId: appId,
      appBoxReferences: [
        AppBoxReference.utf8(applicationId: appId, name: 'BoxA'),
      ],
    );

    final signedTx = await tx.sign(account);
    final txId = await algorand.sendTransaction(signedTx);
    final pendingTx = await algorand.waitForConfirmation(txId);
    print(txId);
    print(pendingTx);

    final box = await algorand.getBox(appId, 'str:BoxA');
    final indexerBox = await algorand.indexer().getBox(appId, 'str:BoxA');
    print(box);
    print(indexerBox);

    final boxes = await algorand.getBoxNames(appId);
    final indexerBoxes = await algorand.indexer().getBoxNames(
          appId,
          perPage: 100,
        );
    print(boxes);
    print(indexerBoxes);

    final accountX =
        await algorand.getAccountByAddress(appAddress.encodedAddress);
    print(accountX);
  } on AlgorandException catch (ex) {
    print(ex.message);
  }
}

Future<int> createApp({
  required Algorand algorand,
  required Account account,
}) async {
  // Get the suggested transaction parameters
  final params = await algorand.getSuggestedTransactionParams();

  // Read in approval teal source & compile
  final approvalPath =
      join(dirname(Platform.script.path), 'build/approval.teal');
  final approval = await File(approvalPath).readAsString();
  final appResult = await algorand.compileTEAL(approval);

  // Read in clear teal source & compile
  final clearPath =
      join(dirname(Platform.script.path), 'build/clear_state.teal');
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
