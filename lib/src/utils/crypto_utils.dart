import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

extension CryptoStringExtension on String {
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
          return writeBigInt(BigInt.parse(parts[1]));
        default:
          throw AlgorandException(message: 'Does not support conversion');
      }
    }).toList();

    return arguments;
  }
}

Uint8List writeBigInt(BigInt number) {
  // Not handling negative numbers. Decide how you want to do that.
  final bytes = (number.bitLength + 7) >> 3;
  final b256 = BigInt.from(256);
  final result = Uint8List(bytes);
  for (var i = 0; i < bytes; i++) {
    result[i] = number.remainder(b256).toInt();
    number = number >> 8;
  }
  return result;
}
