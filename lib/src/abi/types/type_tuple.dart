import 'dart:typed_data';

import 'package:algorand_dart/src/abi/abi_type.dart';

class TypeTuple extends AbiType {
  final List<AbiType> childTypes;

  TypeTuple(this.childTypes);

  @override
  bool isDynamic() {
    for (var t in childTypes) {
      if (t.isDynamic()) {
        return true;
      }
    }
    return false;
  }

  @override
  int byteLength() {
    throw ArgumentError('Dynamic type cannot pre-compute byteLen');
  }

  @override
  Uint8List encode(dynamic obj) {
    return Uint8List.fromList([]);
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
}
