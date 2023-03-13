// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_schema_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateSchema _$StateSchemaFromJson(Map<String, dynamic> json) => StateSchema(
      numUint: json['nui'] as int? ?? 0,
      numByteSlice: json['nbs'] as int? ?? 0,
    );

Map<String, dynamic> _$StateSchemaToJson(StateSchema instance) =>
    <String, dynamic>{
      'nui': instance.numUint,
      'nbs': instance.numByteSlice,
    };
