import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

class TypeUfixed extends AbiType {
  final int bitSize;
  final int precision;

  TypeUfixed._internal(this.bitSize, this.precision);

  factory TypeUfixed(int size, int precision) {
    if (size < 8 || size > 512 || size % 8 != 0) {
      throw ArgumentError(
          'uint initialize failure: bitSize should be in [8, 512] and bitSize '
          'mod 8 == 0');
    }
    if (precision < 1 || precision > 160) {
      throw ArgumentError(
          'ufixed initialize failure: precision should be in [1, 160]');
    }

    return TypeUfixed._internal(size, precision);
  }

  factory TypeUfixed.valueOf(String scheme) {
    final r = RegExp(r'^ufixed([1-9][\d]*)x([1-9][\d]*)$');
    if (!r.hasMatch(scheme)) {
      throw ArgumentError('static array type ill format');
    }

    final m = r.firstMatch(scheme);
    final size = m?.group(1);
    final precision = m?.group(2);
    if (size == null || precision == null) {
      throw ArgumentError('No match found in scheme.');
    }

    return TypeUfixed(
      int.parse(size, radix: 10),
      int.parse(precision, radix: 10),
    );
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
