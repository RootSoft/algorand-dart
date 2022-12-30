import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

class TypeAddress extends AbiType {
  TypeAddress();

  @override
  Uint8List encode(dynamic obj) {
    if (obj is List<int> && obj.length == Address.PUBLIC_KEY_LENGTH) {
      return AbiType.castToTupleType(byteLength(), TypeByte()).encode(obj);
    } else if (obj is Address) {
      return AbiType.castToTupleType(byteLength(), TypeByte())
          .encode(obj.publicKey);
    } else if (obj is String) {
      final address = Address.fromAlgorandAddress(obj);
      return AbiType.castToTupleType(byteLength(), TypeByte())
          .encode(address.publicKey);
    }

    throw ArgumentError('Cannot infer type for uint value encode');
  }

  @override
  Object decode(Uint8List encoded) {
    if (encoded.length != byteLength()) {
      throw ArgumentError(
          'cannot decode abi address, address byte length should be 32');
    }

    return Address(publicKey: encoded);
  }

  @override
  bool isDynamic() => false;

  @override
  int byteLength() {
    return Address.PUBLIC_KEY_LENGTH;
  }

  @override
  bool operator ==(Object other) =>
      other is TypeAddress && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'address';
  }
}
