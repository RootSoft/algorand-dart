// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eval_delta_key_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvalDeltaKeyValue _$EvalDeltaKeyValueFromJson(Map<String, dynamic> json) =>
    EvalDeltaKeyValue(
      key: json['key'] as String,
      value: EvalDelta.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EvalDeltaKeyValueToJson(EvalDeltaKeyValue instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };
