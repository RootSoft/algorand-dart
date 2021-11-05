// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_config_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetConfigTransaction _$AssetConfigTransactionFromJson(
        Map<String, dynamic> json) =>
    AssetConfigTransaction(
      assetId: json['caid'] as int?,
      total: json['t'] as int?,
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
      fee: json['fee'] as int?,
      firstValid: json['fv'] as int?,
      genesisHash: const NullableByteArraySerializer().fromJson(json['gh']),
      lastValid: json['lv'] as int?,
      sender: const AddressSerializer().fromJson(json['snd']),
      type: json['type'] as String?,
      genesisId: json['gen'] as String?,
      group: const Base32Serializer().fromJson(json['grp']),
      lease: const NullableByteArraySerializer().fromJson(json['lx']),
      note: const NullableByteArraySerializer().fromJson(json['note']),
      rekeyTo: json['rekey'] as String?,
    );

Map<String, dynamic> _$AssetConfigTransactionToJson(
        AssetConfigTransaction instance) =>
    <String, dynamic>{
      'fee': instance.fee,
      'fv': instance.firstValid,
      'gh': const NullableByteArraySerializer().toJson(instance.genesisHash),
      'lv': instance.lastValid,
      'snd': const AddressSerializer().toJson(instance.sender),
      'type': instance.type,
      'gen': instance.genesisId,
      'grp': const Base32Serializer().toJson(instance.group),
      'lx': const NullableByteArraySerializer().toJson(instance.lease),
      'note': const NullableByteArraySerializer().toJson(instance.note),
      'rekey': instance.rekeyTo,
      'caid': instance.assetId,
      't': instance.total,
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
