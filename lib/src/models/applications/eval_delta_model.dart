import 'package:json_annotation/json_annotation.dart';

part 'eval_delta_model.g.dart';

/// Represents a TEAL value delta.
@JsonSerializable(fieldRename: FieldRename.kebab)
class EvalDelta {
  @JsonKey(name: 'action', defaultValue: 0)
  final int action;

  /// bytes value.
  @JsonKey(name: 'bytes')
  final String? bytes;

  /// uint value.
  @JsonKey(name: 'uint')
  final int? uint;

  EvalDelta({
    required this.action,
    required this.bytes,
    required this.uint,
  });

  factory EvalDelta.fromJson(Map<String, dynamic> json) =>
      _$EvalDeltaFromJson(json);

  Map<String, dynamic> toJson() => _$EvalDeltaToJson(this);
}
