// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      genesisHash: json['genesis-hash'] as String?,
      genesisId: json['genesis-id'] as String?,
      previousBlockHash: json['previous-block-hash'] as String?,
      round: const NullableBigIntSerializer().fromJson(json['round']),
      seed: json['seed'] as String?,
      timestamp: json['timestamp'] as int?,
      transactionsRoot: json['transactions-root'] as String?,
      rewards: json['rewards'] == null
          ? null
          : BlockRewards.fromJson(json['rewards'] as Map<String, dynamic>),
      txnCounter: json['txn-counter'] as int?,
      upgradeState: json['upgrade-state'] == null
          ? null
          : BlockUpgradeState.fromJson(
              json['upgrade-state'] as Map<String, dynamic>),
      upgradeVote: json['upgrade-vote'] == null
          ? null
          : BlockUpgradeVote.fromJson(
              json['upgrade-vote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'genesis-hash': instance.genesisHash,
      'genesis-id': instance.genesisId,
      'previous-block-hash': instance.previousBlockHash,
      'rewards': instance.rewards,
      'round': const NullableBigIntSerializer().toJson(instance.round),
      'seed': instance.seed,
      'timestamp': instance.timestamp,
      'transactions': instance.transactions,
      'transactions-root': instance.transactionsRoot,
      'txn-counter': instance.txnCounter,
      'upgrade-state': instance.upgradeState,
      'upgrade-vote': instance.upgradeVote,
    };
