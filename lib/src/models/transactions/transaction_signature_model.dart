import 'package:json_annotation/json_annotation.dart';

part 'transaction_signature_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class TransactionSignature {
  /// Standard ed25519 signature.
  @JsonKey(name: 'sig')
  final String? signature;

  TransactionSignature({
    this.signature,
  });

  factory TransactionSignature.fromJson(Map<String, dynamic> json) =>
      _$TransactionSignatureFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionSignatureToJson(this);
}
