import 'dart:typed_data';

import 'package:algorand_dart/src/abi/abi_type.dart';

class TypeArrayDynamic extends AbiType {
  final AbiType elemType;

  TypeArrayDynamic(this.elemType);

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

    //final castedEncode = AbiType.cast
    return Uint8List(8);
  }

  @override
  Object decode(Uint8List encoded) {
    // TODO: implement decode
    throw UnimplementedError();
  }

  @override
  bool equals(obj) {
    return false;
  }

  @override
  String toString() {
    return '$elemType[]';
  }
}
