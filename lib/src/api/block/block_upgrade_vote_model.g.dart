// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_upgrade_vote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockUpgradeVote _$BlockUpgradeVoteFromJson(Map<String, dynamic> json) =>
    BlockUpgradeVote(
      upgradeApprove: json['upgrade-approve'] as bool?,
      upgradeDelay: json['upgrade-delay'] as int?,
      upgradePropose: json['upgrade-propose'] as String?,
    );

Map<String, dynamic> _$BlockUpgradeVoteToJson(BlockUpgradeVote instance) =>
    <String, dynamic>{
      'upgrade-approve': instance.upgradeApprove,
      'upgrade-delay': instance.upgradeDelay,
      'upgrade-propose': instance.upgradePropose,
    };
