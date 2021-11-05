// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LangSpec _$LangSpecFromJson(Map<String, dynamic> json) => LangSpec(
      evalMaxVersion: json['EvalMaxVersion'] as int? ?? 0,
      logicSigVersion: json['LogicSigVersion'] as int? ?? 0,
      operations: (json['Ops'] as List<dynamic>?)
              ?.map((e) => Operation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$LangSpecToJson(LangSpec instance) => <String, dynamic>{
      'EvalMaxVersion': instance.evalMaxVersion,
      'LogicSigVersion': instance.logicSigVersion,
      'Ops': instance.operations,
    };

Operation _$OperationFromJson(Map<String, dynamic> json) => Operation(
      opCode: json['Opcode'] as int,
      name: json['Name'] as String,
      cost: json['Cost'] as int,
      size: json['Size'] as int,
      returns: json['Returns'] as String?,
      argEnum: (json['ArgEnum'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      argEnumTypes: json['ArgEnumTypes'] as String?,
      doc: json['Doc'] as String?,
      immediateNote: json['ImmediateNote'] as String?,
      group:
          (json['Group'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
    );

Map<String, dynamic> _$OperationToJson(Operation instance) => <String, dynamic>{
      'Opcode': instance.opCode,
      'Name': instance.name,
      'Cost': instance.cost,
      'Size': instance.size,
      'Returns': instance.returns,
      'ArgEnum': instance.argEnum,
      'ArgEnumTypes': instance.argEnumTypes,
      'Doc': instance.doc,
      'ImmediateNote': instance.immediateNote,
      'Group': instance.group,
    };
