import 'package:algorand_dart/src/api/algod/algod_transaction.dart';
import 'package:algorand_dart/src/api/algod/apply_data.dart';
import 'package:algorand_dart/src/api/algod/signed_transaction_with_ad.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts encoded transactions from the [Algod] endpoint and applies the data.
///
class ListAlgodTransactionConverter
    extends JsonConverter<List<SignedTransactionWithAD>, List<dynamic>> {
  const ListAlgodTransactionConverter();

  @override
  List<SignedTransactionWithAD> fromJson(List<dynamic> json) {
    final data = json
        .map((e) {
          if (e is! Map<String, dynamic>) {
            return null;
          }

          final txn = AlgodTransaction.fromJson(e);
          final data = ApplyData.fromMessagePack(e);

          return SignedTransactionWithAD(
            txn: txn,
            applyData: data,
          );
        })
        .whereNotNull()
        .toList();

    return data;
  }

  @override
  List<dynamic> toJson(List<SignedTransactionWithAD> object) {
    return [];
  }
}
