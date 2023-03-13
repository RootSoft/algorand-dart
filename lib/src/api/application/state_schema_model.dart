import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state_schema_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class StateSchema implements MessagePackable {
  /// num of uints.
  /// TODO Bigint
  @JsonKey(name: 'nui', defaultValue: 0)
  final int numUint;

  /// num of byte slices.
  /// TODO Bigint
  @JsonKey(name: 'nbs', defaultValue: 0)
  final int numByteSlice;

  StateSchema({
    required this.numUint,
    required this.numByteSlice,
  });

  factory StateSchema.fromJson(Map<String, dynamic> json) =>
      _$StateSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$StateSchemaToJson(this);

  @override
  Map<String, dynamic> toMessagePack() {
    return toJson();
  }
}
