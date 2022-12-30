import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
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

  test('Test encode byte type into bytes', () async {
    expect(TypeByte().encode(10), equals([10]));
    expect(TypeByte().encode(255), equals([255]));
    expect(TypeByte().encode(BigInt.from(10)), equals([10]));
  });

  test('Test decode byte type into bytes', () async {
    expect(TypeByte().decode(Uint8List.fromList([10])), equals(10));
    expect(TypeByte().decode(Uint8List.fromList([255])), equals(255));
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
    final address = Address.fromAlgorandAddress(x);
    expect(TypeAddress().encode(x), equals(address.publicKey));
    expect(TypeAddress().encode(address), equals(address.publicKey));
    expect(TypeAddress().encode(address.publicKey), equals(address.publicKey));
  });

  test('Test decode byte into address', () async {
    final x = 'MO2H6ZU47Q36GJ6GVHUKGEBEQINN7ZWVACMWZQGIYUOE3RBSRVYHV4ACJI';
    final address = Address.fromAlgorandAddress(x);
    expect(TypeAddress().decode(address.publicKey), equals(address));
  });

  test('Test encode string into bytes', () async {
    expect(TypeString().encode('asdf'),
        equals(Uint8List.fromList([0, 4, 97, 115, 100, 102])));
  });

  test('Test decode bytes into string', () async {
    expect(TypeString().decode(Uint8List.fromList([0, 4, 97, 115, 100, 102])),
        equals('asdf'));
  });

  test('Test encode array static type into bytes', () async {
    expect(TypeArrayStatic(TypeBool(), 3).encode([true, true, false]),
        equals(Uint8List.fromList([192])));
    expect(
        TypeArrayStatic(TypeBool(), 8)
            .encode([false, true, false, false, false, false, false, false]),
        equals(Uint8List.fromList([64])));
    expect(
        TypeArrayStatic(TypeBool(), 8)
            .encode([true, true, true, true, true, true, true, true]),
        equals(Uint8List.fromList([255])));
    expect(
        TypeArrayStatic(TypeBool(), 9).encode(
            [true, false, false, true, false, false, true, false, true]),
        equals(Uint8List.fromList([146, 128])));

    expect(
        TypeArrayStatic(TypeUint(64), 2)
            .encode([BigInt.from(1), BigInt.from(2)]),
        equals(Uint8List.fromList(
            [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2])));
  });

  test('Test decode bytes into array static type', () async {
    expect(TypeArrayStatic(TypeBool(), 3).decode(Uint8List.fromList([192])),
        equals([true, true, false]));
    expect(TypeArrayStatic(TypeBool(), 8).decode(Uint8List.fromList([64])),
        equals([false, true, false, false, false, false, false, false]));
    expect(TypeArrayStatic(TypeBool(), 8).decode(Uint8List.fromList([255])),
        equals([true, true, true, true, true, true, true, true]));
    expect(
        TypeArrayStatic(TypeBool(), 9).decode(Uint8List.fromList([146, 128])),
        equals([true, false, false, true, false, false, true, false, true]));

    expect(
        TypeArrayStatic(TypeUint(64), 2).decode(Uint8List.fromList(
            [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2])),
        equals([BigInt.from(1), BigInt.from(2)]));
  });

  test('Test encode array dynamic type into bytes', () async {
    expect(TypeArrayDynamic(TypeBool()).encode([]),
        equals(Uint8List.fromList([0, 0])));
    expect(TypeArrayDynamic(TypeBool()).encode([true, true, false]),
        equals(Uint8List.fromList([0, 3, 192])));
    expect(
        TypeArrayDynamic(TypeBool())
            .encode([false, true, false, false, false, false, false, false]),
        equals(Uint8List.fromList([0, 8, 64])));
    expect(
        TypeArrayDynamic(TypeBool()).encode(
            [true, false, false, true, false, false, true, false, true]),
        equals(Uint8List.fromList([0, 9, 146, 128])));
  });

  test('Test decode bytes into array dynamic type', () async {
    expect(TypeArrayDynamic(TypeBool()).decode(Uint8List.fromList([0, 0])),
        equals([]));
    expect(TypeArrayDynamic(TypeBool()).decode(Uint8List.fromList([0, 3, 192])),
        equals([true, true, false]));
    expect(TypeArrayDynamic(TypeBool()).decode(Uint8List.fromList([0, 8, 64])),
        equals([false, true, false, false, false, false, false, false]));
    expect(
        TypeArrayDynamic(TypeBool())
            .decode(Uint8List.fromList([0, 9, 146, 128])),
        equals([true, false, false, true, false, false, true, false, true]));
  });
}
