// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_transfer_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTransferTransaction _$AssetTransferTransactionFromJson(
        Map<String, dynamic> json) =>
    AssetTransferTransaction(
      assetId: json['xaid'] as int?,
      amount: json['aamt'] as int?,
      assetSender: const AddressSerializer().fromJson(json['asnd']),
      receiver: const AddressSerializer().fromJson(json['arcv']),
      closeTo: const AddressSerializer().fromJson(json['aclose']),
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

Map<String, dynamic> _$AssetTransferTransactionToJson(
        AssetTransferTransaction instance) =>
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
      'xaid': instance.assetId,
      'aamt': instance.amount,
      'asnd': const AddressSerializer().toJson(instance.assetSender),
      'arcv': const AddressSerializer().toJson(instance.receiver),
      'aclose': const AddressSerializer().toJson(instance.closeTo),
    };
