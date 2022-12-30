import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dry_run_request_model.g.dart';

/// Request data type for dryrun endpoint. Given the Transactions and simulated
/// ledger state upload, run TEAL scripts and return debugging information.
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.kebab)
class DryRunRequest extends Equatable {
  @JsonKey(name: 'accounts')
  final List<AccountInformation> accounts;

  @JsonKey(name: 'apps')
  final List<Application> applications;

  /// LatestTimestamp is available to some TEAL scripts. Defaults to the latest
  /// confirmed timestamp this algod is attached to.
  @JsonKey(name: 'latest-timestamp')
  final int? latestTimestamp;

  /// ProtocolVersion specifies a specific version string to operate under,
  /// otherwise whatever the current protocol of the network this algod is
  /// running in.
  @JsonKey(name: 'protocol-version')
  final String? protocolVersion;

  /// Round is available to some TEAL scripts. Defaults to the current round on
  /// the network this algod is attached to.
  @JsonKey(name: 'round')
  final int? round;

  @JsonKey(name: 'sources')
  final List<DryRunSource> sources;

  @JsonKey(name: 'txns')
  final List<SignedTransaction> transactions;

  DryRunRequest({
    this.accounts = const [],
    this.applications = const [],
    this.latestTimestamp,
    this.protocolVersion,
    this.round,
    this.sources = const [],
    this.transactions = const [],
  });

  factory DryRunRequest.fromJson(Map<String, dynamic> json) =>
      _$DryRunRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DryRunRequestToJson(this);

  Uint8List toMessagePack() {
    return Encoder.encodeMessagePack(toJson());
  }

  @override
  List<Object?> get props => [
        accounts,
        applications,
        latestTimestamp,
        protocolVersion,
        round,
        sources,
        transactions,
      ];
}
