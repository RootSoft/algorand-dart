// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_rewards_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockRewards _$BlockRewardsFromJson(Map<String, dynamic> json) => BlockRewards(
      feeSink: json['fee-sink'] as String,
      rewardsCalculationRound:
          const BigIntSerializer().fromJson(json['rewards-calculation-round']),
      rewardsLevel: const BigIntSerializer().fromJson(json['rewards-level']),
      rewardsPool: json['rewards-pool'] as String,
      rewardsRate: const BigIntSerializer().fromJson(json['rewards-rate']),
      rewardsResidue:
          const BigIntSerializer().fromJson(json['rewards-residue']),
    );

Map<String, dynamic> _$BlockRewardsToJson(BlockRewards instance) =>
    <String, dynamic>{
      'fee-sink': instance.feeSink,
      'rewards-calculation-round':
          const BigIntSerializer().toJson(instance.rewardsCalculationRound),
      'rewards-level': const BigIntSerializer().toJson(instance.rewardsLevel),
      'rewards-pool': instance.rewardsPool,
      'rewards-rate': const BigIntSerializer().toJson(instance.rewardsRate),
      'rewards-residue':
          const BigIntSerializer().toJson(instance.rewardsResidue),
    };
