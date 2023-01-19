import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:convert/convert.dart';

Uint8List generateRandomBytes([Random? random, int size = 32]) {
  final r = random ?? Random();
  return Uint8List.fromList(
    List<int>.generate(size, (i) => r.nextInt(256)),
  );
}

Uint8List generateSecureRandomBytes([int size = 32]) {
  return generateRandomBytes(Random.secure(), size);
}

String generateSecureRandomString([int size = 32]) {
  return hex.encode(generateRandomBytes(Random.secure(), size));
}

Uint8List fillBytes(int value, [int size = 32]) {
  return Uint8List.fromList(
    List<int>.generate(size, (i) => value),
  );
}

extension CryptoStringExtension on String {
  Uint8List toBytes() {
    return Uint8List.fromList(utf8.encode(this));
  }

  String trimPadding() {
    return replaceAll(RegExp(r'='), '');
  }

  /// Convert an array of arguments like "str:arg1,str:arg2" into a properly
  /// converted byte array.
  List<Uint8List> toApplicationArguments() {
    final arguments = split(',').map((arg) {
      final parts = arg.split(':');
      switch (parts[0]) {
        case 'str':
          return Uint8List.fromList(utf8.encode(parts[1]));
        case 'int':
          return BigIntEncoder.encodeUint64(BigInt.parse(parts[1]));
        case 'addr':
          final address = Address.fromAlgorandAddress(parts[1]);
          return address.toBytes();
        default:
          throw AlgorandException(message: 'Does not support conversion');
      }
    }).toList();

    return arguments;
  }
}
