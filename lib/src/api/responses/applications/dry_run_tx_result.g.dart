// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dry_run_tx_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DryRunTxResult _$DryRunTxResultFromJson(Map<String, dynamic> json) =>
    DryRunTxResult(
      appCallMessages: (json['app-call-messages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      appCallTrace: (json['app-call-trace'] as List<dynamic>?)
              ?.map((e) => DryRunState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      disassembly: (json['disassembly'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      globalDelta: (json['global-delta'] as List<dynamic>?)
              ?.map(
                  (e) => EvalDeltaKeyValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      localDeltas: (json['local-deltas'] as List<dynamic>?)
              ?.map(
                  (e) => AccountStateDelta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      logicSigMessages: (json['logic-sig-messages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      logicSigTrace: (json['logic-sig-trace'] as List<dynamic>?)
              ?.map((e) => DryRunState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      logs:
          (json['logs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      cost: json['cost'] as int?,
    );

Map<String, dynamic> _$DryRunTxResultToJson(DryRunTxResult instance) =>
    <String, dynamic>{
      'app-call-messages': instance.appCallMessages,
      'app-call-trace': instance.appCallTrace,
      'cost': instance.cost,
      'disassembly': instance.disassembly,
      'global-delta': instance.globalDelta,
      'local-deltas': instance.localDeltas,
      'logic-sig-messages': instance.logicSigMessages,
      'logic-sig-trace': instance.logicSigTrace,
      'logs': instance.logs,
    };
