import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_transfer_transaction_response.g.dart';

/// Fields for an asset transfer transaction.
@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetTransferTransactionResponse {
  /// Amount of asset to transfer. A zero amount transferred to self allocates
  /// that asset in the account's Assets map.
  @JsonKey(name: 'amount')
  @BigIntSerializer()
  final BigInt amount;

  /// ID of the asset being transferred.
  @JsonKey(name: 'asset-id', defaultValue: 0)
  final int assetId;

  /// Number of assets transfered to the close-to account as part of the
  /// transaction.
  @JsonKey(name: 'close-amount')
  @NullableBigIntSerializer()
  final BigInt? closeAmount;

  /// Indicates that the asset should be removed from the account's Assets map,
  /// and specifies where the remaining asset holdings should be transferred.
  /// It's always valid to transfer remaining asset holdings to the creator
  /// account.
  @JsonKey(name: 'close-to')
  final String? closeTo;

  /// Recipient address of the transfer.
  @JsonKey(name: 'receiver')
  final String receiver;

  /// The effective sender during a clawback transactions.
  /// If this is not a zero value, the real transaction sender must be the
  /// Clawback address from the AssetParams.
  @JsonKey(name: 'sender')
  final String? sender;

  AssetTransferTransactionResponse({
    required this.amount,
    required this.assetId,
    required this.receiver,
    this.closeAmount,
    this.closeTo,
    this.sender,
  });

  factory AssetTransferTransactionResponse.fromJson(
          Map<String, dynamic> json) =>
      _$AssetTransferTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AssetTransferTransactionResponseToJson(this);
}
