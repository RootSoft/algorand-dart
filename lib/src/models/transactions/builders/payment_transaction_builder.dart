import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/raw_transaction_builder.dart';
import 'package:algorand_dart/src/utils/fee_calculator.dart';

class PaymentTransactionBuilder
    extends RawTransactionBuilder<PaymentTransaction> {
  /// The address of the account that receives the amount.
  Address? receiver;

  /// The total amount to be sent in microAlgos.
  /// Amounts are returned in microAlgos - the base unit for Algos.
  /// Micro denotes a unit x 10^-6. 1 Algo equals 1,000,000 microAlgos.
  BigInt? amount;

  /// When set, indicates that the sending account should be closed and all
  /// remaining funds be transferred to this address.
  Address? closeRemainderTo;

  PaymentTransactionBuilder() : super(TransactionType.PAYMENT);

  @override
  Future<int> estimatedTransactionSize() async {
    return await FeeCalculator.estimateTransactionSize(
      PaymentTransaction.builder(this),
    );
  }

  @override
  Future<PaymentTransaction> build() async {
    await super.build();

    return PaymentTransaction.builder(this);
  }
}
