// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_config_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetConfigParameters _$AssetConfigParametersFromJson(
        Map<String, dynamic> json) =>
    AssetConfigParameters(
      total: const NullableBigIntSerializer().fromJson(json['t']),
      decimals: json['dc'] as int? ?? 0,
      defaultFrozen: json['df'] as bool?,
      unitName: json['un'] as String?,
      assetName: json['an'] as String?,
      url: json['au'] as String?,
      metaData: const Base64Serializer().fromJson(json['am']),
      managerAddress: const AddressSerializer().fromJson(json['m']),
      reserveAddress: const AddressSerializer().fromJson(json['r']),
      freezeAddress: const AddressSerializer().fromJson(json['f']),
      clawbackAddress: const AddressSerializer().fromJson(json['c']),
    );

Map<String, dynamic> _$AssetConfigParametersToJson(
        AssetConfigParameters instance) =>
    <String, dynamic>{
      't': const NullableBigIntSerializer().toJson(instance.total),
      'dc': instance.decimals,
      'df': instance.defaultFrozen,
      'un': instance.unitName,
      'an': instance.assetName,
      'au': instance.url,
      'am': const Base64Serializer().toJson(instance.metaData),
      'm': const AddressSerializer().toJson(instance.managerAddress),
      'r': const AddressSerializer().toJson(instance.reserveAddress),
      'f': const AddressSerializer().toJson(instance.freezeAddress),
      'c': const AddressSerializer().toJson(instance.clawbackAddress),
    };
