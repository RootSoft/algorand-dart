import 'dart:typed_data';

import 'package:algorand_dart/src/abi/types/type_uint.dart';
import 'package:test/test.dart';

/// https://github.com/algorand/js-algorand-sdk/blob/develop/tests/10.ABI.ts
void main() {
  setUp(() async {});

  test('Test encode Uint into bytes', () async {
    expect(TypeUint(8).encode(BigInt.from(0)), equals([0]));
    expect(TypeUint(16).encode(BigInt.from(3)), equals([0, 3]));
    expect(TypeUint(64).encode(BigInt.from(256)),
        equals([0, 0, 0, 0, 0, 0, 1, 0]));

    expect(TypeUint(8).encode(0), equals([0]));
    expect(TypeUint(16).encode('3'), equals([0, 3]));
  });

  test('Test decode bytes into Uint', () async {
    expect(TypeUint(8).decode(Uint8List.fromList([0])), equals(BigInt.from(0)));
    expect(TypeUint(16).decode(Uint8List.fromList([0, 3])),
        equals(BigInt.from(3)));
    expect(TypeUint(64).decode(Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 0])),
        equals(BigInt.from(256)));
  });
}
