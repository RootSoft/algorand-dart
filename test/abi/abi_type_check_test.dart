import 'package:algorand_dart/src/abi/abi_type.dart';
import 'package:algorand_dart/src/abi/types/type_address.dart';
import 'package:algorand_dart/src/abi/types/type_array_dynamic.dart';
import 'package:algorand_dart/src/abi/types/type_array_static.dart';
import 'package:algorand_dart/src/abi/types/type_bool.dart';
import 'package:algorand_dart/src/abi/types/type_byte.dart';
import 'package:algorand_dart/src/abi/types/type_string.dart';
import 'package:algorand_dart/src/abi/types/type_tuple.dart';
import 'package:algorand_dart/src/abi/types/type_ufixed.dart';
import 'package:algorand_dart/src/abi/types/type_uint.dart';
import 'package:test/test.dart';

/// https://github.com/algorand/js-algorand-sdk/blob/develop/tests/10.ABI.ts
void main() {
  setUp(() async {});

  test('Deserialize ABI type scheme from string', () async {
    final testcases = [
      ['address', TypeAddress()],
      ['bool', TypeBool()],
      ['byte', TypeByte()],
      ['string', TypeString()],
      ['uint32[]', TypeArrayDynamic(TypeUint(32))],
      ['byte[][]', TypeArrayDynamic(TypeArrayDynamic(TypeByte()))],
      ['ufixed256x64[]', TypeArrayDynamic(TypeUfixed(256, 64))],
      ['ufixed128x10[100]', TypeArrayStatic(TypeUfixed(128, 10), 100)],
      [
        'bool[256][100]',
        TypeArrayStatic(TypeArrayStatic(TypeBool(), 256), 100),
      ],
      ['()', TypeTuple([])],
      [
        '(uint256,(byte,address[10]),(),bool)',
        TypeTuple(
          [
            TypeUint(256),
            TypeTuple(
              [
                TypeByte(),
                TypeArrayStatic(
                  TypeAddress(),
                  10,
                )
              ],
            ),
            TypeTuple([]),
            TypeBool(),
          ],
        ),
      ],
      [
        '(ufixed256x16,((string),bool,(address,uint8)))',
        TypeTuple(
          [
            TypeUfixed(256, 16),
            TypeTuple(
              [
                TypeTuple([TypeString()]),
                TypeBool(),
                TypeTuple([TypeAddress(), TypeUint(8)]),
              ],
            ),
          ],
        ),
      ],
    ];

    for (var testcase in testcases) {
      final scheme = testcase[0] as String;
      final actual = AbiType.valueOf(scheme);
      expect(actual, equals(testcase[1]));
    }
  });

  test('Fail for invalid bit size or precision', () async {
    final invalidSizes = [-1, 0, 9, 513, 1024];
    final invalidPrecisions = [-1, 0, 161];

    for (var size in invalidSizes) {
      expect(
        () => TypeUint(size),
        throwsA((e) => e is ArgumentError),
      );
      expect(
        () => TypeUfixed(size, 10),
        throwsA((e) => e is ArgumentError),
      );
    }

    for (var precision in invalidPrecisions) {
      expect(
        () => TypeUfixed(8, precision),
        throwsA((e) => e is ArgumentError),
      );
    }
  });

  test('Test whether the type is dynamic', () async {
    final testcases = [
      [TypeUint(8).isDynamic(), false],
      [TypeUfixed(16, 10).isDynamic(), false],
      [TypeByte().isDynamic(), false],
      [TypeBool().isDynamic(), false],
      [TypeAddress().isDynamic(), false],
      [TypeString().isDynamic(), true],
      [TypeArrayDynamic(TypeBool()).isDynamic(), true],
      [TypeArrayDynamic(TypeArrayDynamic(TypeBool())).isDynamic(), true],
      [AbiType.valueOf('(string[100])').isDynamic(), true],
      [AbiType.valueOf('(address,bool,uint256)').isDynamic(), false],
      [AbiType.valueOf('(uint8,(byte[10]))').isDynamic(), false],
      [AbiType.valueOf('(string,uint256)').isDynamic(), true],
      [
        AbiType.valueOf('(bool,(ufixed16x10[],(byte,address)))').isDynamic(),
        true
      ],
      [
        AbiType.valueOf('(bool,(uint256,(byte,address,string)))').isDynamic(),
        true
      ],
    ];

    for (var testcase in testcases) {
      final actual = testcase[0];
      final expected = testcase[1];
      expect(actual, expected);
    }
  });

  test('Test whether the byte length of the type is correct', () async {
    final testcases = [
      [TypeAddress().byteLength(), 32],
      [TypeByte().byteLength(), 1],
      [TypeBool().byteLength(), 1],
      [TypeUint(64).byteLength(), 8],
      [TypeUfixed(256, 50).byteLength(), 32],
      [AbiType.valueOf('bool[81]').byteLength(), 11],
      [AbiType.valueOf('bool[80]').byteLength(), 10],
      [AbiType.valueOf('bool[88]').byteLength(), 11],
      [AbiType.valueOf('address[5]').byteLength(), 160],
      [AbiType.valueOf('uint16[20]').byteLength(), 40],
      [AbiType.valueOf('ufixed64x20[10]').byteLength(), 80],
      [
        AbiType.valueOf('((bool,address[10]),(bool,bool,bool),uint8[20])')
            .byteLength(),
        342
      ],
      [AbiType.valueOf('(bool,bool)').byteLength(), 1],
    ];

    for (var testcase in testcases) {
      final actual = testcase[0];
      final expected = testcase[1];
      expect(actual, expected);
    }
  });
}
