import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class ByteArraySerializer implements JsonConverter<Uint8List, String> {
  const ByteArraySerializer();

  @override
  Uint8List fromJson(String json) => base64.decode(json);

  @override
  String toJson(Uint8List data) => base64.encode(data);
}
