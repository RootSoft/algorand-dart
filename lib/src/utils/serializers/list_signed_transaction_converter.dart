import 'package:algorand_dart/algorand_dart.dart';
import 'package:json_annotation/json_annotation.dart';

class ListSignedTransactionConverter
    extends JsonConverter<List<SignedTransaction>, List<dynamic>> {
  const ListSignedTransactionConverter();

  @override
  List<SignedTransaction> fromJson(List<dynamic> json) {
    return json
        .whereType<Map<String, dynamic>>()
        .map(SignedTransaction.fromJson)
        .toList();
  }

  @override
  List<dynamic> toJson(List<SignedTransaction> object) {
    return object
        .map((e) => Encoder.prepareMessagePack(e.toMessagePack()))
        .toList();
  }
}
