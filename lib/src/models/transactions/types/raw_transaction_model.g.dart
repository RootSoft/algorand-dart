// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RawTransaction _$RawTransactionFromJson(Map<String, dynamic> json) {
  return RawTransaction(
    fee: json['fee'] as int?,
    firstValid: json['fv'] as int?,
    genesisHash: json['gh'] as String?,
    lastValid: json['lv'] as int?,
    sender: const AddressSerializer().fromJson(json['snd'] as String?),
    type: json['type'] as String,
    genesisId: json['gen'] as String?,
    group: const Base32Serializer().fromJson(json['grp'] as String?),
    lease: json['lx'] as String?,
    note: const ByteArraySerializer().fromJson(json['note'] as String?),
    rekeyTo: json['rekey'] as String?,
  );
}

Map<String, dynamic> _$RawTransactionToJson(RawTransaction instance) =>
    <String, dynamic>{
      'fee': instance.fee,
      'fv': instance.firstValid,
      'gh': instance.genesisHash,
      'lv': instance.lastValid,
      'snd': const AddressSerializer().toJson(instance.sender),
      'type': instance.type,
      'gen': instance.genesisId,
      'grp': const Base32Serializer().toJson(instance.group),
      'lx': instance.lease,
      'note': const ByteArraySerializer().toJson(instance.note),
      'rekey': instance.rekeyTo,
    };
