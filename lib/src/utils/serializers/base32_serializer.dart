import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:json_annotation/json_annotation.dart';

class Base32Serializer implements JsonConverter<Uint8List?, String?> {
  const Base32Serializer();

  @override
  Uint8List? fromJson(String? json) =>
      json != null ? base32.decode(json) : null;

  @override
  String? toJson(Uint8List? data) => data != null ? base32.encode(data) : null;
}
