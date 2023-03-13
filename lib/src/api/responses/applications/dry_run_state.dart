import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dry_run_state.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class DryRunState {
  @JsonKey(name: 'error', defaultValue: '')
  final String error;

  @JsonKey(name: 'line', defaultValue: 0)
  final int line;

  @JsonKey(name: 'pc', defaultValue: 0)
  final int pc;

  @JsonKey(name: 'scratch', defaultValue: [])
  final List<TealValue> scratch;

  @JsonKey(name: 'stack', defaultValue: [])
  final List<TealValue> stack;

  DryRunState({
    required this.error,
    required this.line,
    required this.pc,
    required this.scratch,
    required this.stack,
  });

  factory DryRunState.fromJson(Map<String, dynamic> json) =>
      _$DryRunStateFromJson(json);

  Map<String, dynamic> toJson() => _$DryRunStateToJson(this);
}
