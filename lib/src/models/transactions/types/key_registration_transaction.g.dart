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
      stateProofPublicKey:
          const MerkleSignatureSerializer().fromJson(json['sprfkey']),
      voteFirst: json['votefst'] as int?,
      voteLast: json['votelst'] as int?,
      voteKeyDilution: json['votekd'] as int?,
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

Map<String, dynamic> _$KeyRegistrationTransactionToJson(
        KeyRegistrationTransaction instance) =>
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
      'votekey': const ParticipationKeySerializer().toJson(instance.votePK),
      'selkey': const VRFKeySerializer().toJson(instance.selectionPK),
      'sprfkey': const MerkleSignatureSerializer()
          .toJson(instance.stateProofPublicKey),
      'votefst': instance.voteFirst,
      'votelst': instance.voteLast,
      'votekd': instance.voteKeyDilution,
    };
