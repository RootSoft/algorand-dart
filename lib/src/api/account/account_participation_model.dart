import 'package:json_annotation/json_annotation.dart';

part 'account_participation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AccountParticipation {
  /// Selection public key (if any) currently registered for this round.
  @JsonKey(name: 'selection-participation-key')
  final String? selectionParticipationKey;

  /// Root of the state proof key
  @JsonKey(name: 'state-proof-key')
  final String? stateProofKey;

  /// First round for which this participation is valid.
  @JsonKey(name: 'vote-first-valid', defaultValue: 0)
  final int voteFirstValid;

  /// Number of subkeys in each batch of participation keys.
  @JsonKey(name: 'vote-key-dilution', defaultValue: 0)
  final int voteKeyDilution;

  /// Last round for which this participation is valid.
  @JsonKey(name: 'vote-last-valid', defaultValue: 0)
  final int voteLastValid;

  /// root participation public key (if any) currently registered for
  /// this round.
  @JsonKey(name: 'vote-participation-key')
  final String? voteParticipationKey;

  AccountParticipation({
    required this.selectionParticipationKey,
    required this.stateProofKey,
    required this.voteFirstValid,
    required this.voteKeyDilution,
    required this.voteLastValid,
    required this.voteParticipationKey,
  });

  factory AccountParticipation.fromJson(Map<String, dynamic> json) =>
      _$AccountParticipationFromJson(json);

  Map<String, dynamic> toJson() => _$AccountParticipationToJson(this);
}
