// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_transfer_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTransferTransaction _$AssetTransferTransactionFromJson(
        Map<String, dynamic> json) =>
    AssetTransferTransaction(
      assetId: json['xaid'] as int?,
      amount: const NullableBigIntSerializer().fromJson(json['aamt']),
      assetSender: const AddressSerializer().fromJson(json['asnd']),
      receiver: const AddressSerializer().fromJson(json['arcv']),
      closeTo: const AddressSerializer().fromJson(json['aclose']),
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

Map<String, dynamic> _$AssetTransferTransactionToJson(
        AssetTransferTransaction instance) =>
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
      'xaid': instance.assetId,
      'aamt': const NullableBigIntSerializer().toJson(instance.amount),
      'asnd': const AddressSerializer().toJson(instance.assetSender),
      'arcv': const AddressSerializer().toJson(instance.receiver),
      'aclose': const AddressSerializer().toJson(instance.closeTo),
    };
