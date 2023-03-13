import 'package:algorand_dart/src/api/asset/asset.dart';

import 'package:json_annotation/json_annotation.dart';

part 'asset_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Asset {
  /// The unique asset identifier.
  final int index;

  /// The asset parameters
  final AssetParameters params;

  /// Round during which this asset was created.
  final int? createdAtRound;

  /// Whether or not this asset is currently deleted.
  final bool? deleted;

  /// Round during which this asset was destroyed.
  final int? destroyedAtRound;

  Asset({
    required this.index,
    required this.params,
    this.createdAtRound,
    this.deleted,
    this.destroyedAtRound,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  Map<String, dynamic> toJson() => _$AssetToJson(this);

  @override
  String toString() {
    return 'Asset{'
        'index: $index, '
        'params: $params, '
        'createdAtRound: $createdAtRound, '
        'deleted: $deleted, '
        'destroyedAtRound: $destroyedAtRound'
        '}';
  }
}
