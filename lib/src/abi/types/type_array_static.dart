import 'dart:typed_data';

import 'package:algorand_dart/src/abi/abi_type.dart';
import 'package:algorand_dart/src/abi/types/type_bool.dart';

class TypeArrayStatic extends AbiType {
  final AbiType elemType;
  final int length;

  TypeArrayStatic(this.elemType, this.length); // TODO Check length

  factory TypeArrayStatic.valueOf(String scheme) {
    final r = RegExp(r'^([a-z\d[\](),]+)\[([1-9][\d]*)]$');
    if (!r.hasMatch(scheme)) {
      throw ArgumentError('static array type ill format');
    }

    final m = r.firstMatch(scheme);
    final type = m?.group(1);
    final length = m?.group(2);
    if (type == null || length == null) {
      throw ArgumentError('No match found in scheme.');
    }

    final elemType = AbiType.valueOf(type);

    return TypeArrayStatic(
      elemType,
      int.parse(length, radix: 10),
    );
  }

  @override
  Uint8List encode(dynamic obj) {
    if (obj is! List) {
      throw ArgumentError('cannot infer type for boolean abi value encode');
    }
    final values = List.from(obj);
    return AbiType.castToTupleType(length, elemType).encode(values);
  }

  @override
  Object decode(Uint8List encoded) {
    return AbiType.castToTupleType(length, elemType).decode(encoded);
  }

  @override
  bool isDynamic() => elemType.isDynamic();

  @override
  int byteLength() {
    if (elemType is TypeBool) {
      return (length + 7) ~/ 8;
    }
    return elemType.byteLength() * length;
  }

  @override
  bool operator ==(Object other) =>
      other is TypeArrayStatic &&
      runtimeType == other.runtimeType &&
      elemType == other.elemType &&
      length == other.length;

  @override
  int get hashCode => elemType.hashCode ^ length.hashCode;

  @override
  String toString() {
    return '${elemType.toString()}[$length]';
  }
}
