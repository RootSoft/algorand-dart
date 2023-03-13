import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Payment {
  /// The address of the account that receives the amount.
  final String receiver;

  /// The total amount to be sent in microAlgos.
  /// Amounts are returned in microAlgos - the base unit for Algos.
  /// Micro denotes a unit x 10^-6. 1 Algo equals 1,000,000 microAlgos.
  @JsonKey(name: 'amount')
  @BigIntSerializer()
  final BigInt amount;

  /// Number of MicroAlgos that were sent to the close-remainder-to address
  /// when closing the sender account.
  final int? closeAmount;

  /// When set, indicates that the sending account should be closed and all
  /// remaining funds be transferred to this address.
  final String? closeRemainderTo;

  Payment({
    required this.receiver,
    required this.amount,
    this.closeAmount,
    this.closeRemainderTo,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
