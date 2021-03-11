import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pending_transaction_model.g.dart';

/// Given a transaction id of a recently submitted transaction, it returns
/// information about it.
/// There are several cases when this might succeed:
/// - transaction committed (committed round > 0)
/// - transaction still in the pool (committed round = 0, pool error = "")
/// - transaction removed from pool due to error
/// (committed round = 0, pool error != "")
///
/// Or the transaction may have happened sufficiently long ago that the node
/// no longer remembers it, and this will return an error.
@JsonSerializable(fieldRename: FieldRename.kebab)
class PendingTransaction {
  /// The application index if the transaction was found and it created an
  /// application.
  final int? applicationIndex;

  /// The asset index if the transaction was found and it created an asset.
  final int? assetIndex;

  /// Rewards in microalgos applied to the close remainder to account.
  final int? closeRewards;

  /// Closing amount for the transaction.
  final int? closingAmount;

  /// The round where this transaction was confirmed, if present.
  final int? confirmedRound;

  /// Global state key/value changes for the application being executed by this transaction.
  // StateDelta? globalStateDelta;

  /// Local state key/value changes for the application being executed by this transaction.
  // List<AccountStateDelta>![] localStateDelta;

  /// Indicates that the transaction was kicked out of this node's
  /// transaction pool  (and specifies why that happened).
  ///
  /// An empty string indicates the transaction wasn't kicked out of this
  /// node's txpool due to an error.
  final String poolError;

  /// Rewards in microalgos applied to the receiver account.
  final int? receiverRewards;

  /// Rewards in microalgos applied to the sender account.
  final int? senderRewards;

  /// The raw signed transaction.
  @JsonKey(name: 'txn')
  final SignedTransaction transaction;

  PendingTransaction({
    required this.transaction,
    required this.poolError,
    this.applicationIndex,
    this.assetIndex,
    this.closeRewards,
    this.closingAmount,
    this.confirmedRound,
    this.receiverRewards,
    this.senderRewards,
  });

  factory PendingTransaction.fromJson(Map<String, dynamic> json) =>
      _$PendingTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$PendingTransactionToJson(this);
}
