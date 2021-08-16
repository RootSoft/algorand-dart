import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('test parse bytec block', () async {
    // ignore: lines_longer_than_80_chars
    final data = Uint8List.fromList([
      0x026,
      0x02,
      0x0d,
      0x31,
      0x32,
      0x33,
      0x34,
      0x35,
      0x36,
      0x37,
      0x38,
      0x39,
      0x30,
      0x31,
      0x32,
      0x33,
      0x02,
      0x01,
      0x02
    ]);

    final values = List.of([
      Uint8List.fromList([
        0x31,
        0x32,
        0x33,
        0x34,
        0x35,
        0x36,
        0x37,
        0x38,
        0x39,
        0x30,
        0x31,
        0x32,
        0x33
      ]),
      Uint8List.fromList([0x1, 0x2]),
    ], growable: false);
    final results = Logic.readByteConstBlock(data, 0);
    expect(results.size, equals(data.length));
    expect(results.results, equals(values));
  });
}
