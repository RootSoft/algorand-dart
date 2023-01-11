// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algod_eval_delta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlgodEvalDelta _$AlgodEvalDeltaFromJson(Map<String, dynamic> json) =>
    AlgodEvalDelta(
      globalDelta: json['gd'] == null
          ? []
          : const GlobalStateDeltaConverter().fromJson(json['gd']),
      localStateDelta: json['ld'] == null
          ? []
          : const LocalStateDeltaConverter().fromJson(json['ld']),
      logs: (json['lg'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      transactions: json['itx'] == null
          ? []
          : const ListAlgodTransactionConverter().fromJson(json['itx'] as List),
    );

Map<String, dynamic> _$AlgodEvalDeltaToJson(AlgodEvalDelta instance) =>
    <String, dynamic>{
      'gd': const GlobalStateDeltaConverter().toJson(instance.globalDelta),
      'ld': const LocalStateDeltaConverter().toJson(instance.localStateDelta),
      'lg': instance.logs,
      'itx':
          const ListAlgodTransactionConverter().toJson(instance.transactions),
    };
