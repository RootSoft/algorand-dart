import 'package:algorand_dart/src/api/account/account.dart';
import 'package:algorand_dart/src/api/application/application.dart';
import 'package:algorand_dart/src/api/asset/asset.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_information_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AccountInformation {
  /// the account public key
  final String address;

  /// total number of MicroAlgos in the account
  @JsonKey(name: 'amount')
  @BigIntSerializer()
  final BigInt amount;

  /// specifies the amount of MicroAlgos in the account, without the pending
  /// rewards.
  @JsonKey(name: 'amount-without-pending-rewards')
  @BigIntSerializer()
  final BigInt amountWithoutPendingRewards;

  /// Round during which this account first appeared in a transaction.
  @JsonKey(name: 'created-at-round')
  @NullableBigIntSerializer()
  final int? createdAtRound;

  /// Whether or not this account is currently closed.
  @JsonKey(name: 'deleted', defaultValue: false)
  final bool deleted;

  /// amount of MicroAlgos of pending rewards in this account.
  @JsonKey(name: 'pending-rewards')
  @BigIntSerializer()
  final BigInt pendingRewards;

  /// used as part of the rewards computation.
  /// Only applicable to accounts which are participating.
  @JsonKey(name: 'reward-base')
  @NullableBigIntSerializer()
  final BigInt? rewardBase;

  /// total rewards of MicroAlgos the account has received,
  /// including pending rewards.
  @JsonKey(name: 'rewards')
  @BigIntSerializer()
  final BigInt rewards;

  /// The round for which this information is relevant.
  @JsonKey(name: 'round')
  @BigIntSerializer()
  final BigInt round;

  /// Delegation status of the account's MicroAlgos
  /// * Offline - the associated account is delegated.
  /// * Online - the associated account used as part of the delegation pool.
  /// * NotParticipating - the associated account is neither a delegator nor a
  /// delegate.
  final String status;

  /// Round during which this account was most recently closed.
  @JsonKey(name: 'closed-at-round')
  @NullableBigIntSerializer()
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

  /// The sum of all extra application program pages for this account.
  @JsonKey(name: 'apps-total-extra-pages')
  final int? appsTotalExtraPages;

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

  /// The minimum balance required
  @JsonKey(name: 'min-balance')
  @NullableBigIntSerializer()
  final BigInt? minimumBalance;

  /// The count of all applications that have been opted in, equivalent to the
  /// count of application local data (AppLocalState objects) stored in this
  /// account.
  @JsonKey(name: 'total-apps-opted-in', defaultValue: 0)
  final int totalAppsOptedIn;

  /// The count of all assets that have been opted in, equivalent to the count
  /// of AssetHolding objects held by this account.
  @JsonKey(name: 'total-assets-opted-in', defaultValue: 0)
  final int totalAssetsOptedIn;

  /// The total number of bytes used by this account's app's box keys and
  /// values.
  @JsonKey(name: 'total-box-bytes')
  final int? totalBoxBytes;

  /// The number of existing boxes created by this account's app.
  @JsonKey(name: 'total-boxes')
  final int? totalBoxes;

  /// The count of all apps (AppParams objects) created by this account.
  @JsonKey(name: 'total-created-apps', defaultValue: 0)
  final int totalCreatedApps;

  /// The count of all assets (AssetParams objects) created by this account.
  @JsonKey(name: 'total-created-assets', defaultValue: 0)
  final int totalCreatedAssets;

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
    required this.totalAppsOptedIn,
    required this.totalAssetsOptedIn,
    required this.totalBoxBytes,
    required this.totalBoxes,
    required this.totalCreatedApps,
    required this.totalCreatedAssets,
    this.createdAtRound,
    this.participation,
    this.rewardBase,
    this.closedAtRound,
    this.signatureType,
    this.authAddress,
    this.appsTotalSchema,
    this.minimumBalance,
    this.appsTotalExtraPages,
  });

  factory AccountInformation.empty(String address) {
    return AccountInformation(
      address: address,
      amount: BigInt.zero,
      amountWithoutPendingRewards: BigInt.zero,
      pendingRewards: BigInt.zero,
      rewards: BigInt.zero,
      round: BigInt.zero,
      status: 'Offline',
      deleted: false,
      assets: [],
      appsLocalState: [],
      createdApps: [],
      createdAssets: [],
      totalAppsOptedIn: 0,
      totalAssetsOptedIn: 0,
      totalBoxBytes: null,
      totalBoxes: null,
      totalCreatedApps: 0,
      totalCreatedAssets: 0,
      minimumBalance: BigInt.from(100000),
    );
  }

  factory AccountInformation.fromJson(Map<String, dynamic> json) =>
      _$AccountInformationFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInformationToJson(this);
}
