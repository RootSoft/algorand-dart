import 'dart:typed_data';

import 'package:algorand_dart/src/utils/serializers/bigint_serializer.dart';
import 'package:algorand_dart/src/utils/serializers/byte_array_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_params_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class TransactionParams {
  /// indicates the consensus protocol version as of LastRound.
  final String consensusVersion;

  /// Fee is the suggested transaction fee
  /// Fee is in units of micro-Algos per byte.
  /// Fee may fall to zero but transactions must still have a fee of
  /// at least MinTxnFee for the current network protocol.
  @JsonKey(name: 'fee')
  @BigIntSerializer()
  final BigInt fee;

  /// GenesisID is an ID listed in the genesis block.
  final String genesisId;

  /// GenesisHash is the hash of the genesis block.
  @JsonKey(name: 'genesis-hash')
  @NullableByteArraySerializer()
  final Uint8List? genesisHash;

  /// LastRound indicates the last round seen
  @JsonKey(name: 'last-round')
  @BigIntSerializer()
  final BigInt lastRound;

  /// The minimum transaction fee (not per byte) required for the txn to
  /// validate for the current network protocol.
  @JsonKey(name: 'min-fee')
  @BigIntSerializer()
  final BigInt minFee;

  TransactionParams({
    required this.consensusVersion,
    required this.fee,
    required this.genesisId,
    required this.genesisHash,
    required this.lastRound,
    required this.minFee,
  });

  factory TransactionParams.fromJson(Map<String, dynamic> json) =>
      _$TransactionParamsFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionParamsToJson(this);

  TransactionParams copyWith({
    String? consensusVersion,
    BigInt? fee,
    String? genesisId,
    Uint8List? genesisHash,
    BigInt? lastRound,
    BigInt? minFee,
  }) {
    return TransactionParams(
      consensusVersion: consensusVersion ?? this.consensusVersion,
      fee: fee ?? this.fee,
      genesisId: genesisId ?? this.genesisId,
      genesisHash: genesisHash ?? this.genesisHash,
      lastRound: lastRound ?? this.lastRound,
      minFee: minFee ?? this.minFee,
    );
  }
}
