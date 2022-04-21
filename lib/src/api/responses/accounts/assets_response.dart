import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assets_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetsResponse {
  @JsonKey(name: 'assets', defaultValue: [])
  final List<AssetHolding> assets;

  AssetsResponse({required this.assets});

  factory AssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$AssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsResponseToJson(this);
}
