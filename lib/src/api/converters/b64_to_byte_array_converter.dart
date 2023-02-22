import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class B64ToByteArrayConverter implements JsonConverter<Uint8List, dynamic> {
  const B64ToByteArrayConverter();

  @override
  Uint8List fromJson(dynamic data) {
    if (data is Uint8List) {
      return data;
    }

    if (data is String) {
      return base64Decode(data);
    }

    return Uint8List.fromList([]);
  }

  @override
  dynamic toJson(Uint8List data) => base64Encode(data);
}
