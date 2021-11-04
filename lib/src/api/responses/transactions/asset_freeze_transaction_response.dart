import 'package:json_annotation/json_annotation.dart';

part 'asset_freeze_transaction_response.g.dart';

/// Fields for an asset freeze transaction.
@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetFreezeTransactionResponse {
  /// Address of the account whose asset is being frozen or thawed
  @JsonKey(name: 'address', defaultValue: '')
  final String address;

  /// ID of the asset being frozen or thawed.
  @JsonKey(name: 'asset-id', defaultValue: 0)
  final int assetId;

  ///  The new freeze status.
  @JsonKey(name: 'new-freeze-status', defaultValue: false)
  final bool newFreezeStatus;

  AssetFreezeTransactionResponse({
    required this.address,
    required this.assetId,
    required this.newFreezeStatus,
  });

  factory AssetFreezeTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetFreezeTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetFreezeTransactionResponseToJson(this);
}
