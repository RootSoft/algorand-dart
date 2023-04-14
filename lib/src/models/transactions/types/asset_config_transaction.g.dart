// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_config_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetConfigTransaction _$AssetConfigTransactionFromJson(
        Map<String, dynamic> json) =>
    AssetConfigTransaction(
      assetId: json['caid'] as int?,
      params: json['apar'] == null
          ? null
          : AssetConfigParameters.fromJson(
              json['apar'] as Map<String, dynamic>),
      fee: const NullableBigIntSerializer().fromJson(json['fee']),
      firstValid: const NullableBigIntSerializer().fromJson(json['fv']),
      genesisHash: const NullableByteArraySerializer().fromJson(json['gh']),
      lastValid: const NullableBigIntSerializer().fromJson(json['lv']),
      sender: const AddressSerializer().fromJson(json['snd']),
      type: json['type'] as String?,
      genesisId: json['gen'] as String?,
      group: const Base32Serializer().fromJson(json['grp']),
      lease: const NullableByteArraySerializer().fromJson(json['lx']),
      note: const NullableByteArraySerializer().fromJson(json['note']),
      rekeyTo: const AddressSerializer().fromJson(json['rekey']),
    );

Map<String, dynamic> _$AssetConfigTransactionToJson(
        AssetConfigTransaction instance) =>
    <String, dynamic>{
      'fee': const NullableBigIntSerializer().toJson(instance.fee),
      'fv': const NullableBigIntSerializer().toJson(instance.firstValid),
      'gh': const NullableByteArraySerializer().toJson(instance.genesisHash),
      'lv': const NullableBigIntSerializer().toJson(instance.lastValid),
      'snd': const AddressSerializer().toJson(instance.sender),
      'type': instance.type,
      'gen': instance.genesisId,
      'grp': const Base32Serializer().toJson(instance.group),
      'lx': const NullableByteArraySerializer().toJson(instance.lease),
      'note': const NullableByteArraySerializer().toJson(instance.note),
      'rekey': const AddressSerializer().toJson(instance.rekeyTo),
      'caid': instance.assetId,
      'apar': instance.params?.toJson(),
    };
