import 'dart:collection';
import 'dart:typed_data';

import 'package:algorand_dart/src/abi/segment.dart';
import 'package:algorand_dart/src/abi/types/type_array_dynamic.dart';
import 'package:algorand_dart/src/abi/types/type_tuple.dart';
import 'package:algorand_dart/src/abi/types/type_uint.dart';

abstract class AbiType {
  static const ABI_DYNAMIC_HEAD_BYTE_LEN = 2;

  /// Check if this ABI type is a dynamic type.
  /// Returns decision if the ABI type is dynamic.
  bool isDynamic();

  bool equals(dynamic obj);

  /// Precompute the byte size of the static ABI typed value
  /// @return the byte size of the ABI value
  /// @throws IllegalArgumentException if the ABI type is dynamic typed
  int byteLength();

  /// Encode values with ABI rules based on the ABI type schemes
  /// @return byte[] of ABI encoding
  /// @throws IllegalArgumentException if encoder cannot infer the type from obj
  Uint8List encode(dynamic obj);

  /// Decode ABI encoded byte array to dart values from ABI type schemes
  /// @param encoded byte array of ABI encoding
  /// @throws IllegalArgumentException if encoded byte array cannot match with
  /// ABI encoding rules
  Object decode(Uint8List encoded);

  static List<String> parseTupleContent(String input) {
    if (input.isEmpty) {
      return <String>[];
    }

    if (input.startsWith(',') || input.endsWith(',')) {
      throw ArgumentError(
        'parsing error: tuple content should not start with comma',
      );
    }

    if (input.contains(',,')) {
      throw ArgumentError(
        'parsing error: tuple content should not have consecutive commas',
      );
    }

    final parentStack = ListQueue<int>();
    final parentSegments = <Segment>[];

    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (char == '(') {
        parentStack.add(i);
      } else if (char == ')') {
        if (parentStack.isEmpty) {
          throw ArgumentError(
              'parsing error: tuple parentheses are not balanced: $input');
        }

        final leftParentIndex = parentStack.removeLast();
        if (parentStack.isEmpty) {
          parentSegments.add(Segment(leftParentIndex, i));
        }
      }
    }

    if (parentStack.isNotEmpty) {
      throw ArgumentError(
          'parsing error: tuple parentheses are not balanced: $input');
    }

    var strCopied = input;
    for (var i = parentSegments.length - 1; i >= 0; i--) {
      strCopied = strCopied.substring(0, parentSegments[i].L) +
          strCopied.substring(parentSegments[i].R + 1);
    }

    final tupleSeg = strCopied.split(',');
    var parenSegCount = 0;
    for (var i = 0; i < tupleSeg.length; i++) {
      if (tupleSeg[i].isEmpty) {
        tupleSeg[i] = input.substring(parentSegments[parenSegCount].L,
            parentSegments[parenSegCount].R + 1);
        parenSegCount++;
      }
    }

    return tupleSeg.toList();
  }

  /// Deserialize ABI type scheme from string
  /// @param str string representation of ABI type schemes
  /// @return ABI type scheme object
  /// @throws ArgumentError if ABI type serialization strings are corrupted
  static AbiType valueOf(String scheme) {
    if (scheme.endsWith('[]')) {
      final elemType = AbiType.valueOf(scheme.substring(0, scheme.length - 2));
      return TypeArrayDynamic(elemType);
    } else if (scheme.endsWith(']')) {
      final r = RegExp(r'^([a-z\d[\](),]+)\[([1-9][\d]*)]$');
      if (!r.hasMatch(scheme)) {
        throw ArgumentError('static array type ill format');
      }
      final m = r.firstMatch(scheme);
      // TODO finish TypeArrayStatic
    } else if (scheme.startsWith("uint")) {
      final size = int.parse(scheme.substring(4));
      // return TypeUint(size);
    }

    return TypeUint(8);
  }

  /// Cast a dynamic/static array to ABI tuple type
  /// @param size length of the ABI array
  /// @param t ABI type of the element of the ABI array
  /// @return a type-cast from ABI array to an ABI tuple type
  static TypeTuple castToTupleType(int size, AbiType type) {
    final tupleTypes = <AbiType>[];
    for (var i = 0; i < size; i++) {
      tupleTypes.add(type);
    }
    return TypeTuple(tupleTypes);
  }
}
