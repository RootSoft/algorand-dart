import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/api/application/application.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teal_compilation_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class TealCompilation {
  /// base32 SHA512_256 of program bytes (Address style)
  @JsonKey(name: 'hash')
  final String hash;

  /// base64 encoded program bytes
  @JsonKey(name: 'result')
  final String result;

  TealCompilation({
    required this.hash,
    required this.result,
  });

  /// Get the base64 decoded program bytes.
  Uint8List get bytes => base64Decode(result);

  /// Get the compiled teal program.
  TEALProgram get program => TEALProgram(program: bytes);

  factory TealCompilation.fromJson(Map<String, dynamic> json) =>
      _$TealCompilationFromJson(json);

  Map<String, dynamic> toJson() => _$TealCompilationToJson(this);
}
