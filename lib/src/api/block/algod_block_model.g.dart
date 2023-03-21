// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algod_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlgodBlock _$AlgodBlockFromJson(Map<String, dynamic> json) => AlgodBlock(
      transactions: json['txns'] == null
          ? []
          : const ListAlgodTransactionConverter()
              .fromJson(json['txns'] as List),
      genesisHash: const ByteArrayToB64Converter().fromJson(json['gh']),
      genesisId: json['gen'] as String?,
      previousBlockHash: const ByteArrayToB64Converter().fromJson(json['prev']),
      round: const NullableBigIntSerializer().fromJson(json['rnd']),
      seed: const ByteArrayToB64Converter().fromJson(json['seed']),
      timestamp: json['ts'] as int?,
      txnCounter: json['tc'] as int?,
    );

Map<String, dynamic> _$AlgodBlockToJson(AlgodBlock instance) =>
    <String, dynamic>{
      'gh': const ByteArrayToB64Converter().toJson(instance.genesisHash),
      'gen': instance.genesisId,
      'prev':
          const ByteArrayToB64Converter().toJson(instance.previousBlockHash),
      'rnd': const NullableBigIntSerializer().toJson(instance.round),
      'seed': const ByteArrayToB64Converter().toJson(instance.seed),
      'ts': instance.timestamp,
      'txns':
          const ListAlgodTransactionConverter().toJson(instance.transactions),
      'tc': instance.txnCounter,
    };
