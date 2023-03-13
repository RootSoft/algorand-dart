import 'package:algorand_dart/src/api/asset/asset.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_lookup_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetResponse {
  /// Round at which the results were computed.
  final int currentRound;
  final Asset asset;

  AssetResponse({required this.currentRound, required this.asset});

  factory AssetResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetResponseToJson(this);
}
