// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algod_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlgodBlock _$AlgodBlockFromJson(Map<String, dynamic> json) => AlgodBlock(
      transactions: json['txns'] == null
          ? []
          : const ListSignedTransactionConverter()
              .fromJson(json['txns'] as List),
      genesisHash: json['gh'] as String?,
      genesisId: json['gen'] as String?,
      previousBlockHash: json['prev'] as String?,
      round: json['rnd'] as int?,
      seed: json['seed'] as String?,
      timestamp: json['ts'] as int?,
      transactionsRoot: json['transactions-root'] as String?,
      txnCounter: json['tc'] as int?,
      upgradeState: json['upgrade-state'] == null
          ? null
          : BlockUpgradeState.fromJson(
              json['upgrade-state'] as Map<String, dynamic>),
      upgradeVote: json['upgrade-vote'] == null
          ? null
          : BlockUpgradeVote.fromJson(
              json['upgrade-vote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlgodBlockToJson(AlgodBlock instance) =>
    <String, dynamic>{
      'gh': instance.genesisHash,
      'gen': instance.genesisId,
      'prev': instance.previousBlockHash,
      'rnd': instance.round,
      'seed': instance.seed,
      'ts': instance.timestamp,
      'txns':
          const ListSignedTransactionConverter().toJson(instance.transactions),
      'transactions-root': instance.transactionsRoot,
      'tc': instance.txnCounter,
      'upgrade-state': instance.upgradeState,
      'upgrade-vote': instance.upgradeVote,
    };
