import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block_rewards_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class BlockRewards {
  /// accepts transaction fees, it can only spend to the incentive pool.
  final String feeSink;

  /// number of leftover MicroAlgos after the distribution of rewards-rate
  /// MicroAlgos for every reward unit in the next round.
  @JsonKey(name: 'rewards-calculation-round')
  @BigIntSerializer()
  final BigInt rewardsCalculationRound;

  /// How many rewards, in MicroAlgos, have been distributed to each RewardUnit
  /// of MicroAlgos since genesis.
  @JsonKey(name: 'rewards-level')
  @BigIntSerializer()
  final BigInt rewardsLevel;

  /// accepts periodic injections from the fee-sink and continually
  /// redistributes them as rewards.
  final String rewardsPool;

  /// Number of new MicroAlgos added to the participation stake from rewards at
  /// the next round.
  @JsonKey(name: 'rewards-rate')
  @BigIntSerializer()
  final BigInt rewardsRate;

  /// Number of leftover MicroAlgos after the distribution of
  /// RewardsRate/rewardUnits MicroAlgos for every reward unit in the next round.
  @JsonKey(name: 'rewards-residue')
  @BigIntSerializer()
  final BigInt rewardsResidue;

  BlockRewards({
    required this.feeSink,
    required this.rewardsCalculationRound,
    required this.rewardsLevel,
    required this.rewardsPool,
    required this.rewardsRate,
    required this.rewardsResidue,
  });

  factory BlockRewards.fromJson(Map<String, dynamic> json) =>
      _$BlockRewardsFromJson(json);

  Map<String, dynamic> toJson() => _$BlockRewardsToJson(this);
}
