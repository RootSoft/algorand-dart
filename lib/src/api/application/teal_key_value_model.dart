import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teal_key_value_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class TealKeyValue {
  final String key;
  final TealValue value;

  TealKeyValue({
    required this.key,
    required this.value,
  });

  factory TealKeyValue.fromJson(Map<String, dynamic> json) =>
      _$TealKeyValueFromJson(json);

  Map<String, dynamic> toJson() => _$TealKeyValueToJson(this);
}
