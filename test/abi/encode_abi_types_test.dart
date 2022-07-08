import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/abi/types/type_address.dart';
import 'package:algorand_dart/src/abi/types/type_bool.dart';
import 'package:algorand_dart/src/abi/types/type_ufixed.dart';
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

  test('Test encode Ufixed into bytes', () async {
    expect(TypeUfixed(8, 30).encode(BigInt.from(255)), equals([255]));
    expect(TypeUfixed(32, 10).encode(BigInt.from(33)), equals([0, 0, 0, 33]));
  });

  test('Test encode bool into bytes', () async {
    expect(TypeBool().encode(true), equals([128]));
    expect(TypeBool().encode(false), equals([0]));
  });

  test('Test decode bytes into bool', () async {
    expect(TypeBool().decode(Uint8List.fromList([128])), equals(true));
    expect(TypeBool().decode(Uint8List.fromList([0])), equals(false));
  });

  test('Test encode address into bytes', () async {
    final x = 'MO2H6ZU47Q36GJ6GVHUKGEBEQINN7ZWVACMWZQGIYUOE3RBSRVYHV4ACJI';
    final address = Address.fromAlgorandAddress(address: x);
    expect(TypeAddress().encode(x), equals(address.publicKey));
    expect(TypeAddress().encode(address), equals(address.publicKey));
    expect(TypeAddress().encode(address.publicKey), equals(address.publicKey));
  });

  test('Test decode byte into address', () async {
    final x = 'MO2H6ZU47Q36GJ6GVHUKGEBEQINN7ZWVACMWZQGIYUOE3RBSRVYHV4ACJI';
    final address = Address.fromAlgorandAddress(address: x);
    expect(TypeAddress().decode(address.publicKey), equals(address));
  });
}
