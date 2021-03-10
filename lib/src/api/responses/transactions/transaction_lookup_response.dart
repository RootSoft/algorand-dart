import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_lookup_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class TransactionResponse {
  /// Round at which the results were computed.
  final int currentRound;
  final Transaction transaction;

  TransactionResponse({required this.currentRound, required this.transaction});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
