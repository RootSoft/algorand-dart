import 'package:json_annotation/json_annotation.dart';

part 'transaction_id_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class TransactionIdResponse {
  @JsonKey(name: 'txId')
  final String transactionId;

  TransactionIdResponse({required this.transactionId});

  factory TransactionIdResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionIdResponseToJson(this);
}
