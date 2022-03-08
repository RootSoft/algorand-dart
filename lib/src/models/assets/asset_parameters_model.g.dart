// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_parameters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetParameters _$AssetParametersFromJson(Map<String, dynamic> json) =>
    AssetParameters(
      decimals: json['decimals'] as int,
      creator: json['creator'] as String,
      total: json['total'] as int,
      clawback: json['clawback'] as String?,
      defaultFrozen: json['default-frozen'] as bool?,
      freeze: json['freeze'] as String?,
      manager: json['manager'] as String?,
      name: json['name'] as String?,
      reserve: json['reserve'] as String?,
      unitName: json['unit-name'] as String?,
      url: json['url'] as String?,
      metadataHash: json['metadata-hash'] as String?,
    );

Map<String, dynamic> _$AssetParametersToJson(AssetParameters instance) =>
    <String, dynamic>{
      'total': instance.total,
      'decimals': instance.decimals,
      'creator': instance.creator,
      'clawback': instance.clawback,
      'default-frozen': instance.defaultFrozen,
      'freeze': instance.freeze,
      'manager': instance.manager,
      'name': instance.name,
      'reserve': instance.reserve,
      'unit-name': instance.unitName,
      'url': instance.url,
      'metadata-hash': instance.metadataHash,
    };
