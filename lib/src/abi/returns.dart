import 'package:algorand_dart/src/abi/abi_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'returns.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Returns {
  static const VoidRetType = 'void';

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'desc')
  final String? description;

  const Returns({
    this.type = 'void',
    this.description,
  });

  factory Returns.fromJson(Map<String, dynamic> json) =>
      _$ReturnsFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnsToJson(this);

  AbiType? get parsedType => type == 'void' ? null : AbiType.valueOf(type);
}
