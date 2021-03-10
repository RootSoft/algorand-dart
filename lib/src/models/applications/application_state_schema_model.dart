import 'package:json_annotation/json_annotation.dart';

part 'application_state_schema_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationStateSchema {
  /// ] num of byte slices.
  @JsonKey(name: 'num-byte-slice')
  final int numByteSlice;

  /// num of uints.
  @JsonKey(name: 'num-uint')
  final int numUint;

  ApplicationStateSchema({
    required this.numByteSlice,
    required this.numUint,
  });

  factory ApplicationStateSchema.fromJson(Map<String, dynamic> json) =>
      _$ApplicationStateSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationStateSchemaToJson(this);
}
