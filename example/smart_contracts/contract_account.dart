import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final algodClient = AlgodClient(
    apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL,
  );

  final algorand = Algorand(algodClient: algodClient);
  final arguments = <Uint8List>[];
  arguments.add(Uint8List.fromList([123]));

  final result = await algorand.applicationManager.compileTEAL(sampleArgsTeal);

  final logicSig = LogicSignature.fromProgram(
    program: result.program,
    arguments: arguments,
  );

  final receiver = 'KTFZ5SQU3AQ6UFYI2QOWF5X5XJTAFRHACWHXAZV6CPLNKS2KSGQWPT4ACE';
  final params = await algorand.getSuggestedTransactionParams();
  final transaction = await (PaymentTransactionBuilder()
        ..sender = logicSig.toAddress()
        ..noteText = 'Logic Signature'
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
