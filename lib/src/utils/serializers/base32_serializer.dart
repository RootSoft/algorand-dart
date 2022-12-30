import 'dart:convert';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:json_annotation/json_annotation.dart';

class Base32Serializer implements JsonConverter<Uint8List?, dynamic> {
  const Base32Serializer();

  @override
  Uint8List? fromJson(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Uint8List) {
      return data;
    }

    if (data is String) {
      try {
        return base32.decode(data);
      } on FormatException {
        return Uint8List.fromList(utf8.encode(data));
      }
    }
    return null;
  }

  @override
  String? toJson(Uint8List? data) => data != null ? base32.encode(data) : null;
}
