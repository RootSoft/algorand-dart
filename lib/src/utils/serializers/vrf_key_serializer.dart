import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

class VRFKeySerializer implements JsonConverter<VRFPublicKey?, dynamic> {
  const VRFKeySerializer();

  @override
  VRFPublicKey? fromJson(dynamic data) {
    if (data == null) return null;

    if (data is Uint8List) {
      return VRFPublicKey(bytes: data);
    }

    if (data is String) {
      return VRFPublicKey(bytes: base64Decode(data));
    }

    return null;
  }

  @override
  String? toJson(VRFPublicKey? data) =>
      data != null ? base64.encode(data.bytes) : null;
}
