import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'created_assets_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class CreatedAssetsResponse {
  @JsonKey(name: 'assets', defaultValue: [])
  final List<Asset> assets;

  CreatedAssetsResponse({required this.assets});

  factory CreatedAssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatedAssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedAssetsResponseToJson(this);
}
