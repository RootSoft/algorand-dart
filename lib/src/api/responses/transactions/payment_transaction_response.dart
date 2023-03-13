import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_transaction_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class PaymentTransactionResponse {
  /// Number of MicroAlgos intended to be transferred.
  @JsonKey(name: 'amount')
  @BigIntSerializer()
  final BigInt amount;

  /// Number of MicroAlgos that were sent to the close-remainder-to address
  /// when closing the sender account.
  @JsonKey(name: 'close-amount')
  @NullableBigIntSerializer()
  final BigInt? closeAmount;

  /// When set, indicates that the sending account should be closed and all
  /// remaining funds be transferred to this address.
  @JsonKey(name: 'close-remainder-to')
  final String? closeRemainderTo;

  /// Receiver's address.
  @JsonKey(name: 'receiver')
  final String receiver;

  PaymentTransactionResponse({
    required this.amount,
    required this.closeAmount,
    required this.receiver,
    this.closeRemainderTo,
  });

  factory PaymentTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTransactionResponseToJson(this);
}
