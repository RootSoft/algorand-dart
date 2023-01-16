import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class NullableByteArraySerializer
    implements JsonConverter<Uint8List?, dynamic> {
  const NullableByteArraySerializer();

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

class ByteArraySerializer implements JsonConverter<Uint8List, dynamic> {
  const ByteArraySerializer();

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
  dynamic toJson(Uint8List? data) => data != null ? base64.encode(data) : null;
}

class ListByteArraySerializer
    implements JsonConverter<List<Uint8List>?, dynamic> {
  const ListByteArraySerializer();

  @override
  List<Uint8List>? fromJson(dynamic data) {
    if (data is List) {
      return data.whereType<Uint8List>().toList();
    }

    return null;
  }

  @override
  dynamic toJson(List<Uint8List>? data) {
    if (data == null) {
      return null;
    }
    return data.map((e) => base64.encode(e)).toList();
  }
}
