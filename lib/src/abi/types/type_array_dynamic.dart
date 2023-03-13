import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

class TypeArrayDynamic extends AbiType {
  final AbiType elemType;

  TypeArrayDynamic(this.elemType);

  factory TypeArrayDynamic.valueOf(String scheme) {
    final elemType = AbiType.valueOf(scheme.substring(0, scheme.length - 2));
    return TypeArrayDynamic(elemType);
  }

  @override
  bool isDynamic() => true;

  @override
  int byteLength() {
    throw ArgumentError('Dynamic type cannot pre-compute byteLen');
  }

  @override
  Uint8List encode(dynamic obj) {
    if (obj is! List) {
      throw ArgumentError('Cannot encode value');
    }

    final values = List.from(obj);
    final castedEncode =
        AbiType.castToTupleType(values.length, elemType).encode(values);
    final lengthEncode = BigIntEncoder.encodeUintToBytes(
        BigInt.from(values.length), AbiType.ABI_DYNAMIC_HEAD_BYTE_LEN);

    final buffer = <int>[];
    buffer.addAll(lengthEncode);
    buffer.addAll(castedEncode);
    return Uint8List.fromList(buffer);
  }

  @override
  Object decode(Uint8List encoded) {
    final encodedLength = AbiType.getLengthEncoded(encoded);
    final encodedArray = AbiType.getContentEncoded(encoded);
    final size = BigIntEncoder.decodeBytesToUint(encodedLength).toInt();

    return AbiType.castToTupleType(size, elemType).decode(encodedArray);
  }

  @override
  bool operator ==(Object other) =>
      other is TypeArrayDynamic &&
      runtimeType == other.runtimeType &&
      elemType == other.elemType;

  @override
  int get hashCode => elemType.hashCode;

  @override
  String toString() {
    return '$elemType[]';
  }
}
