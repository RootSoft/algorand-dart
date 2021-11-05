// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      index: json['index'] as int,
      params: AssetParameters.fromJson(json['params'] as Map<String, dynamic>),
      createdAtRound: json['created-at-round'] as int?,
      deleted: json['deleted'] as bool?,
      destroyedAtRound: json['destroyed-at-round'] as int?,
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'index': instance.index,
      'params': instance.params,
      'created-at-round': instance.createdAtRound,
      'deleted': instance.deleted,
      'destroyed-at-round': instance.destroyedAtRound,
    };
