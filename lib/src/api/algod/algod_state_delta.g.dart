// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algod_state_delta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlgodStateDelta _$AlgodStateDeltaFromJson(Map<String, dynamic> json) =>
    AlgodStateDelta(
      action: json['at'] as int? ?? 0,
      bytes: const NullableByteArraySerializer().fromJson(json['bs']),
      uint: const NullableBigIntSerializer().fromJson(json['ui']),
    );

Map<String, dynamic> _$AlgodStateDeltaToJson(AlgodStateDelta instance) =>
    <String, dynamic>{
      'at': instance.action,
      'bs': const NullableByteArraySerializer().toJson(instance.bytes),
      'ui': const NullableBigIntSerializer().toJson(instance.uint),
    };
