import 'package:json_annotation/json_annotation.dart';

part 'block_upgrade_vote_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class BlockUpgradeVote {
  /// Indicates a yes vote for the current proposal.
  final bool? upgradeApprove;

  /// Indicates the time between acceptance and execution.
  final int? upgradeDelay;

  /// Indicates a proposed upgrade.
  final String? upgradePropose;

  BlockUpgradeVote({
    this.upgradeApprove,
    this.upgradeDelay,
    this.upgradePropose,
  });

  factory BlockUpgradeVote.fromJson(Map<String, dynamic> json) =>
      _$BlockUpgradeVoteFromJson(json);

  Map<String, dynamic> toJson() => _$BlockUpgradeVoteToJson(this);
}
