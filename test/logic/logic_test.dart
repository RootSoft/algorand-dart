import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('test parse uvar int1', () async {
    final data = Uint8List.fromList([0x01]);
    final result = Logic.getUVarint(data, 0);
    expect(result.length, equals(1));
    expect(result.value, equals(1));
  });

  test('test parse uvar int2', () async {
    final data = Uint8List.fromList([0x02]);
    final result = Logic.getUVarint(data, 0);
    expect(result.length, equals(1));
    expect(result.value, equals(2));
  });

  test('test parse uvar int 3', () async {
    final data = Uint8List.fromList([0x7b]);
    final result = Logic.getUVarint(data, 0);
    expect(result.length, equals(1));
    expect(result.value, equals(123));
  });

  test('test parse uvar int 4', () async {
    final data = Uint8List.fromList([0xc8, 0x03]);
    final result = Logic.getUVarint(data, 0);
    expect(result.length, equals(2));
    expect(result.value, equals(456));
  });

  test('test parse uvar int 4 offset', () async {
    final data = Uint8List.fromList([0x0, 0x0, 0xc8, 0x03]);
    final result = Logic.getUVarint(data, 2);
    expect(result.length, equals(2));
    expect(result.value, equals(456));
  });

  test('test parse intc block', () async {
    final data =
        Uint8List.fromList([0x20, 0x05, 0x00, 0x01, 0xc8, 0x03, 0x7b, 0x02]);
    final result = Logic.readIntConstBlock(data, 0);
    expect(result.size, equals(data.length));
    expect(result.results, equals([0, 1, 456, 123, 2]));
  });

  test('test parse bytec block', () async {
    final data =
        Uint8List.fromList(base64Decode('JgINMTIzNDU2Nzg5MDEyMwIBAg=='));

    final values = List.of([
      Uint8List.fromList(base64Decode('MTIzNDU2Nzg5MDEyMw==')),
      Uint8List.fromList([0x1, 0x2]),
    ], growable: false);
    final results = Logic.readByteConstBlock(data, 0);
    expect(results.size, equals(data.length));
    expect(results.results, equals(values));
  });

  test('test parse push int op', () async {
    final data = Uint8List.fromList([0x81, 0x80, 0x80, 0x04]);

    final results = Logic.readPushIntOp(data, 0);
    expect(results.size, equals(data.length));
    expect(results.results, equals([65536]));
  });

  test('test parse push bytes op', () async {
    final data = Uint8List.fromList(base64Decode('gAtoZWxsbyB3b3JsZA=='));
    final chars = ['h', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd']
        .map((char) => char.codeUnitAt(0))
        .toList();

    final values = List.of([Uint8List.fromList(chars)], growable: false);
    final results = Logic.readPushByteOp(data, 0);
    expect(results.size, equals(data.length));
    expect(results.results, equals(values));
  });

  test('test check program valid', () async {
    final program = Uint8List.fromList([0x01, 0x20, 0x01, 0x01, 0x22]);
    var programData = Logic.readProgram(program: program, arguments: []);
    expect(programData.good, isTrue);
    expect(programData.intBlock, [1]);
    expect(programData.byteBlock, isEmpty);

    // With arguments
    final arguments = <Uint8List>[];
    final arg = fillBytes(0x31, 10);
    arguments.add(arg);

    programData = Logic.readProgram(program: program, arguments: arguments);
    expect(programData.good, isTrue);
    expect(programData.intBlock, [1]);
    expect(programData.byteBlock, isEmpty);
  });

  test('test check program args too long', () async {
    final program = Uint8List.fromList([0x01, 0x20, 0x01, 0x01, 0x22]);
    final arguments = <Uint8List>[];
    final arg = fillBytes(0x31, 1000);
    arguments.add(arg);

    expect(
      () async => Logic.readProgram(program: program, arguments: arguments),
      throwsA((e) => e is AlgorandException && e.message == 'program too long'),
    );
  });

  test('test check program too long', () async {
    final program = Uint8List.fromList(
      [
        ...[0x01, 0x20, 0x01, 0x01, 0x22],
        ...fillBytes(0, 1000),
      ],
    );

    expect(
      () async => Logic.checkProgram(program: program, arguments: []),
      throwsA((e) => e is AlgorandException && e.message == 'program too long'),
    );
  });

  test('test check program invalid opcode', () async {
    final program = Uint8List.fromList([0x01, 0x20, 0x01, 0x01, 0xFF]);
    expect(
      () async => Logic.checkProgram(program: program, arguments: []),
      throwsA((e) =>
          e is AlgorandException && e.message == 'invalid instruction: 255'),
    );
  });

  test('test check program cost', () async {
    final oldVersions = [0x1, 0x2, 0x3];
    final versions = [0x4];
    final program =
        Uint8List.fromList([0x01, 0x26, 0x01, 0x01, 0x01, 0x28, 0x02]);
    final args = [
      Uint8List.fromList(utf8.encode('aaaaaaaaaa')),
    ];

    var programData = Logic.readProgram(program: program, arguments: args);
    expect(programData.good, isTrue);

    final keccakx800 = fillBytes(0x02, 800);
    final program2 = Uint8List.fromList([...program, ...keccakx800]);
    for (var v in oldVersions) {
      program2[0] = v;
      expect(
        () async => Logic.readProgram(program: program2, arguments: args),
        throwsA(
          (e) =>
              e is AlgorandException &&
              e.message ==
                  'program too costly for Teal version < 4. consider using v4.',
        ),
      );
    }

    for (var v in versions) {
      program2[0] = v;
      programData = Logic.readProgram(program: program2, arguments: args);
      expect(programData.good, isTrue);
    }
  });

  test('test check program TEAL V2', () async {
    expect(Logic.evalMaxVersion, greaterThanOrEqualTo(2));
    expect(Logic.logicSigVersion, greaterThanOrEqualTo(2));

    // int 0; balance
    var program = Uint8List.fromList([0x02, 0x20, 0x01, 0x00, 0x22, 0x60]);
    var valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // int 0; int 0; app_opted_in
    program = Uint8List.fromList([0x02, 0x20, 0x01, 0x00, 0x22, 0x22, 0x61]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // int 0; int 0; asset_holding_get Balance
    program = Uint8List.fromList([0x02, 0x20, 0x01, 0x00, 0x22, 0x70, 0x00]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);
  });

  test('test check program TEAL V3', () async {
    expect(Logic.evalMaxVersion, greaterThanOrEqualTo(3));
    expect(Logic.logicSigVersion, greaterThanOrEqualTo(3));

    // min_balance
    var program = Uint8List.fromList([0x03, 0x20, 0x01, 0x00, 0x22, 0x78]);
    var valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // int 0; pushbytes "hi"; pop
    program = Uint8List.fromList(
        [0x03, 0x20, 0x01, 0x00, 0x22, 0x80, 0x02, 0x68, 0x69, 0x48]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // int 0; pushint 1; pop
    program =
        Uint8List.fromList([0x03, 0x20, 0x01, 0x00, 0x22, 0x81, 0x01, 0x48]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // int 0; int 1; swap; pop
    program = Uint8List.fromList(
        [0x03, 0x20, 0x02, 0x00, 0x01, 0x22, 0x23, 0x4c, 0x48]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);
  });

  test('test check program TEAL V4', () async {
    expect(Logic.evalMaxVersion, greaterThanOrEqualTo(4));

    // divmodw
    var program = Uint8List.fromList([
      0x04,
      0x20,
      0x03,
      0x01,
      0x00,
      0x02,
      0x22,
      0x81,
      0xd0,
      0x0f,
      0x23,
      0x24,
      0x1f
    ]);

    var valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // gloads i
    program = Uint8List.fromList([0x04, 0x20, 0x01, 0x00, 0x22, 0x3b, 0x00]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // callsub
    program = Uint8List.fromList([
      0x04,
      0x20,
      0x02,
      0x01,
      0x02,
      0x22,
      0x88,
      0x00,
      0x02,
      0x23,
      0x12,
      0x49
    ]);

    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // b>=
    program = Uint8List.fromList(
        [0x04, 0x26, 0x02, 0x01, 0x11, 0x01, 0x10, 0x28, 0x29, 0xa7]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // b^
    program = Uint8List.fromList(
        [0x04, 0x26, 0x02, 0x01, 0x11, 0x01, 0x10, 0x28, 0x29, 0xa7]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // callsub, retsub.
    program = Uint8List.fromList([
      0x04,
      0x20,
      0x02,
      0x01,
      0x02,
      0x22,
      0x88,
      0x00,
      0x03,
      0x23,
      0x12,
      0x43,
      0x49,
      0x08,
      0x89
    ]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // loop
    program = Uint8List.fromList([
      0x04,
      0x20,
      0x04,
      0x01,
      0x02,
      0x0a,
      0x10,
      0x22,
      0x23,
      0x0b,
      0x49,
      0x24,
      0x0c,
      0x40,
      0xff,
      0xf8,
      0x25,
      0x12
    ]);
    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);
  });

  test('test check program TEAL V5', () async {
    expect(Logic.evalMaxVersion, greaterThanOrEqualTo(5));

    // itxn ops
    var program = Uint8List.fromList([
      // ignore: lines_longer_than_80_chars
      0x05, 0x20, 0x01, 0xc0, 0x84, 0x3d, 0xb1, 0x81, 0x01, 0xb2, 0x10, 0x22,
      0xb2, 0x08, 0x31, 0x00, 0xb2, 0x07, 0xb3, 0xb4, 0x08, 0x22, 0x12
    ]);

    var valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // ECDSA ops
    program = Uint8List.fromList([
      // ignore: lines_longer_than_80_chars
      0x05, 0x80, 0x08, 0x74, 0x65, 0x73, 0x74, 0x64, 0x61, 0x74, 0x61, 0x03,
      0x80, 0x20, 0x79, 0xbf, 0xa8, 0x24, 0x5a, 0xea, 0xc0, 0xe7, 0x14, 0xb7,
      0xbd, 0x2b,
      0x32, 0x52,
      0xd0, 0x39, 0x79, 0xe5, 0xe7, 0xa4, 0x3c, 0xb0, 0x39, 0x71, 0x5a, 0x5f,
      0x81, 0x09,
      0xa7, 0xdd, 0x9b, 0xa1, 0x80, 0x20, 0x07, 0x53, 0xd3, 0x17, 0xe5, 0x43,
      0x50, 0xd1,
      0xd1, 0x02, 0x28, 0x9a, 0xfb, 0xde, 0x30, 0x02, 0xad, 0xd4, 0x52, 0x9f,
      0x10, 0xb9,
      0xf7, 0xd3, 0xd2, 0x23, 0x84, 0x39, 0x85, 0xde, 0x62, 0xe0, 0x80, 0x21,
      0x03, 0xab,
      0xfb, 0x5e, 0x6e, 0x33, 0x1f, 0xb8, 0x71, 0xe4, 0x23, 0xf3, 0x54, 0xe2,
      0xbd, 0x78,
      0xa3, 0x84, 0xef, 0x7c, 0xb0, 0x7a, 0xc8, 0xbb, 0xf2, 0x7d, 0x2d, 0xd1,
      0xec, 0xa0,
      0x0e, 0x73, 0xc1, 0x06, 0x00, 0x05, 0x00
    ]);

    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // cover, uncover, log
    program = Uint8List.fromList([
      // ignore: lines_longer_than_80_chars
      0x05, 0x80, 0x01, 0x61, 0x80, 0x01, 0x62, 0x80, 0x01, 0x63, 0x4e, 0x02,
      0x4f, 0x02, 0x50, 0x50, 0xb0, 0x81, 0x01
    ]);

    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);
  });

  test('test check program TEAL V6', () async {
    expect(Logic.evalMaxVersion, greaterThanOrEqualTo(6));

    // bsqrt
    // byte 0x90; bsqrt; byte 0x0c; b==
    var program = Uint8List.fromList(
        [0x06, 0x80, 0x01, 0x90, 0x96, 0x80, 0x01, 0x0c, 0xa8]);

    var valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // divw
    // int 9; int 18446744073709551596; int 10; divw; int 18446744073709551614; ==
    program = Uint8List.fromList([
      0x06,
      0x81,
      0x09,
      0x81,
      0xec,
      0xff,
      0xff,
      0xff,
      0xff,
      0xff,
      0xff,
      0xff,
      0xff,
      0x01,
      0x81,
      0x0a,
      0x97,
      0x81,
      0xfe,
      0xff,
      0xff,
      0xff,
      0xff,
      0xff,
      0xff,
      0xff,
      0xff,
      0x01,
      0x12
    ]);

    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);

    // txn fields
    // txn StateProofPK; len; int 64; ==; gtxn 0 LastLog; len; int 10; ==; &&
    program = Uint8List.fromList([
      0x06,
      0x31,
      0x3f,
      0x15,
      0x81,
      0x40,
      0x12,
      0x33,
      0x00,
      0x3e,
      0x15,
      0x81,
      0x0a,
      0x12,
      0x10
    ]);

    valid = Logic.checkProgram(program: program, arguments: []);
    expect(valid, isTrue);
  });
}
