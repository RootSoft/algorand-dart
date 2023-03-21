import 'package:algorand_dart/src/api/application/application.dart';
import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

/// Contains all fields common to all transactions and serves as an envelope to
/// all transactions type. Represents both regular and inner transactions.
@JsonSerializable(fieldRename: FieldRename.kebab)
class Transaction {
  /// Rewards applied to close-remainder-to account.
  final int? closeRewards;

  /// Closing amount for transaction.
  final int? closingAmount;

  /// Round when the transaction was confirmed.
  final int? confirmedRound;

  /// Specifies an application index (ID) if an application was created with
  /// this transaction.
  @JsonKey(name: 'created-application-index')
  final int? createdApplicationIndex;

  /// Specifies an asset index (ID) if an asset was created with
  /// this transaction.
  @JsonKey(name: 'created-asset-index')
  final int? createdAssetIndex;

  /// Transaction fee.
  @JsonKey(name: 'fee')
  @BigIntSerializer()
  final BigInt fee;

  /// First valid round for this transaction
  @JsonKey(name: 'first-valid')
  @BigIntSerializer()
  final BigInt firstValid;

  /// Last valid round for this transaction.
  @JsonKey(name: 'last-valid')
  @BigIntSerializer()
  final BigInt lastValid;

  /// Hash of genesis block.
  final String? genesisHash;

  /// Genesis block ID.
  final String? genesisId;

  /// Global state key/value changes for the application being executed by this
  /// transaction.
  @JsonKey(name: 'global-state-delta', defaultValue: [])
  final List<EvalDeltaKeyValue> globalStateDelta;

  /// Local state key/value changes for the application being executed by this
  /// transaction.
  @JsonKey(name: 'local-state-delta', defaultValue: [])
  final List<AccountStateDelta> localStateDelta;

  /// Logs for the application being executed by this transaction.
  @JsonKey(name: 'logs', defaultValue: [])
  final List<String> logs;

  /// Base64 encoded byte array of a sha512/256 digest. When present indicates
  /// that this transaction is part of a transaction group and the value is the
  /// sha512/256 hash of the transactions in that group.
  @JsonKey(name: 'group')
  final String? group;

  /// Base64 encoded 32-byte array. Lease enforces mutual exclusion of
  /// transactions. If this field is nonzero, then once the transaction is
  /// confirmed, it acquires the lease identified by the (Sender, Lease) pair
  /// of the transaction until the LastValid round passes.
  /// While this transaction possesses the lease, no other transaction
  /// specifying this lease can be confirmed.
  @JsonKey(name: 'lease')
  final String? lease;

  /// Transaction ID
  @JsonKey(name: 'id')
  final String? id;

  /// Offset into the round where this transaction was confirmed.
  final int? intraRoundOffset;

  /// Rewards applied to receiver account.
  final int? receiverRewards;

  /// Time when the block this transaction is in was confirmed.
  final int? roundTime;

  /// Sender's address.
  final String sender;

  /// Rewards applied to sender account.
  final int? senderRewards;

  /// Validation signature associated with some data.
  final TransactionSignature? signature;

  /// Indicates what type of transaction this is.
  /// Different types have different fields.
  /// Valid types, and where their fields are stored:
  /// [pay] payment-transaction
  /// [keyreg] keyreg-transaction
  /// [acfg] asset-config-transaction
  /// [axfer] asset-transfer-transaction
  /// [afrz] asset-freeze-transaction
  /// [appl] application-transaction
  @JsonKey(name: 'tx-type')
  final String type;

  /// Free form data.
  final String? note;

  /// (sgnr) this is included with signed transactions when the signing address
  /// does not equal the sender. The backend can use this to ensure that auth
  /// addr is equal to the accounts auth addr.
  @JsonKey(name: 'auth-addr')
  final String? authAddress;

  /// When included in a valid transaction, the accounts auth addr will be
  /// updated with this value and future signatures must be signed with the key
  /// represented by this address.
  @JsonKey(name: 'rekey-to')
  final String? rekeyTo;

  /// Inner transactions produced by application execution.
  @JsonKey(name: 'inner-txns', defaultValue: [])
  final List<Transaction> innerTxns;

  /// Optional information about a payment transaction - see payment
  @JsonKey(name: 'payment-transaction')
  final PaymentTransactionResponse? paymentTransaction;

  /// Fields for application transactions.
  @JsonKey(name: 'application-transaction')
  final ApplicationTransactionResponse? applicationTransaction;

  /// Fields for asset allocation, re-configuration, and destruction.
  /// A zero value for asset-id indicates asset creation.
  /// A zero value for the params indicates asset destruction.
  @JsonKey(name: 'asset-config-transaction')
  final AssetConfigTransactionResponse? assetConfigTransaction;

  /// Fields for an asset freeze transaction.
  @JsonKey(name: 'asset-freeze-transaction')
  final AssetFreezeTransactionResponse? assetFreezeTransaction;

  /// Fields for an asset transfer transaction.
  @JsonKey(name: 'asset-transfer-transaction')
  final AssetTransferTransactionResponse? assetTransferTransaction;

  /// Fields for a key registration transaction
  @JsonKey(name: 'keyreg-transaction')
  final KeyRegistrationTransactionResponse? keyRegistrationTransaction;

  Transaction({
    required this.id,
    required this.fee,
    required this.firstValid,
    required this.lastValid,
    required this.sender,
    required this.type,
    required this.signature,
    required this.globalStateDelta,
    required this.localStateDelta,
    required this.innerTxns,
    required this.logs,
    this.createdApplicationIndex,
    this.createdAssetIndex,
    this.closeRewards,
    this.closingAmount,
    this.confirmedRound,
    this.genesisHash,
    this.genesisId,
    this.intraRoundOffset,
    this.receiverRewards,
    this.roundTime,
    this.senderRewards,
    this.group,
    this.lease,
    this.note,
    this.authAddress,
    this.rekeyTo,
    this.paymentTransaction,
    this.applicationTransaction,
    this.assetConfigTransaction,
    this.assetFreezeTransaction,
    this.assetTransferTransaction,
    this.keyRegistrationTransaction,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
