import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_holding_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetHolding {
  /// Number of units held.
  @JsonKey(name: 'amount')
  @BigIntSerializer()
  final BigInt amount;

  /// Asset ID of the holding.
  final int assetId;

  /// Address that created this asset.
  ///
  /// This is the address where the parameters for this asset can
  /// be found, and also the address where unwanted asset units can be sent
  /// in the worst case.
  final String? creator;

  /// Whether or not the asset holding is currently deleted from its account.
  final bool? deleted;

  /// Wether or not the holding is frozen.
  final bool isFrozen;

  /// Round during which the account opted into this asset holding.
  final int? optedInAtRound;

  /// Round during which the account opted out of this asset holding.
  final int? optedOutAtRound;

  AssetHolding({
    required this.amount,
    required this.assetId,
    required this.creator,
    required this.isFrozen,
    this.deleted,
    this.optedInAtRound,
    this.optedOutAtRound,
  });

  factory AssetHolding.fromJson(Map<String, dynamic> json) =>
      _$AssetHoldingFromJson(json);

  Map<String, dynamic> toJson() => _$AssetHoldingToJson(this);

  @override
  String toString() {
    return 'AssetHolding{'
        'amount: $amount, '
        'assetId: $assetId, '
        'creator: $creator, '
        'deleted: $deleted, '
        'isFrozen: $isFrozen, '
        'optedInAtRound: $optedInAtRound, '
        'optedOutAtRound: $optedOutAtRound'
        '}';
  }
}
