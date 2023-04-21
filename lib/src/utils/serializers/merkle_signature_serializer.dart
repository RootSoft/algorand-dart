import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

class MerkleSignatureSerializer
    implements JsonConverter<MerkleSignatureVerifier?, dynamic> {
  const MerkleSignatureSerializer();

  @override
  MerkleSignatureVerifier? fromJson(dynamic data) {
    if (data == null) return null;

    if (data is Uint8List) {
      return MerkleSignatureVerifier(bytes: data);
    }

    if (data is String) {
      return MerkleSignatureVerifier(bytes: base64Decode(data));
    }

    return null;
  }

  @override
  String? toJson(MerkleSignatureVerifier? data) =>
      data != null ? base64.encode(data.bytes) : null;
}
