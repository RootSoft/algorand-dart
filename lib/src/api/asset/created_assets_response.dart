import 'package:algorand_dart/src/api/asset/asset.dart';
import 'package:json_annotation/json_annotation.dart';

part 'created_assets_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class CreatedAssetsResponse {
  @JsonKey(name: 'assets', defaultValue: [])
  final List<Asset> assets;

  /// Round at which the results were computed.
  @JsonKey(name: 'current-round', defaultValue: 0)
  final int currentRound;

  /// Used for pagination, when making another request provide this token
  /// with the next parameter.
  @JsonKey(name: 'next-token')
  final String? nextToken;

  CreatedAssetsResponse({
    required this.assets,
    required this.currentRound,
    required this.nextToken,
  });

  factory CreatedAssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatedAssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedAssetsResponseToJson(this);
}
