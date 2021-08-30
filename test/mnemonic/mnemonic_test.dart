import 'dart:math';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/mnemonic/mnemonic.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {});

  test('test zero vector', () async {
    final zeroKeys = fillBytes(0);
    final expectedMnemonic =
        // ignore: lines_longer_than_80_chars
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon invest';
    final mnemonic = await Mnemonic.generate(zeroKeys);
    expect(mnemonic.join(' '), equals(expectedMnemonic));
    final seed = await Mnemonic.seed(mnemonic);
    expect(seed, equals(zeroKeys));
  });

  test('test word not in list', () async {
    final mnemonic =
        // ignore: lines_longer_than_80_chars
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon zzz invest';
    expect(
      () async => await Mnemonic.seed(mnemonic.split(' ')),
      throwsA((e) => e is MnemonicException),
    );
  });

  test('test generate and recovery', () async {
    final random = Random();
    for (var i = 0; i < 1000; i++) {
      final bytes = generateRandomBytes(random);
      final mnemonic = await Mnemonic.generate(bytes);
      final regenKey = await Mnemonic.seed(mnemonic);
      expect(regenKey, equals(bytes));
    }
  });

  test('test corrupted checksum', () async {
    final random = Random();
    for (var i = 0; i < 1000; i++) {
      final bytes = generateRandomBytes(random);
      final words = await Mnemonic.generate(bytes);
      final oldWord = words[words.length - 1];
      var newWord = oldWord;
      while (oldWord == newWord) {
        newWord = WordList.english().getWord(random.nextInt(2 ^ 11));
      }
      words[words.length - 1] = newWord;
      expect(
        () async => await Mnemonic.seed(words),
        throwsA((e) => e is MnemonicException),
      );
    }
  });

  test('test invalid key length', () async {
    final random = Random();
    final badLengths = <int>[0, 31, 33, 100, 35, 2, 30];
    for (var badLen in badLengths) {
      final randKey = generateRandomBytes(random, badLen);
      expect(
        () async => await Mnemonic.generate(randKey),
        throwsA((e) => e is MnemonicException),
      );
    }
  });
}
