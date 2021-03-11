import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_information_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AccountInformation {
  /// the account public key
  final String address;

  /// total number of MicroAlgos in the account
  final int amount;

  /// specifies the amount of MicroAlgos in the account, without the pending
  /// rewards.
  final int amountWithoutPendingRewards;

  /// Round during which this account first appeared in a transaction.
  final int? createdAtRound;

  /// Whether or not this account is currently closed.
  @JsonKey(name: 'deleted', defaultValue: false)
  final bool deleted;

  /// amount of MicroAlgos of pending rewards in this account.
  final int pendingRewards;

  /// used as part of the rewards computation.
  /// Only applicable to accounts which are participating.
  final int? rewardBase;

  /// total rewards of MicroAlgos the account has received,
  /// including pending rewards.
  final int rewards;

  /// The round for which this information is relevant.
  final int round;

  /// Delegation status of the account's MicroAlgos
  /// * Offline - the associated account is delegated.
  /// * Online - the associated account used as part of the delegation pool.
  /// * NotParticipating - the associated account is neither a delegator nor a
  /// delegate.
  final String status;

  /// Round during which this account was most recently closed.
  final int? closedAtRound;

  /// Indicates what type of signature is used by this account, must be one of:
  /// * sig
  /// * msig
  /// * lsig
  @JsonKey(name: 'sig-type', defaultValue: null)
  final SignatureType? signatureType;

  /// the address against which signing should be checked.
  /// If empty, the address of the current account is used.
  /// This field can be updated in any transaction by setting the RekeyTo field.
  @JsonKey(name: 'auth-addr')
  final String? authAddress;

  /// assets held by this account.
  @JsonKey(name: 'assets', defaultValue: [])
  final List<AssetHolding> assets;

  /// applications local data stored in this account.
  @JsonKey(name: 'apps-local-state', defaultValue: [])
  final List<ApplicationLocalState> appsLocalState;

  ///  stores the sum of all of the local schemas and global schemas in this
  ///  account.
  final ApplicationStateSchema? appsTotalSchema;

  /// parameters of applications created by this account including app global
  /// data.
  @JsonKey(name: 'created-apps', defaultValue: [])
  final List<Application> createdApps;

  /// parameters of assets created by this account.
  @JsonKey(name: 'created-assets', defaultValue: [])
  final List<Asset> createdAssets;

  ///
  final AccountParticipation? participation;

  AccountInformation({
    required this.address,
    required this.amount,
    required this.amountWithoutPendingRewards,
    required this.pendingRewards,
    required this.rewards,
    required this.round,
    required this.status,
    required this.deleted,
    required this.assets,
    required this.appsLocalState,
    required this.createdApps,
    required this.createdAssets,
    this.createdAtRound,
    this.participation,
    this.rewardBase,
    this.closedAtRound,
    this.signatureType,
    this.authAddress,
    this.appsTotalSchema,
  });

  factory AccountInformation.fromJson(Map<String, dynamic> json) =>
      _$AccountInformationFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInformationToJson(this);
}
