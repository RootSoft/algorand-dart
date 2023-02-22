// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationTransaction _$ApplicationTransactionFromJson(
        Map<String, dynamic> json) =>
    ApplicationTransaction(
      globalStateSchema: json['apgs'] == null
          ? null
          : StateSchema.fromJson(json['apgs'] as Map<String, dynamic>),
      localStateSchema: json['apls'] == null
          ? null
          : StateSchema.fromJson(json['apls'] as Map<String, dynamic>),
      extraPages: json['apep'] as int?,
      approvalProgram: const TealProgramConverter().fromJson(json['apap']),
      clearStateProgram: const TealProgramConverter().fromJson(json['apsu']),
      applicationId: json['apid'] as int? ?? 0,
      onCompletion: const OnCompletionConverter().fromJson(json['apan']),
      arguments: const ListByteArraySerializer().fromJson(json['apaa']),
      accounts: const ListByteArraySerializer().fromJson(json['apat']),
      foreignApps:
          (json['apfa'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      foreignAssets:
          (json['apas'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      boxes: (json['apbx'] as List<dynamic>?)
              ?.map((e) => AppBoxReference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      rekeyTo: const AddressSerializer().fromJson(json['rekey']),
    );

Map<String, dynamic> _$ApplicationTransactionToJson(
        ApplicationTransaction instance) =>
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
      'rekey': const AddressSerializer().toJson(instance.rekeyTo),
      'apgs': instance.globalStateSchema,
      'apls': instance.localStateSchema,
      'apep': instance.extraPages,
      'apap': const TealProgramConverter().toJson(instance.approvalProgram),
      'apsu': const TealProgramConverter().toJson(instance.clearStateProgram),
      'apid': instance.applicationId,
      'apan': const OnCompletionConverter().toJson(instance.onCompletion),
      'apaa': const ListByteArraySerializer().toJson(instance.arguments),
      'apat': const ListByteArraySerializer().toJson(instance.accounts),
      'apfa': instance.foreignApps,
      'apas': instance.foreignAssets,
      'apbx': instance.boxes,
    };
