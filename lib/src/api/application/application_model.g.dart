// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      id: json['id'] as int,
      params:
          ApplicationParams.fromJson(json['params'] as Map<String, dynamic>),
      deleted: json['deleted'] as bool? ?? false,
      createdAtRound: json['created-at-round'] as int?,
      deletedAtRound: json['deleted-at-round'] as int?,
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'params': instance.params,
      'created-at-round': instance.createdAtRound,
      'deleted': instance.deleted,
      'deleted-at-round': instance.deletedAtRound,
    };
