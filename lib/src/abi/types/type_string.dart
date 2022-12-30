import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

class TypeString extends AbiType {
  TypeString();

  @override
  Uint8List encode(dynamic obj) {
    if (obj is! String) {
      throw ArgumentError('cannot infer type for string abi value encode');
    }

    final value = obj;
    final buffer = utf8.encode(value);

    if (buffer.length >= (1 << 16)) {
      throw ArgumentError('string casted to byte exceeds uint16 maximum');
    }

    final encodedLength = BigIntEncoder.encodeUintToBytes(
        BigInt.from(buffer.length), AbiType.ABI_DYNAMIC_HEAD_BYTE_LEN);
    final castedBytes =
        AbiType.castToTupleType(buffer.length, TypeByte()).encode(buffer);
    final bf = <int>[];
    bf.addAll(encodedLength);
    bf.addAll(castedBytes);
    return Uint8List.fromList(bf);
  }

  @override
  Object decode(Uint8List encoded) {
    final encodedLength = AbiType.getLengthEncoded(encoded);
    final encodedString = AbiType.getContentEncoded(encoded);
    if (BigIntEncoder.decodeBytesToUint(encodedLength) !=
        BigInt.from(encodedString.length)) {
      throw ArgumentError(
          'string decode failure: encoded bytes do not match with length header');
    }

    return utf8.decode(encodedString);
  }

  @override
  bool isDynamic() => true;

  @override
  int byteLength() {
    throw ArgumentError('Dynamic type cannot pre-compute byte length');
  }

  @override
  bool operator ==(Object other) =>
      other is TypeString && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'string';
  }
}
