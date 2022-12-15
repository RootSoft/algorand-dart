// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eval_delta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvalDelta _$EvalDeltaFromJson(Map<String, dynamic> json) => EvalDelta(
      action: json['action'] as int? ?? 0,
      bytes: json['bytes'] as String?,
      uint: const NullableBigIntSerializer().fromJson(json['uint']),
    );

Map<String, dynamic> _$EvalDeltaToJson(EvalDelta instance) => <String, dynamic>{
      'action': instance.action,
      'bytes': instance.bytes,
      'uint': const NullableBigIntSerializer().toJson(instance.uint),
    };
