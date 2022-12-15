import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teal_value_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class TealValue {
  /// bytes value.
  final String bytes;

  /// value type.
  final int type;

  /// uint value.
  @BigIntSerializer()
  final BigInt uint;

  TealValue({
    required this.bytes,
    required this.type,
    required this.uint,
  });

  factory TealValue.fromJson(Map<String, dynamic> json) =>
      _$TealValueFromJson(json);

  Map<String, dynamic> toJson() => _$TealValueToJson(this);
}
