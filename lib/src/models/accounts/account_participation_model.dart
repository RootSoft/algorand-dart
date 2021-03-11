import 'package:json_annotation/json_annotation.dart';

part 'account_participation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AccountParticipation {
  /// Selection public key (if any) currently registered for this round.
  final String selectionParticipationKey;

  /// First round for which this participation is valid.
  final int voteFirstValid;

  /// Number of subkeys in each batch of participation keys.
  final int voteKeyDilution;

  /// Last round for which this participation is valid.
  final int voteLastValid;

  /// root participation public key (if any) currently registered for
  /// this round.
  final String voteParticipationKey;

  AccountParticipation({
    required this.selectionParticipationKey,
    required this.voteFirstValid,
    required this.voteKeyDilution,
    required this.voteLastValid,
    required this.voteParticipationKey,
  });

  factory AccountParticipation.fromJson(Map<String, dynamic> json) =>
      _$AccountParticipationFromJson(json);

  Map<String, dynamic> toJson() => _$AccountParticipationToJson(this);
}
