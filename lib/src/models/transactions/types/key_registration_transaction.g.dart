// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_registration_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyRegistrationTransaction _$KeyRegistrationTransactionFromJson(
        Map<String, dynamic> json) =>
    KeyRegistrationTransaction(
      votePK: const ParticipationKeySerializer().fromJson(json['votekey']),
      selectionPK: const VRFKeySerializer().fromJson(json['selkey']),
      voteFirst: json['votefst'] as int?,
      voteLast: json['votelst'] as int?,
      voteKeyDilution: json['votekd'] as int?,
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

Map<String, dynamic> _$KeyRegistrationTransactionToJson(
        KeyRegistrationTransaction instance) =>
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
      'votekey': const ParticipationKeySerializer().toJson(instance.votePK),
      'selkey': const VRFKeySerializer().toJson(instance.selectionPK),
      'votefst': instance.voteFirst,
      'votelst': instance.voteLast,
      'votekd': instance.voteKeyDilution,
    };
