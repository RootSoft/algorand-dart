import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'node_status_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class NodeStatus implements Equatable {
  /// CatchupTime in nanoseconds
  final int catchupTime;

  /// LastRound indicates the last round seen
  final int lastRound;

  /// LastVersion indicates the last consensus version supported
  final String lastVersion;

  /// NextVersion of consensus protocol to use
  final String nextVersion;

  /// NextVersionRound is the round at which the next consensus version will
  /// apply
  final int nextVersionRound;

  /// NextVersionSupported indicates whether the next consensus version is
  /// supported by this node
  final bool nextVersionSupported;

  /// StoppedAtUnsupportedRound indicates that the node does not support the
  /// new rounds and has stopped making progress
  final bool stoppedAtUnsupportedRound;

  /// TimeSinceLastRound in nanoseconds
  final int timeSinceLastRound;

  /// The current catchpoint that is being caught up to
  final String? catchpoint;

  /// The number of blocks that have already been obtained by the node as part
  /// of the catchup
  final int? catchpointAcquiredBlocks;

  /// The number of accounts from the current catchpoint that have been
  /// processed so far as part of the catchup
  final int? catchpointProcessedAccounts;

  /// The total number of accounts included in the current catchpoint
  final int? catchpointTotalAccounts;

  /// The total number of blocks that are required to complete the current
  /// catchpoint catchup
  final int? catchpointTotalBlocks;

  /// The number of accounts from the current catchpoint that have been
  /// verified so far as part of the catchup
  final int? catchpointVerifiedAccounts;

  /// The last catchpoint seen by the node
  final String? lastCatchpoint;

  NodeStatus({
    required this.catchupTime,
    required this.lastRound,
    required this.lastVersion,
    required this.nextVersion,
    required this.nextVersionRound,
    required this.nextVersionSupported,
    required this.stoppedAtUnsupportedRound,
    required this.timeSinceLastRound,
    this.catchpoint,
    this.catchpointAcquiredBlocks,
    this.catchpointProcessedAccounts,
    this.catchpointTotalAccounts,
    this.catchpointTotalBlocks,
    this.catchpointVerifiedAccounts,
    this.lastCatchpoint,
  });

  factory NodeStatus.fromJson(Map<String, dynamic> json) =>
      _$NodeStatusFromJson(json);

  Map<String, dynamic> toJson() => _$NodeStatusToJson(this);

  @override
  List<Object?> get props => [
        catchupTime,
        lastRound,
        lastVersion,
        nextVersion,
        nextVersionRound,
        nextVersionSupported,
        stoppedAtUnsupportedRound,
        timeSinceLastRound,
        catchpoint,
        catchpointAcquiredBlocks,
        catchpointProcessedAccounts,
        catchpointTotalAccounts,
        catchpointTotalBlocks,
        catchpointVerifiedAccounts,
        lastCatchpoint,
      ];

  @override
  bool get stringify => true;
}
