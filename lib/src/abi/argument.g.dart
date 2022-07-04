// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'argument.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Argument _$ArgumentFromJson(Map<String, dynamic> json) => Argument(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['desc'] as String? ?? '',
    );

Map<String, dynamic> _$ArgumentToJson(Argument instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'desc': instance.description,
    };
