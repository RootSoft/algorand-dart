import 'package:algorand_dart/src/api/asset/asset.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assets_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetsResponse {
  @JsonKey(name: 'assets', defaultValue: [])
  final List<AssetHolding> assets;

  /// Round at which the results were computed.
  @JsonKey(name: 'current-round', defaultValue: 0)
  final int currentRound;

  /// Used for pagination, when making another request provide this token
  /// with the next parameter.
  @JsonKey(name: 'next-token')
  final String? nextToken;

  AssetsResponse({
    required this.assets,
    required this.currentRound,
    required this.nextToken,
  });

  factory AssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsResponseToJson(this);
}
