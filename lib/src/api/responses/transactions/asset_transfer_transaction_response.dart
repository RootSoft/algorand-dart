import 'package:json_annotation/json_annotation.dart';

part 'asset_transfer_transaction_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetTransferTransactionResponse {
  @JsonKey(name: 'amount', defaultValue: 0)
  final int amount;

  @JsonKey(name: 'asset-id')
  final int assetId;

  @JsonKey(name: 'close-amount', defaultValue: 0)
  final int closeAmount;

  /// Total number of transactions in the pool.
  @JsonKey(name: 'receiver')
  final String receiver;

  AssetTransferTransactionResponse({
    required this.amount,
    required this.assetId,
    required this.closeAmount,
    required this.receiver,
  });

  factory AssetTransferTransactionResponse.fromJson(
          Map<String, dynamic> json) =>
      _$AssetTransferTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AssetTransferTransactionResponseToJson(this);
}
