import 'package:algorand_dart/src/api/block/block.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Block {
  /// hash to which this block belongs.
  final String? genesisHash;

  ///  ID to which this block belongs.
  final String? genesisId;

  /// Previous block hash.
  final String? previousBlockHash;

  /// Rewards for this block
  final BlockRewards? rewards;

  /// Current round on which this block was appended to the chain.
  @JsonKey(name: 'round')
  @NullableBigIntSerializer()
  final BigInt? round;

  /// Sortition seed.
  final String? seed;

  /// Block creation timestamp in seconds since eposh
  final int? timestamp;

  /// List of transactions corresponding to a given round.
  @JsonKey(name: 'transactions', defaultValue: [])
  final List<Transaction> transactions;

  /// TransactionsRoot authenticates the set of transactions appearing in
  /// the block.
  /// More specifically, it's the root of a merkle tree whose leaves are the
  /// block's Txids, in lexicographic order.
  ///
  /// For the empty block, it's 0. Note that the TxnRoot does not authenticate
  /// the signatures on the transactions, only the transactions themselves.
  ///
  /// Two blocks with the same transactions but in a different order and
  /// with different signatures will have the same TxnRoot.
  final String? transactionsRoot;

  /// TxnCounter counts the number of transactions committed in the ledger,
  /// from the time at which support for this feature was introduced.
  final int? txnCounter;

  final BlockUpgradeState? upgradeState;

  final BlockUpgradeVote? upgradeVote;

  Block({
    required this.transactions,
    this.genesisHash,
    this.genesisId,
    this.previousBlockHash,
    this.round,
    this.seed,
    this.timestamp,
    this.transactionsRoot,
    this.rewards,
    this.txnCounter,
    this.upgradeState,
    this.upgradeVote,
  });

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);

  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
