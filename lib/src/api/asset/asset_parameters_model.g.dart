// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_parameters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetParameters _$AssetParametersFromJson(Map<String, dynamic> json) =>
    AssetParameters(
      decimals: json['decimals'] as int,
      creator: json['creator'] as String,
      total: const BigIntSerializer().fromJson(json['total']),
      clawback: json['clawback'] as String?,
      defaultFrozen: json['default-frozen'] as bool?,
      freeze: json['freeze'] as String?,
      manager: json['manager'] as String?,
      name: json['name'] as String?,
      nameB64: json['name-b64'] as String?,
      reserve: json['reserve'] as String?,
      unitName: json['unit-name'] as String?,
      unitNameB64: json['unit-name-b64'] as String?,
      url: json['url'] as String?,
      urlB64: json['url-b64'] as String?,
      metadataHash: json['metadata-hash'] as String?,
    );

Map<String, dynamic> _$AssetParametersToJson(AssetParameters instance) =>
    <String, dynamic>{
      'total': const BigIntSerializer().toJson(instance.total),
      'decimals': instance.decimals,
      'creator': instance.creator,
      'clawback': instance.clawback,
      'default-frozen': instance.defaultFrozen,
      'freeze': instance.freeze,
      'manager': instance.manager,
      'name': instance.name,
      'name-b64': instance.nameB64,
      'reserve': instance.reserve,
      'unit-name': instance.unitName,
      'unit-name-b64': instance.unitNameB64,
      'url': instance.url,
      'url-b64': instance.urlB64,
      'metadata-hash': instance.metadataHash,
    };
