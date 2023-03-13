import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class ByteArrayToB64Converter implements JsonConverter<String?, dynamic> {
  const ByteArrayToB64Converter();

  @override
  String? fromJson(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Uint8List) {
      return base64.encode(data);
    }

    if (data is String) {
      return data;
    }

    return null;
  }

  @override
  dynamic toJson(String? data) => data != null ? base64.decode(data) : null;
}
