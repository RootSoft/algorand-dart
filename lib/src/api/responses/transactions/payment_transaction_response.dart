import 'package:json_annotation/json_annotation.dart';

part 'payment_transaction_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class PaymentTransactionResponse {
  @JsonKey(name: 'amount', defaultValue: 0)
  final int amount;

  @JsonKey(name: 'close-amount', defaultValue: 0)
  final int closeAmount;

  /// Total number of transactions in the pool.
  @JsonKey(name: 'receiver')
  final String receiver;

  PaymentTransactionResponse({
    required this.amount,
    required this.closeAmount,
    required this.receiver,
  });

  factory PaymentTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTransactionResponseToJson(this);
}
