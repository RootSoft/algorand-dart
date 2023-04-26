import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/payment_transaction_builder.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class PaymentTransaction extends RawTransaction {
  /// The address of the account that receives the amount.
  @JsonKey(name: 'rcv')
  @AddressSerializer()
  final Address? receiver;

  /// The total amount to be sent in microAlgos.
  /// Amounts are returned in microAlgos - the base unit for Algos.
  /// Micro denotes a unit x 10^-6. 1 Algo equals 1,000,000 microAlgos.
  @JsonKey(name: 'amt')
  @NullableBigIntSerializer()
  final BigInt? amount;

  /// Number of MicroAlgos that were sent to the close-remainder-to address
  /// when closing the sender account.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @NullableBigIntSerializer()
  final BigInt? closeAmount;

  /// When set, indicates that the sending account should be closed and all
  /// remaining funds be transferred to this address.
  @JsonKey(name: 'close')
  @AddressSerializer()
  final Address? closeRemainderTo;

  PaymentTransaction({
    this.receiver,
    this.amount,
    this.closeAmount,
    this.closeRemainderTo,
    BigInt? fee,
    BigInt? firstValid,
    Uint8List? genesisHash,
    BigInt? lastValid,
    Address? sender,
    String? type,
    String? genesisId,
    Uint8List? group,
    Uint8List? lease,
    Uint8List? note,
    Address? rekeyTo,
  }) : super(
          type: type,
          fee: fee,
          firstValid: firstValid,
          genesisHash: genesisHash,
          lastValid: lastValid,
          sender: sender,
          genesisId: genesisId,
          group: group,
          lease: lease,
          note: note,
          rekeyTo: rekeyTo,
        );

  PaymentTransaction.builder(PaymentTransactionBuilder builder)
      : receiver = builder.receiver,
        amount = builder.amount,
        closeAmount = null,
        closeRemainderTo = builder.closeRemainderTo,
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
      'close': const AddressTransformer().toMessagePack(closeRemainderTo),
    };

    // Merge them
    transactionFields.addAll(paymentFields);
    return transactionFields;
  }

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PaymentTransactionToJson(this);

  @override
  List<Object?> get props => [
        ...super.props,
        receiver,
        amount,
        closeAmount,
        closeRemainderTo,
      ];
}
