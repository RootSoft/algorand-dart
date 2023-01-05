// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_local_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationLocalState _$ApplicationLocalStateFromJson(
        Map<String, dynamic> json) =>
    ApplicationLocalState(
      id: json['id'] as int,
      schema: ApplicationStateSchema.fromJson(
          json['schema'] as Map<String, dynamic>),
      keyValue: (json['key-value'] as List<dynamic>?)
              ?.map((e) => TealKeyValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      closedOutAtRound: json['closed-out-at-round'] as int?,
      deleted: json['deleted'] as bool?,
      optedInAtRound: json['opted-in-at-round'] as int?,
    );

Map<String, dynamic> _$ApplicationLocalStateToJson(
        ApplicationLocalState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schema': instance.schema,
      'closed-out-at-round': instance.closedOutAtRound,
      'deleted': instance.deleted,
      'key-value': instance.keyValue,
      'opted-in-at-round': instance.optedInAtRound,
    };
