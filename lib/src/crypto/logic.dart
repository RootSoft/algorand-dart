import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logic.g.dart';

class Logic {
  static const MAX_COST = 20000;
  static const MAX_LENGTH = 1000;

  static const INTCBLOCK_OPCODE = 32;
  static const BYTECBLOCK_OPCODE = 38;
  static const PUSHBYTES_OPCODE = 128;
  static const PUSHINT_OPCODE = 129;

  static LangSpec? langSpec;

  /// Perform basic program validation; instruction count and program cost
  static bool checkProgram({
    required Uint8List program,
    required List<Uint8List>? arguments,
  }) {
    return readProgram(program: program, arguments: arguments ?? []).good;
  }

  /// Performs basic program validation: instruction count and program cost
  static ProgramData readProgram({
    required Uint8List program,
    required List<Uint8List> arguments,
  }) {
    final ints = <int>[];
    final bytes = <Uint8List>[];
    if (langSpec == null) {
      loadLangSpec();
    }

    final result = getUVarint(program, 0);
    var vlen = result.length;
    var version = result.value;
    if (vlen <= 0) {
      throw AlgorandException(message: 'Version parsing error');
    }

    if (version > langSpec!.evalMaxVersion) {
      throw AlgorandException(message: 'Unsupported version');
    }

    var cost = 0;
    var length = program.length;
    for (var i = 0; i < arguments.length; i++) {
      length += arguments[i].length;
    }

    if (length > MAX_LENGTH) {
      throw AlgorandException(message: 'program too long');
    }

    final opcodes = List<Operation?>.filled(256, null);
    for (var i = 0; i < langSpec!.operations.length; i++) {
      var op = langSpec!.operations[i];
      opcodes[op.opCode] = op;
    }

    var pc = vlen;
    while (pc < program.length) {
      var opcode = program[pc];
      var op = opcodes[opcode];
      if (op == null) {
        throw AlgorandException(message: 'invalid instruction: $opcode');
      }

      cost += op.cost;
      var size = op.size;
      if (size == 0) {
        switch (op.opCode) {
          case INTCBLOCK_OPCODE:
            final intsBlock = readIntConstBlock(program, pc);
            size += intsBlock.size;
            ints.addAll(intsBlock.results);
            break;
          case BYTECBLOCK_OPCODE:
            final bytesBlock = readByteConstBlock(program, pc);
            size += bytesBlock.size;
            bytes.addAll(bytesBlock.results);
            break;
          case PUSHINT_OPCODE:
            final pushInt = readPushIntOp(program, pc);
            size += pushInt.size;
            ints.addAll(pushInt.results);
            break;
          case PUSHBYTES_OPCODE:
            final pushBytes = readPushByteOp(program, pc);
            size += pushBytes.size;
            bytes.addAll(pushBytes.results);
            break;
          default:
            throw AlgorandException(message: 'invalid instruction');
        }
      }

      pc += size;
    }

    // costs calculated dynamically starting in v4
    if (version < 4 && cost > MAX_COST) {
      throw AlgorandException(
        message: 'program too costly for Teal version < 4. consider using v4.',
      );
    }

    return ProgramData(good: true, intBlock: ints, byteBlock: bytes);
  }

  static void loadLangSpec() {
    if (langSpec != null) {
      return;
    }

    // Clean up the JSON
    final json = LANG_SPEC.replaceAll('\n', '\\n');

    final data = jsonDecode(json) as Map<String, dynamic>;
    langSpec = LangSpec.fromJson(data);
  }

  /// Retrieves max supported version of TEAL evaluator
  static int get evalMaxVersion {
    if (langSpec == null) {
      loadLangSpec();
    }

    return langSpec?.evalMaxVersion ?? 0;
  }

  /// Retrieves TEAL supported version
  static int get logicSigVersion {
    if (langSpec == null) {
      loadLangSpec();
    }

    return langSpec?.logicSigVersion ?? 0;
  }

  /// Given a varint, get the integer value
  static VarintResult getUVarint(Uint8List buffer, int bufferOffset) {
    var x = 0;
    var s = 0;

    for (var i = 0; i < buffer.length; i++) {
      var b = buffer[bufferOffset + i];
      if (b < 0x80) {
        if (i > 9 || i == 9 && b > 1) {
          return VarintResult(0, -(i + 1));
        }
        return VarintResult(x | (b & 0xff) << s, i + 1);
      }
      x |= ((b & 0x7f) & 0xff) << s;
      s += 7;
    }
    return VarintResult();
  }

  /// Varints are a method of serializing integers using one or more bytes.
  /// Smaller numbers take a smaller number of bytes.
  /// Each byte in a varint, except the last byte, has the most significant
  /// bit (msb) set – this indicates that there are further bytes to come.
  /// The lower 7 bits of each byte are used to store the two's complement
  /// representation of the number in groups of 7 bits, least significant
  /// group first.
  /// https://developers.google.com/protocol-buffers/docs/encoding
  ///
  /// value is the value being serialized
  /// Returns the byte array holding the serialized bits
  static Uint8List putUVarint(int value) {
    final buffer = <int>[];
    while (value >= 0x80) {
      buffer.add(((value & 0xFF) | 0x80));
      value >>= 7;
    }
    buffer.add(value & 0xFF);
    return Uint8List.fromList(buffer);
  }

