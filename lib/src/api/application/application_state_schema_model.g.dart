// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_state_schema_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationStateSchema _$ApplicationStateSchemaFromJson(
        Map<String, dynamic> json) =>
    ApplicationStateSchema(
      numByteSlice: json['num-byte-slice'] as int,
      numUint: json['num-uint'] as int,
    );

Map<String, dynamic> _$ApplicationStateSchemaToJson(
        ApplicationStateSchema instance) =>
    <String, dynamic>{
      'num-byte-slice': instance.numByteSlice,
      'num-uint': instance.numUint,
    };
