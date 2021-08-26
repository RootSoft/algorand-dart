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

  final arguments = <Uint8List>[];
  arguments.add(Uint8List.fromList([123]));

  final result = await algorand.applicationManager.compileTEAL(sampleArgsTeal);
  final logicSig = await LogicSignature.fromProgram(
    program: result.program,
    arguments: arguments,
  ).sign(account: account);

  final receiver = 'KTFZ5SQU3AQ6UFYI2QOWF5X5XJTAFRHACWHXAZV6CPLNKS2KSGQWPT4ACE';
  final params = await algorand.getSuggestedTransactionParams();
  final transaction = await (PaymentTransactionBuilder()
        ..sender = account.address
        ..noteText = 'Account delegation'
        ..amount = 100000
        ..receiver = Address.fromAlgorandAddress(address: receiver)
        ..suggestedParams = params)
      .build();

  // Sign the logic transaction
  final signedTx = await logicSig.signTransaction(transaction: transaction);

  // Send the transaction
  final txId = await algorand.sendTransaction(
    signedTx,
    waitForConfirmation: true,
  );

  print(txId);
}

final sampleArgsTeal = '''
// samplearg.teal
// This code is meant for learning purposes only
// It should not be used in production
arg_0
btoi
int 123
==
''';