  static IntConstBlock readIntConstBlock(Uint8List program, int pc) {
    final results = <int>[];
    var size = 1;
    var result = getUVarint(program, pc + size);
    if (result.length <= 0) {
      throw AlgorandException(
        message: 'could not decode int const block at pc=$pc',
      );
    }

    size += result.length;
    var numInts = result.value;
    for (var i = 0; i < numInts; i++) {
      if (pc + size >= program.length) {
        throw AlgorandException(
          message: 'int const block exceeds program length',
        );
      }
      result = getUVarint(program, pc + size);
      if (result.length <= 0) {
        throw AlgorandException(
          message: 'could not decode int const[$i] block at pc=${pc + size}',
        );
      }
      size += result.length;
      results.add(result.value);
    }

    return IntConstBlock(size, results);
  }

  static ByteConstBlock readByteConstBlock(Uint8List program, int pc) {
    final results = <Uint8List>[];
    var size = 1;
    var result = getUVarint(program, pc + size);
    if (result.length <= 0) {
      throw AlgorandException(
        message: 'could not decode byte[] const block at pc=$pc',
      );
    }

    size += result.length;
    var numInts = result.value;
    for (var i = 0; i < numInts; i++) {
      if (pc + size >= program.length) {
        throw AlgorandException(
          message: 'byte[] const block exceeds program length',
        );
      }
      result = getUVarint(program, pc + size);
      if (result.length <= 0) {
        throw AlgorandException(
          message: 'could not decode int const[$i] block at pc=${pc + size}',
        );
      }
      size += result.length;
      if (pc + size + result.value > program.length) {
        throw AlgorandException(
          message: '"byte[] const block exceeds program length',
        );
      }

      final buffer = List.filled(result.value, 0);
      buffer.setRange(0, result.value, program, pc + size);
      results.add(Uint8List.fromList(buffer));
      size += result.value;
    }

    return ByteConstBlock(size, results);
  }

  static IntConstBlock readPushIntOp(Uint8List program, int pc) {
    var size = 1;
    var result = getUVarint(program, pc + size);
    if (result.length <= 0) {
      throw AlgorandException(
        message: 'could not decode push int const at pc=$pc',
      );
    }

    size += result.length;

    return IntConstBlock(size, [result.value]);
  }

  static ByteConstBlock readPushByteOp(Uint8List program, int pc) {
    var size = 1;
    var result = getUVarint(program, pc + size);
    if (result.length <= 0) {
      throw AlgorandException(
        message: 'could not decode push byte const at pc=$pc',
      );
    }

    size += result.length;
    if (pc + size + result.value > program.length) {
      throw AlgorandException(
        message: '"byte[] const block exceeds program length',
      );
    }

    final buffer = List.filled(result.value, 0);
    buffer.setRange(0, result.value, program, pc + size);
    size += result.value;

    return ByteConstBlock(size, [Uint8List.fromList(buffer)]);
  }
}

@JsonSerializable()
class LangSpec {
  @JsonKey(name: 'EvalMaxVersion', defaultValue: 0)
  final int evalMaxVersion;

  @JsonKey(name: 'LogicSigVersion', defaultValue: 0)
  final int logicSigVersion;

  @JsonKey(name: 'Ops', defaultValue: [])
  final List<Operation> operations;

  LangSpec({
    required this.evalMaxVersion,
    required this.logicSigVersion,
    required this.operations,
  });

  factory LangSpec.fromJson(Map<String, dynamic> json) =>
      _$LangSpecFromJson(json);

  Map<String, dynamic> toJson() => _$LangSpecToJson(this);
}

@JsonSerializable()
class Operation {
  @JsonKey(name: 'Opcode')
  final int opCode;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Cost')
  final int cost;

  @JsonKey(name: 'Size')
  final int size;

  @JsonKey(name: 'Returns')
  final String? returns;

  @JsonKey(name: 'ArgEnum', defaultValue: [])
  final List<String> argEnum;

  @JsonKey(name: 'ArgEnumTypes')
  final String? argEnumTypes;

  @JsonKey(name: 'Doc')
  final String? doc;

  @JsonKey(name: 'ImmediateNote')
  final String? immediateNote;

  @JsonKey(name: 'Group', defaultValue: [])
  final List<String> group;

  Operation({
    required this.opCode,
    required this.name,
    required this.cost,
    required this.size,
    required this.returns,
    required this.argEnum,
    required this.argEnumTypes,
    required this.doc,
    required this.immediateNote,
    required this.group,
  });

  factory Operation.fromJson(Map<String, dynamic> json) =>
      _$OperationFromJson(json);

  Map<String, dynamic> toJson() => _$OperationToJson(this);
}

class ProgramData {
  final bool good;
  final List<int> intBlock;
  final List<Uint8List> byteBlock;

  ProgramData({
    required this.good,
    required this.intBlock,
    required this.byteBlock,
  });
}

class VarintResult {
  final int value;
  final int length;

  VarintResult([this.value = 0, this.length = 0]);
}

class IntConstBlock {
  final int size;
  final List<int> results;

  IntConstBlock(this.size, this.results);
}

class ByteConstBlock {
  final int size;
  final List<Uint8List> results;

  ByteConstBlock(this.size, this.results);
}
