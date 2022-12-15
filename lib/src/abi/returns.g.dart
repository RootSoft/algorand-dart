// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'returns.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Returns _$ReturnsFromJson(Map<String, dynamic> json) => Returns(
      type: json['type'] as String? ?? 'void',
      description: json['desc'] as String?,
    );

Map<String, dynamic> _$ReturnsToJson(Returns instance) => <String, dynamic>{
      'type': instance.type,
      'desc': instance.description,
    };
