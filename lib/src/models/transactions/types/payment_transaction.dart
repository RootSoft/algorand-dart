import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/payment_transaction_builder.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';

class PaymentTransaction extends RawTransaction {
  /// The address of the account that receives the amount.
  final Address? receiver;

  /// The total amount to be sent in microAlgos.
  /// Amounts are returned in microAlgos - the base unit for Algos.
  /// Micro denotes a unit x 10^-6. Therefore, 1 Algo equals 1,000,000 microAlgos.
  /// TODO BigInt
  final int? amount;

  /// Number of MicroAlgos that were sent to the close-remainder-to address
  /// when closing the sender account.
  final int? closeAmount;

  /// When set, indicates that the sending account should be closed and all
  /// remaining funds be transferred to this address.
  final String? closeRemainderTo;

  PaymentTransaction.builder(PaymentTransactionBuilder builder)
      : receiver = builder.receiver,
        amount = builder.amount,
        closeAmount = null,
        closeRemainderTo = null,
        super(
          type: builder.type.value,
          fee: builder.fee,
          firstValid: builder.firstValid,
          genesisHash: builder.genesisHash,
          lastValid: builder.lastValid,
          sender: builder.sender,
          genesisId: builder.genesisId,
          group: builder.group,
          lease: builder.lease,
          note: builder.note,
          rekeyTo: builder.rekeyTo,
        );

  @override
  Map<String, dynamic> toMessagePack() {
    final transactionFields = super.toMessagePack();
    final paymentFields = {
      'rcv': const AddressTransformer().toMessagePack(receiver),
      'amt': amount,
    };

    // Merge them
    transactionFields.addAll(paymentFields);
    return transactionFields;
  }
}
