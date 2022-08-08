import 'package:algorand_dart/src/abi/abi_method.dart';
import 'package:algorand_dart/src/abi/abi_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'argument.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Argument {
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'type', defaultValue: '')
  final String type;

  @JsonKey(name: 'desc', defaultValue: '')
  final String description;

  Argument({
    required this.name,
    required this.type,
    required this.description,
  });

  factory Argument.fromJson(Map<String, dynamic> json) =>
      _$ArgumentFromJson(json);

  Map<String, dynamic> toJson() => _$ArgumentToJson(this);

  AbiType? get parsedType =>
      AbiMethod.isTxnArgOrForeignArrayArgs(type) ? null : AbiType.valueOf(type);
}
