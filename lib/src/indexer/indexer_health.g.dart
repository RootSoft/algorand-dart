// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indexer_health.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndexerHealth _$IndexerHealthFromJson(Map<String, dynamic> json) =>
    IndexerHealth(
      dbAvailable: json['db-available'] as bool,
      isMigrating: json['is-migrating'] as bool,
      message: json['message'] as String,
      round: const BigIntSerializer().fromJson(json['round']),
      data: json['data'],
    );

Map<String, dynamic> _$IndexerHealthToJson(IndexerHealth instance) =>
    <String, dynamic>{
      'data': instance.data,
      'db-available': instance.dbAvailable,
      'is-migrating': instance.isMigrating,
      'message': instance.message,
      'round': const BigIntSerializer().toJson(instance.round),
    };
