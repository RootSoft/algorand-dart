// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_rewards_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockRewards _$BlockRewardsFromJson(Map<String, dynamic> json) => BlockRewards(
      feeSink: json['fee-sink'] as String,
      rewardsCalculationRound: json['rewards-calculation-round'] as int,
      rewardsLevel: json['rewards-level'] as int,
      rewardsPool: json['rewards-pool'] as String,
      rewardsRate: json['rewards-rate'] as int,
      rewardsResidue: json['rewards-residue'] as int,
    );

Map<String, dynamic> _$BlockRewardsToJson(BlockRewards instance) =>
    <String, dynamic>{
      'fee-sink': instance.feeSink,
      'rewards-calculation-round': instance.rewardsCalculationRound,
      'rewards-level': instance.rewardsLevel,
      'rewards-pool': instance.rewardsPool,
      'rewards-rate': instance.rewardsRate,
      'rewards-residue': instance.rewardsResidue,
    };
