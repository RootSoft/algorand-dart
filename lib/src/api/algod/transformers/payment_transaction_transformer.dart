import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod/transformers/algod_transformer.dart';

class PaymentTransactionTransformer
    extends AlgodTransformer<RawTransaction, PaymentTransactionResponse?> {
  const PaymentTransactionTransformer();

  @override
  PaymentTransactionResponse? transform(RawTransaction input) {
    if (input is! PaymentTransaction) {
      return null;
    }

    return PaymentTransactionResponse(
      amount: BigInt.from(input.amount ?? 0),
      closeAmount: input.closeAmount ?? 0,
      receiver: input.receiver?.encodedAddress ?? '',
      closeRemainderTo: input.closeRemainderTo?.encodedAddress,
    );
  }
}
