import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final options = AlgorandOptions(
    mainnet: true,
    debug: true,
  );

  final algorand = Algorand(options: options);

  algorand.registerError('result negative', ResultNegativeError());

  try {
    final account = await Account.random();
    print(account.publicAddress);

    final paymentTx = await algorand.createPaymentTransaction(
      sender: account.address,
      receiver: account.address,
      amount: Algo.toMicroAlgos(1.0),
    );

    final signedTx = await paymentTx.sign(account);
    final txId = await algorand.sendTransaction(signedTx);

    print(txId);
    print(account);
  } on AlgorandException catch (ex) {
    print(ex.message);
    if (ex.error is OverspendError) {
      print('overspend');
    }
  }
}

class ResultNegativeError extends AlgorandError {}
