import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/serializers/byte_array_serializer.dart';
import 'package:algorand_dart/src/utils/serializers/transaction_serializer.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'algod_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AlgodTransaction extends Equatable {
  /// The signature of the transaction
  @JsonKey(name: 'hgi', defaultValue: false)
  final bool hgi;

  /// The signature of the transaction
  @JsonKey(name: 'sig')
  @NullableByteArraySerializer()
  final Uint8List? signature;

  /// The raw data of the transaction
  @JsonKey(name: 'txn')
  @TransactionSerializer()
  final RawTransaction transaction;

  @JsonKey(name: 'dt')
  final Map<String, dynamic>? dt;

  AlgodTransaction({
    required this.hgi,
    required this.transaction,
    this.signature,
    this.dt,
  });

  factory AlgodTransaction.fromJson(Map<String, dynamic> json) =>
      _$AlgodTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$AlgodTransactionToJson(this);

  @override
  List<Object?> get props => [
        signature,
        transaction,
      ];
}
