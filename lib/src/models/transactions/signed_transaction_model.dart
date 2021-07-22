import 'dart:io';
import 'dart:typed_data';

import 'package:algorand_dart/src/crypto/crypto.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/encoders/msgpack_encoder.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:algorand_dart/src/utils/serializers/address_serializer.dart';
import 'package:algorand_dart/src/utils/serializers/signature_serializer.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signed_transaction_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.kebab)
class SignedTransaction implements MessagePackable {
  /// The signature of the transaction
  @JsonKey(name: 'sig', ignore: true)
  @SignatureSerializer()
  final Uint8List? signature;

  /// The raw data of the transaction
  @JsonKey(name: 'txn')
  final RawTransaction transaction;

  /// Optional auth address when
  @JsonKey(name: 'sgnr')
  @AddressSerializer()
  Address? authAddress;

  /// The logic signature
  @JsonKey(name: 'lsig', ignore: true)
  final LogicSignature? logicSignature;

  SignedTransaction({
    required this.transaction,
    this.signature,
    this.logicSignature,
  });

  /// Export the transaction to a file.
  ///
  /// This creates a new File with the given filePath and streams the encoded
  /// transaction to it.
  Future<File> export(String filePath) async {
    final encodedTransaction = Encoder.encodeMessagePack(toMessagePack());
    return File(filePath).writeAsBytes(encodedTransaction);
  }

  factory SignedTransaction.fromJson(Map<String, dynamic> json) =>
      _$SignedTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$SignedTransactionToJson(this);

  @override
  Map<String, dynamic> toMessagePack() {
    return {
      'sgnr': const AddressTransformer().toMessagePack(authAddress),
      'sig': signature,
      'txn': transaction.toMessagePack(),
      'lsig': logicSignature?.toMessagePack(),
    };
  }
}
