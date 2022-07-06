import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/abi/abi_type.dart';

class TypeUint extends AbiType {
  final int bitSize;

  TypeUint(this.bitSize); // TODO Assert size

  @override
  bool isDynamic() => false;

  @override
  int byteLength() {
    throw ArgumentError('Dynamic type cannot pre-compute byteLen');
  }

  @override
  Uint8List encode(dynamic obj) {
    if (obj is BigInt) {
      return BigIntEncoder.encodeUintToBytes(obj, bitSize ~/ 8);
    }

    if (obj is num) {
      return BigIntEncoder.encodeUintToBytes(BigInt.from(obj), bitSize ~/ 8);
    }

    if (obj is String) {
      return BigIntEncoder.encodeUintToBytes(BigInt.parse(obj), bitSize ~/ 8);
    }

    throw ArgumentError('Cannot infer type for uint value encode');
  }

  @override
  Object decode(Uint8List encoded) {
    if (encoded.length != bitSize / 8) {
      throw ArgumentError(
          'cannot decode for abi uint value, byte length not matching');
    }

    return BigIntEncoder.decodeBytesToUint(encoded);
  }

  @override
  bool equals(obj) {
    return false;
  }
}
