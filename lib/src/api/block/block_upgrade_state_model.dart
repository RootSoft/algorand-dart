import 'package:json_annotation/json_annotation.dart';

part 'block_upgrade_state_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class BlockUpgradeState {
  /// The current protocol version.
  final String currentProtocol;

  /// The next proposed protocol version.
  final String? nextProtocol;

  /// Number of blocks which approved the protocol upgrade.
  final int? nextProtocolApprovals;

  /// Round on which the protocol upgrade will take effect.
  final int? nextProtocolSwitchOn;

  /// Deadline round for this protocol upgrade
  /// (No votes will be consider after this round).
  final int? nextProtocolVoteBefore;

  BlockUpgradeState({
    required this.currentProtocol,
    this.nextProtocol,
    this.nextProtocolApprovals,
    this.nextProtocolSwitchOn,
    this.nextProtocolVoteBefore,
  });

  factory BlockUpgradeState.fromJson(Map<String, dynamic> json) =>
      _$BlockUpgradeStateFromJson(json);

  Map<String, dynamic> toJson() => _$BlockUpgradeStateToJson(this);
}
