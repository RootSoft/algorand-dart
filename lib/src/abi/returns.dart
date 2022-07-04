import 'package:json_annotation/json_annotation.dart';

part 'returns.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Returns {
  static const VoidRetType = 'void';

  @JsonKey(name: 'type', defaultValue: '')
  final String type;

  @JsonKey(name: 'desc')
  final String? description;

  const Returns({
    this.type = Returns.VoidRetType,
    this.description,
  });

  factory Returns.fromJson(Map<String, dynamic> json) =>
      _$ReturnsFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnsToJson(this);
}
