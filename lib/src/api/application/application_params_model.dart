import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_params_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationParams {
  /// approval program.
  final String? approvalProgram;

  /// approval program.
  final String? clearStateProgram;

  /// The address that created this application.
  /// This is the address where the parameters and global state for this
  /// application can be found.
  final String? creator;

  /// global schema
  @JsonKey(name: 'global-state', defaultValue: [])
  final List<TealKeyValue> globalState;

  /// global schema
  final ApplicationStateSchema? globalStateSchema;

  /// local schema
  final ApplicationStateSchema? localStateSchema;

  ApplicationParams({
    this.approvalProgram,
    this.clearStateProgram,
    required this.globalState,
    this.creator,
    this.globalStateSchema,
    this.localStateSchema,
  });

  factory ApplicationParams.fromJson(Map<String, dynamic> json) =>
      _$ApplicationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationParamsToJson(this);
}
