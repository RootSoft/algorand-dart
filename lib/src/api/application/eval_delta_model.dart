import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
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
  @NullableBigIntSerializer()
  final BigInt? uint;

  EvalDelta({
    required this.action,
    required this.bytes,
    required this.uint,
  });

  factory EvalDelta.fromJson(Map<String, dynamic> json) =>
      _$EvalDeltaFromJson(json);

  Map<String, dynamic> toJson() => _$EvalDeltaToJson(this);

  factory EvalDelta.fromMessagePack(Map<String, dynamic> json) {
    return EvalDelta(
      action: json['at'] as int? ?? 0,
      bytes: json['bs'] as String?,
      uint: const NullableBigIntSerializer().fromJson(json['ui']),
    );
  }
}
