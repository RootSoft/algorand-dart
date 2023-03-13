import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/api/api.dart';
import 'package:json_annotation/json_annotation.dart';

class TealProgramConverter implements JsonConverter<TEALProgram?, dynamic> {
  const TealProgramConverter();

  @override
  TEALProgram? fromJson(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is TEALProgram) {
      return data;
    }

    if (data is List<int>) {
      return TEALProgram(program: Uint8List.fromList(data));
    }

    if (data is Uint8List) {
      return TEALProgram(program: Uint8List.fromList(data));
    }

    if (data is String) {
      try {
        return TEALProgram(program: base64Decode(data));
      } catch (ex) {
        return null;
      }
    }

    return null;
  }

  @override
  dynamic toJson(TEALProgram? data) =>
      data != null ? base64.encode(data.program) : null;
}
