import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class SignatureSerializer implements JsonConverter<Uint8List?, dynamic> {
  const SignatureSerializer();

  @override
  Uint8List? fromJson(dynamic data) {
    if (data == null) return null;

    if (data is Uint8List) {
      return data;
    }

    if (data is String) {
      return base64Decode(data);
    }

    return null;
  }

  @override
  dynamic toJson(Uint8List? data) => data != null ? base64.encode(data) : null;
}
