import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';

class SignatureSerializer implements JsonConverter<Signature?, dynamic> {
  const SignatureSerializer();

  @override
  Signature? fromJson(dynamic data) {
    if (data == null) return null;

    if (data is Uint8List) {
      return Signature(bytes: data);
    }

    if (data is String) {
      return Signature(bytes: base64Decode(data));
    }

    return null;
  }

  @override
  dynamic toJson(Signature? data) =>
      data != null ? base64.encode(data.bytes) : null;
}
