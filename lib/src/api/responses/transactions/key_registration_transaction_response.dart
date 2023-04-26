import 'package:json_annotation/json_annotation.dart';

part 'key_registration_transaction_response.g.dart';

/// Fields for a key registration transaction.
@JsonSerializable(fieldRename: FieldRename.kebab)
class KeyRegistrationTransactionResponse {
  /// Mark the account as participating or non-participating.
  @JsonKey(name: 'non-participation')
  final bool? nonParticipation;

  /// Public key used with the Verified Random Function (VRF) result during
  /// committee selection.
  @JsonKey(name: 'selection-participation-key')
  final String? selectionParticipationKey;

  /// Root of the state proof key (if any)
  @JsonKey(name: 'state-proof-key')
  final String? stateProofKey;

  /// First round this participation key is valid.
  @JsonKey(name: 'vote-first-valid')
  final int? voteFirstValid;

  /// Last round this participation key is valid.
  @JsonKey(name: 'vote-last-valid')
  final int? voteLastValid;

  /// Number of subkeys in each batch of participation keys.
  @JsonKey(name: 'vote-key-dilution')
  final int? voteKeyDilution;

  /// Participation public key used in key registration transactions.
  @JsonKey(name: 'vote-participation-key')
  final String? voteParticipationKey;

  KeyRegistrationTransactionResponse({
    this.nonParticipation,
    this.selectionParticipationKey,
    this.stateProofKey,
    this.voteFirstValid,
    this.voteLastValid,
    this.voteKeyDilution,
    this.voteParticipationKey,
  });

  factory KeyRegistrationTransactionResponse.fromJson(
          Map<String, dynamic> json) =>
      _$KeyRegistrationTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$KeyRegistrationTransactionResponseToJson(this);
}
