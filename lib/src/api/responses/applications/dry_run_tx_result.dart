import 'package:algorand_dart/src/api/application/application.dart';
import 'package:algorand_dart/src/api/responses.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dry_run_tx_result.g.dart';

/// DryrunTxnResult contains any LogicSig or ApplicationCall program debug
/// information and state updates from a dryrun.
@JsonSerializable(fieldRename: FieldRename.kebab)
class DryRunTxResult {
  @JsonKey(name: 'app-call-messages', defaultValue: [])
  final List<String> appCallMessages;

  @JsonKey(name: 'app-call-trace', defaultValue: [])
  final List<DryRunState> appCallTrace;

  /// Execution cost of app call transaction
  @JsonKey(name: 'cost')
  final int? cost;

  @JsonKey(name: 'disassembly', defaultValue: [])
  final List<String> disassembly;

  @JsonKey(name: 'global-delta', defaultValue: [])
  final List<EvalDeltaKeyValue> globalDelta;

  @JsonKey(name: 'local-deltas', defaultValue: [])
  final List<AccountStateDelta> localDeltas;

  @JsonKey(name: 'logic-sig-messages', defaultValue: [])
  final List<String> logicSigMessages;

  @JsonKey(name: 'logic-sig-trace', defaultValue: [])
  final List<DryRunState> logicSigTrace;

  @JsonKey(name: 'logs', defaultValue: [])
  final List<String> logs;

  DryRunTxResult({
    required this.appCallMessages,
    required this.appCallTrace,
    required this.disassembly,
    required this.globalDelta,
    required this.localDeltas,
    required this.logicSigMessages,
    required this.logicSigTrace,
    required this.logs,
    this.cost,
  });

  factory DryRunTxResult.fromJson(Map<String, dynamic> json) =>
      _$DryRunTxResultFromJson(json);

  Map<String, dynamic> toJson() => _$DryRunTxResultToJson(this);
}
