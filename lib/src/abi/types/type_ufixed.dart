import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/abi/abi_type.dart';

class TypeUfixed extends AbiType {
  final int bitSize;
  final int precision;

  TypeUfixed(this.bitSize, this.precision); // TODO Assert size

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

    throw ArgumentError('Cannot infer type for ufixed value encode');
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
  bool isDynamic() => false;

  @override
  int byteLength() {
    return bitSize ~/ 8;
  }

  @override
  bool operator ==(Object other) =>
      other is TypeUfixed &&
      runtimeType == other.runtimeType &&
      bitSize == other.bitSize &&
      precision == other.precision;

  @override
  int get hashCode => bitSize.hashCode ^ precision.hashCode;

  @override
  String toString() {
    return 'ufixed${bitSize}x$precision';
  }
}
