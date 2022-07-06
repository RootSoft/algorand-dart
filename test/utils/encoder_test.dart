import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('Test encode Uint64 BigInt', () async {
    final inputs = [
      BigInt.from(0),
      BigInt.from(1),
      BigInt.from(500),
      BigIntEncoder.MAX_UINT64 - BigInt.from(1),
      BigIntEncoder.MAX_UINT64,
    ];

    final expectedItems = [
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 1]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 0xf4]),
      Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe]),
      Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
    ];

    for (var i = 0; i < inputs.length; i++) {
      final input = inputs[i];
      final expected = expectedItems[i];

      final actual = BigIntEncoder.encodeUint64(input);
      expect(actual, equals(expected));
    }

    final invalidInputs = [
      BigInt.from(-1),
      BigIntEncoder.MAX_UINT64 + BigInt.from(1),
    ];

    for (var i = 0; i < invalidInputs.length; i++) {
      final input = invalidInputs[i];
      expect(
        () => BigIntEncoder.encodeUint64(input),
        throwsA((e) => e is ArgumentError),
      );
    }
  });

  test('Test encode Uint64 int (long)', () async {
    final inputs = <int>[
      0,
      1,
      500,
      (BigInt.from(0x7fffffffffffffff) - BigInt.from(1)).toInt(),
      BigInt.from(0x7fffffffffffffff).toInt(),
    ];

    final expectedItems = [
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 1]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 0xf4]),
      Uint8List.fromList([0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe]),
      Uint8List.fromList([0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
    ];

    for (var i = 0; i < inputs.length; i++) {
      final input = inputs[i];
      final expected = expectedItems[i];

      final actual = BigIntEncoder.encodeUintToBytes(BigInt.from(input), 8);
      expect(actual, equals(expected));
    }

    final invalidInputs = <int>[
      -1,
      BigInt.from(0x8000000000000000).toInt(),
    ];

    for (var i = 0; i < invalidInputs.length; i++) {
      final input = invalidInputs[i];
      expect(
        () => BigIntEncoder.encodeUintToBytes(BigInt.from(input), 8),
        throwsA((e) => e is ArgumentError),
      );
    }
  });

  test('Test decode Uint64', () async {
    final inputs = [
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 1]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 0xf4]),
      Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe]),
      Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
    ];

    final expectedItems = [
      BigInt.from(0),
      BigInt.from(1),
      BigInt.from(500),
      BigIntEncoder.MAX_UINT64 - BigInt.from(1),
      BigIntEncoder.MAX_UINT64,
    ];

    for (var i = 0; i < inputs.length; i++) {
      final input = inputs[i];
      final expected = expectedItems[i];

      final actual = BigIntEncoder.decodeUint64(input);
      expect(actual, equals(expected));
    }

    final invalidInputs = [
      Uint8List.fromList([]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0, 0]),
    ];

    for (var i = 0; i < invalidInputs.length; i++) {
      final input = invalidInputs[i];
      expect(
        () => BigIntEncoder.decodeUint64(input),
        throwsA((e) => e is ArgumentError),
      );
    }
  });

  test('Test decode Uint64 ', () async {
    final inputs = [
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 1]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 0xf4]),
      Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe]),
      Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]),
    ];

    final expectedItems = [
      BigInt.from(0),
      BigInt.from(1),
      BigInt.from(500),
      BigIntEncoder.MAX_UINT64 - BigInt.from(1),
      BigIntEncoder.MAX_UINT64,
    ];

    for (var i = 0; i < inputs.length; i++) {
      final input = inputs[i];
      final expected = expectedItems[i];

      final actual = BigIntEncoder.decodeUint64(input);
      expect(actual, equals(expected));
    }

    final invalidInputs = [
      Uint8List.fromList([]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0]),
      Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0, 0]),
    ];

    for (var i = 0; i < invalidInputs.length; i++) {
      final input = invalidInputs[i];
      expect(
        () => BigIntEncoder.decodeUint64(input),
        throwsA((e) => e is ArgumentError),
      );
    }
  });
}
