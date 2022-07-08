import 'dart:typed_data';

import 'package:algorand_dart/src/abi/abi_type.dart';

class TypeByte extends AbiType {
  TypeByte();

  @override
  Uint8List encode(dynamic obj) {
    if (obj is! int && obj is! BigInt) {
      throw ArgumentError('cannot infer type for bool abi value encode');
    }

    var value = obj is BigInt ? obj.toInt() : obj as int;

    if (value < 0 || value > 255) {
      throw ArgumentError('$value cannot be encoded into a byte');
    }

    return Uint8List.fromList([value]);
  }

  @override
  Object decode(Uint8List encoded) {
    if (encoded.length != 1) {
      throw ArgumentError(
          'cannot decode abi byte value, byte length do not match');
    }

    return encoded[0];
  }

  @override
  bool isDynamic() => false;

  @override
  int byteLength() {
    return 1;
  }

  @override
  bool operator ==(Object other) =>
      other is TypeByte && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'byte';
  }
}
