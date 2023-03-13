import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/crypto/crypto.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

class TEALProgram {
  @JsonKey(name: 'program')
  final Uint8List _program;

  TEALProgram({
    required Uint8List program,
  }) : _program = Uint8List.fromList(program);

  /// Create a new TEAL program from given source code.
  TEALProgram.fromSource({required String source})
      : this(program: Uint8List.fromList(utf8.encode(source)));

  /// Get the program bytes.
  Uint8List get program => _program;

  /// Creates Signature compatible with ed25519verify TEAL opcode from data
  /// and program bytes.
  Future<Signature> sign({
    required Account account,
    required Uint8List data,
  }) async {
    final lsig = LogicSignature(logic: program);
    return lsig.toAddress().sign(account: account, data: data);
  }
}
