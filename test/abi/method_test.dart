import 'dart:typed_data';

import 'package:algorand_dart/src/abi/abi_method.dart';
import 'package:test/test.dart';

void main() {
  final testcases = <MethodTestCase>[];

  setUp(() async {
    testcases.addAll(
      [
        MethodTestCase(
          methodStr: 'someMethod(uint64,ufixed64x2,(bool,byte),address)void',
          txnCallCount: 1,
          arguments: ['uint64', 'ufixed64x2', '(bool,byte)', 'address'],
        ),
        MethodTestCase(
          methodStr: 'pseudoRandomGenerator()uint256',
          txnCallCount: 1,
          arguments: [],
        ),
        MethodTestCase(
          methodStr: 'add(uint64,uint64)uint128',
          txnCallCount: 1,
          arguments: ['uint64', 'uint64'],
        ),
        MethodTestCase(
          methodStr:
              'someEffectOnTheOtherSide___(uint64,(ufixed256x10,bool))void',
          txnCallCount: 1,
          arguments: ['uint64', '(ufixed256x10,bool)'],
        ),
        MethodTestCase(
          methodStr: 'someMethod(uint64,ufixed64x2,(bool,byte),address)void',
          txnCallCount: 1,
          arguments: ['uint64', 'ufixed64x2', '(bool,byte)', 'address'],
        ),
        MethodTestCase(
          methodStr: 'returnATuple(address)(byte[32],bool)',
          txnCallCount: 1,
          arguments: ['address'],
        ),
        MethodTestCase(
          methodStr: 'txcalls(pay,pay,axfer,byte)bool',
          txnCallCount: 4,
          arguments: ['pay', 'pay', 'axfer', 'byte'],
        ),
        MethodTestCase(
          methodStr: 'foreigns(account,pay,asset,application,bool)void',
          txnCallCount: 2,
          arguments: ['account', 'pay', 'asset', 'application', 'bool'],
        ),
      ],
    );
  });

  test('Test ABI method from signature', () async {
    for (var testcase in testcases) {
      final method = AbiMethod.method(testcase.methodStr);
      expect(method.signature, equals(testcase.methodStr));
      expect(method.txnCallCount, equals(testcase.txnCallCount));
      expect(method.arguments.map((e) => e.type).toList(),
          equals(testcase.arguments));
    }
  });

  test('Test ABI method from signature invalid', () async {
    final failingTestcases = <String>[
      //'___nopeThis Not Right nAmE () void',
      'intentional(MessAroundWith(Parentheses(address)(uint8)',
    ];
    for (var testcase in failingTestcases) {
      expect(
        () => AbiMethod.method(testcase),
        throwsA((e) => e is ArgumentError),
      );
    }
  });

  test('Test ABI method get selector', () async {
    final methodSelectorMap = <String, Uint8List>{
      'add(uint32,uint32)uint32': Uint8List.fromList([0x3e, 0x1e, 0x52, 0xbd]),
      'add(uint64,uint64)uint128': Uint8List.fromList([0x8a, 0xa3, 0xb6, 0x1f]),
    };

    methodSelectorMap.forEach((key, value) {
      final method = AbiMethod.method(key);
      expect(method.selector, equals(value));
    });
  });
}

class MethodTestCase {
  final String methodStr;
  final int txnCallCount;
  final List<String> arguments;

  MethodTestCase({
    required this.methodStr,
    required this.txnCallCount,
    required this.arguments,
  });
}
