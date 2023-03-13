// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teal_key_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TealKeyValue _$TealKeyValueFromJson(Map<String, dynamic> json) => TealKeyValue(
      key: json['key'] as String,
      value: TealValue.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TealKeyValueToJson(TealKeyValue instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };
