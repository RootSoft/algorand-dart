import 'package:algorand_dart/src/api/asset/asset.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_config_transaction_response.g.dart';

/// Fields for asset allocation, re-configuration, and destruction.
/// A zero value for asset-id indicates asset creation.
/// A zero value for the params indicates asset destruction.
@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetConfigTransactionResponse {
  /// ID of the asset being configured or empty if creating.
  @JsonKey(name: 'asset-id')
  final int? assetId;

  @JsonKey(name: 'params')
  final AssetParameters? parameters;

  AssetConfigTransactionResponse({
    this.assetId,
    this.parameters,
  });

  factory AssetConfigTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetConfigTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetConfigTransactionResponseToJson(this);
}
