import 'package:algorand_dart/src/api/asset/asset.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_assets_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class SearchAssetsResponse {
  final int currentRound;
  final String? nextToken;
  final List<Asset> assets;

  SearchAssetsResponse({
    required this.currentRound,
    this.nextToken,
    required this.assets,
  });

  factory SearchAssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchAssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAssetsResponseToJson(this);
}
