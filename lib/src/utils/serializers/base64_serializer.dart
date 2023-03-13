import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class Base64Serializer implements JsonConverter<Uint8List?, dynamic> {
  const Base64Serializer();

  @override
  Uint8List? fromJson(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Uint8List) {
      return data;
    }

    if (data is String) {
      return base64.decode(data);
    }

    return null;
  }

  @override
  String? toJson(Uint8List? data) => data != null ? base64.encode(data) : null;
}
