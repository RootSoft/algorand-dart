import 'package:algorand_dart/src/api/algod/signed_transaction_with_ad.dart';
import 'package:algorand_dart/src/api/converters/byte_array_to_b64_converter.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'algod_block_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AlgodBlock {
  /// hash to which this block belongs.
  @JsonKey(name: 'gh')
  @ByteArrayToB64Converter()
  final String? genesisHash;

  ///  ID to which this block belongs.
  @JsonKey(name: 'gen')
  final String? genesisId;

  /// Previous block hash.
  @JsonKey(name: 'prev')
  @ByteArrayToB64Converter()
  final String? previousBlockHash;

  /// Current round on which this block was appended to the chain.
  @JsonKey(name: 'rnd')
  @NullableBigIntSerializer()
  final BigInt? round;

  /// Sortition seed.
  @JsonKey(name: 'seed')
  @ByteArrayToB64Converter()
  final String? seed;

  /// Block creation timestamp in seconds since eposh
  @JsonKey(name: 'ts')
  final int? timestamp;

  /// List of transactions corresponding to a given round.
  @JsonKey(name: 'txns', defaultValue: [])
  @ListAlgodTransactionConverter()
  final List<SignedTransactionWithAD> transactions;

  /// TxnCounter counts the number of transactions committed in the ledger,
  /// from the time at which support for this feature was introduced.
  @JsonKey(name: 'tc')
  final int? txnCounter;

  AlgodBlock({
    required this.transactions,
    this.genesisHash,
    this.genesisId,
    this.previousBlockHash,
    this.round,
    this.seed,
    this.timestamp,
    this.txnCounter,
  });

  factory AlgodBlock.fromJson(Map<String, dynamic> json) =>
      _$AlgodBlockFromJson(json);

  Map<String, dynamic> toJson() => _$AlgodBlockToJson(this);
}
