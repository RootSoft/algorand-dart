import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:json_annotation/json_annotation.dart';

class ByteArrayToB32Converter implements JsonConverter<String?, dynamic> {
  const ByteArrayToB32Converter();

  @override
  String? fromJson(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Uint8List) {
      return base32.encode(data);
    }

    if (data is String) {
      return data;
    }

    return null;
  }

  @override
  dynamic toJson(String? data) => data != null ? base32.decode(data) : null;
}
