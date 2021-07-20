import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

//part 'teal_program_model.g.dart';

//@JsonSerializable(fieldRename: FieldRename.kebab)
class TEALProgram {
  @JsonKey(name: 'program')
  final Uint8List _program;

  TEALProgram({
    required Uint8List program,
  }) : _program = Uint8List.fromList(program);

  /// Create a new TEAL program from given source code.
  TEALProgram.fromSource({required String source})
      : this(program: Uint8List.fromList(utf8.encode(source)));

  Uint8List get program => _program;

  // factory TEALProgram.fromJson(Map<String, dynamic> json) =>
  //     _$TEALProgramFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$TEALProgramToJson(this);
}
