import 'dart:convert';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:json_annotation/json_annotation.dart';

class Base32Serializer implements JsonConverter<Uint8List?, String?> {
  const Base32Serializer();

  @override
  Uint8List? fromJson(String? json) {
    if (json == null) {
      return null;
    }

    try {
      return base32.decode(json);
    } on FormatException {
      return Uint8List.fromList(utf8.encode(json));
    }
  }

  @override
  String? toJson(Uint8List? data) => data != null ? base32.encode(data) : null;
}
