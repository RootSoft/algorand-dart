import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_transactions_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class SearchTransactionsResponse {
  final int currentRound;
  final String? nextToken;
  final List<Transaction> transactions;

  SearchTransactionsResponse({
    required this.currentRound,
    this.nextToken,
    required this.transactions,
  });

  factory SearchTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchTransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchTransactionsResponseToJson(this);
}
