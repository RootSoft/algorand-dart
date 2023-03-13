import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

class ParticipationKeySerializer
    implements JsonConverter<ParticipationPublicKey?, dynamic> {
  const ParticipationKeySerializer();

  @override
  ParticipationPublicKey? fromJson(dynamic data) {
    if (data == null) return null;

    if (data is Uint8List) {
      return ParticipationPublicKey(bytes: data);
    }

    if (data is String) {
      return ParticipationPublicKey(bytes: base64Decode(data));
    }

    return null;
  }

  @override
  String? toJson(ParticipationPublicKey? data) =>
      data != null ? base64.encode(data.bytes) : null;
}
