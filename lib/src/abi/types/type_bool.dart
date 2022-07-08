import 'dart:typed_data';

import 'package:algorand_dart/src/abi/abi_type.dart';

class TypeBool extends AbiType {
  TypeBool();

  @override
  Uint8List encode(dynamic obj) {
    if (obj is! bool) {
      throw ArgumentError('cannot infer type for boolean abi value encode');
    }

    return Uint8List.fromList([obj ? 0x80 : 0x00]);
  }

  @override
  Object decode(Uint8List encoded) {
    if (encoded.length != 1) {
      throw ArgumentError(
          'cannot decode abi bool value, byte length do not match');
    }

    if (encoded[0] == 0x80) {
      return true;
    } else if (encoded[0] == 0x00) {
      return false;
    }

    throw ArgumentError('cannot decode abi bool value, illegal encoding value');
  }

  @override
  bool isDynamic() => false;

  @override
  int byteLength() {
    return 1;
  }

  @override
  bool operator ==(Object other) =>
      other is TypeBool && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'bool';
  }
}
