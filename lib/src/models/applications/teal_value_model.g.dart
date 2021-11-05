// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teal_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TealValue _$TealValueFromJson(Map<String, dynamic> json) => TealValue(
      bytes: json['bytes'] as String,
      type: json['type'] as int,
      uint: json['uint'] as int,
    );

Map<String, dynamic> _$TealValueToJson(TealValue instance) => <String, dynamic>{
      'bytes': instance.bytes,
      'type': instance.type,
      'uint': instance.uint,
    };
