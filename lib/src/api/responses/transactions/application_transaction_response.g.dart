// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationTransactionResponse _$ApplicationTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    ApplicationTransactionResponse(
      applicationId: json['application-id'] as int,
      onCompletion: $enumDecode(_$OnCompletionEnumMap, json['on-completion'],
          unknownValue: OnCompletion.NO_OP_OC),
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      applicationArguments: (json['application-args'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      foreignApps: (json['foreign-apps'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      foreignAssets: (json['foreign-assets'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      extraProgramPages: json['extra-program-pages'] as int? ?? 0,
      approvalProgram: json['approval-program'] as String?,
      clearStateProgram: json['clear-state-program'] as String?,
      globalStateSchema: json['global-state-schema'] == null
          ? null
          : StateSchema.fromJson(
              json['global-state-schema'] as Map<String, dynamic>),
      localStateSchema: json['local-state-schema'] == null
          ? null
          : StateSchema.fromJson(
              json['local-state-schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationTransactionResponseToJson(
        ApplicationTransactionResponse instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'application-args': instance.applicationArguments,
      'application-id': instance.applicationId,
      'approval-program': instance.approvalProgram,
      'clear-state-program': instance.clearStateProgram,
      'extra-program-pages': instance.extraProgramPages,
      'foreign-apps': instance.foreignApps,
      'foreign-assets': instance.foreignAssets,
      'global-state-schema': instance.globalStateSchema,
      'local-state-schema': instance.localStateSchema,
      'on-completion': _$OnCompletionEnumMap[instance.onCompletion]!,
    };

const _$OnCompletionEnumMap = {
  OnCompletion.NO_OP_OC: 'noop',
  OnCompletion.OPT_IN_OC: 'optin',
  OnCompletion.CLOSE_OUT_OC: 'closeout',
  OnCompletion.CLEAR_STATE_OC: 'clear',
  OnCompletion.UPDATE_APPLICATION_OC: 'update',
  OnCompletion.DELETE_APPLICATION_OC: 'delete',
};
