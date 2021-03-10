import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pending_transactions_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class PendingTransactionsResponse {
  /// An array of signed transaction objects.
  @JsonKey(name: 'top-transactions')
  final List<SignedTransaction> transactions;

  /// Total number of transactions in the pool.
  final int totalTransactions;

  PendingTransactionsResponse({
    required this.transactions,
    required this.totalTransactions,
  });

  factory PendingTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PendingTransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PendingTransactionsResponseToJson(this);
}
