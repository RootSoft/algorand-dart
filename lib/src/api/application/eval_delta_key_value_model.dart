import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eval_delta_key_value_model.g.dart';

/// Represents a TEAL value delta.
@JsonSerializable(fieldRename: FieldRename.kebab)
class EvalDeltaKeyValue {
  @JsonKey(name: 'key')
  final String key;

  @JsonKey(name: 'value')
  final EvalDelta value;

  EvalDeltaKeyValue({
    required this.key,
    required this.value,
  });

  factory EvalDeltaKeyValue.fromJson(Map<String, dynamic> json) =>
      _$EvalDeltaKeyValueFromJson(json);

  Map<String, dynamic> toJson() => _$EvalDeltaKeyValueToJson(this);
}
