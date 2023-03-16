import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod/signed_transaction_with_ad.dart';
import 'package:algorand_dart/src/api/converters/global_state_delta_converter.dart';
import 'package:algorand_dart/src/api/converters/local_state_delta_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'algod_eval_delta.g.dart';

@JsonSerializable()
class AlgodEvalDelta {
  @JsonKey(name: 'gd', defaultValue: [])
  @GlobalStateDeltaConverter()
  final List<EvalDeltaKeyValue> globalDelta;

  @JsonKey(name: 'ld', defaultValue: [])
  @LocalStateDeltaConverter()
  final List<AccountStateDelta> localStateDelta;

  @JsonKey(name: 'lg', defaultValue: [])
  final List<String> logs;

  /// List of transactions corresponding to a given round.
  @JsonKey(name: 'itx', defaultValue: [])
  @ListAlgodTransactionConverter()
  final List<SignedTransactionWithAD> transactions;

  AlgodEvalDelta({
    required this.globalDelta,
    required this.localStateDelta,
    required this.logs,
    required this.transactions,
  });

  factory AlgodEvalDelta.fromJson(Map<String, dynamic> json) =>
      _$AlgodEvalDeltaFromJson(json);

  Map<String, dynamic> toJson() => _$AlgodEvalDeltaToJson(this);
}
