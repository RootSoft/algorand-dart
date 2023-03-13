import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

class TypeUint extends AbiType {
  final int bitSize;

  TypeUint._internal(this.bitSize);

  factory TypeUint(int size) {
    if (size < 8 || size > 512 || size % 8 != 0) {
      throw ArgumentError(
          'uint initialize failure: bitSize should be in [8, 512] and bitSize '
          'mod 8 == 0');
    }
    return TypeUint._internal(size);
  }

  factory TypeUint.valueOf(String scheme) {
    final size = int.parse(scheme.substring(4));
    return TypeUint(size);
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
  bool isDynamic() => false;

  @override
  int byteLength() {
    return bitSize ~/ 8;
  }

  @override
  bool operator ==(Object other) =>
      other is TypeUint &&
      runtimeType == other.runtimeType &&
      bitSize == other.bitSize;

  @override
  int get hashCode => bitSize.hashCode;

  @override
  String toString() {
    return 'uint$bitSize';
  }
}
