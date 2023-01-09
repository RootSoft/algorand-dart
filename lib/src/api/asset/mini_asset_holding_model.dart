import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mini_asset_holding_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class MiniAssetHolding {
  /// The address that holds this asset.
  final String address;

  /// Number of units held.
  @JsonKey(name: 'amount')
  @BigIntSerializer()
  final BigInt amount;

  /// Whether or not the asset holding is currently deleted from its account.
  final bool? deleted;

  /// Wether or not the holding is frozen.
  final bool isFrozen;

  /// Round during which the account opted into this asset holding.
  final int? optedInAtRound;

  /// Round during which the account opted out of this asset holding.
  final int? optedOutAtRound;

  MiniAssetHolding({
    required this.address,
    required this.amount,
    required this.isFrozen,
    this.deleted,
    this.optedInAtRound,
    this.optedOutAtRound,
  });

  factory MiniAssetHolding.fromJson(Map<String, dynamic> json) =>
      _$MiniAssetHoldingFromJson(json);

  Map<String, dynamic> toJson() => _$MiniAssetHoldingToJson(this);
}
