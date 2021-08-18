import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/crypto/crypto.dart';
import 'package:algorand_dart/src/models/models.dart';

class ContractTemplate {
  final Address address;
  final Uint8List program;

  ContractTemplate({required LogicSignature signature})
      : address = signature.toAddress(),
        program = Uint8List.fromList(signature.logic);

  ContractTemplate.fromProgram(Uint8List program)
      : this(
          signature: LogicSignature(logic: program),
        );

  factory ContractTemplate.inject({
    required Uint8List program,
    required List<ParameterValue> values,
  }) {
    final updatedProgram = <int>[];
    var progIdx = 0;
    for (var value in values) {
      while (progIdx < value.offset) {
        updatedProgram.add(program[progIdx++]);
      }
      for (var b in value.toBytes()) {
        updatedProgram.add(b);
      }
      progIdx += value.placeholderSize();
    }

    // append remainder of program.
    while (progIdx < program.length) {
      updatedProgram.add(program[progIdx++]);
    }

    return ContractTemplate.fromProgram(Uint8List.fromList(updatedProgram));
  }

  static ProgramData readAndVerifyContract({
    required Uint8List program,
    required int numInts,
    required int numByteArrays,
  }) {
    final data = Logic.readProgram(program: program, arguments: []);

    if (!data.good ||
        data.intBlock.length != numInts ||
        data.byteBlock.length != numByteArrays) {
      throw AlgorandException(message: 'Invalid contract detected');
    }
    return data;
  }

  static String createRandomLease() {
    var random = Random.secure();
    return base64Encode(List<int>.generate(32, (i) => random.nextInt(256)));
  }
}

abstract class ParameterValue {
  final int offset;
  final Uint8List _value;

  ParameterValue(this.offset, Uint8List value)
      : _value = Uint8List.fromList(value);

  Uint8List toBytes() => _value;

  int placeholderSize();
}

class IntParameterValue extends ParameterValue {
  IntParameterValue(int offset, int value)
      : super(offset, Logic.putUVarint(value));

  @override
  int placeholderSize() => 1;
}

class AddressParameterValue extends ParameterValue {
  AddressParameterValue(int offset, Address address)
      : super(offset, address.toBytes());

  @override
  int placeholderSize() => 32;
}

class BytesParameterValue extends ParameterValue {
  BytesParameterValue(int offset, Uint8List value)
      : super(offset, convertToBytes(value));

  factory BytesParameterValue.decodeBase64(int offset, String source) {
    final buffer = base64Decode(source);
    return BytesParameterValue(offset, buffer);
  }

  static Uint8List convertToBytes(Uint8List value) {
    final len = Logic.putUVarint(value.length);
    return Uint8List.fromList([...len, ...value]);
  }

  @override
  int placeholderSize() => 2;
}
