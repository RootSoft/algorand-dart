// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationParams _$ApplicationParamsFromJson(Map<String, dynamic> json) =>
    ApplicationParams(
      approvalProgram: json['approval-program'] as String?,
      clearStateProgram: json['clear-state-program'] as String?,
      globalState: (json['global-state'] as List<dynamic>?)
              ?.map((e) => TealKeyValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      creator: json['creator'] as String?,
      globalStateSchema: json['global-state-schema'] == null
          ? null
          : ApplicationStateSchema.fromJson(
              json['global-state-schema'] as Map<String, dynamic>),
      localStateSchema: json['local-state-schema'] == null
          ? null
          : ApplicationStateSchema.fromJson(
              json['local-state-schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationParamsToJson(ApplicationParams instance) =>
    <String, dynamic>{
      'approval-program': instance.approvalProgram,
      'clear-state-program': instance.clearStateProgram,
      'creator': instance.creator,
      'global-state': instance.globalState,
      'global-state-schema': instance.globalStateSchema,
      'local-state-schema': instance.localStateSchema,
    };
