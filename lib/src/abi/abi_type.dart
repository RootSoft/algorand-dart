import 'dart:collection';
import 'dart:typed_data';

import 'package:algorand_dart/src/abi/segment.dart';
import 'package:algorand_dart/src/abi/types/type_address.dart';
import 'package:algorand_dart/src/abi/types/type_array_dynamic.dart';
import 'package:algorand_dart/src/abi/types/type_array_static.dart';
import 'package:algorand_dart/src/abi/types/type_bool.dart';
import 'package:algorand_dart/src/abi/types/type_byte.dart';
import 'package:algorand_dart/src/abi/types/type_string.dart';
import 'package:algorand_dart/src/abi/types/type_tuple.dart';
import 'package:algorand_dart/src/abi/types/type_ufixed.dart';
import 'package:algorand_dart/src/abi/types/type_uint.dart';
import 'package:algorand_dart/src/utils/array_utils.dart';

abstract class AbiType {
  static const ABI_DYNAMIC_HEAD_BYTE_LEN = 2;

  /// Check if this ABI type is a dynamic type.
  /// Returns decision if the ABI type is dynamic.
  bool isDynamic();

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

  static int findBoolLR(List<AbiType> typeArray, int index, int delta) {
    var until = 0;
    while (true) {
      var currentIndex = index + delta * until;
      if (typeArray[currentIndex] is TypeBool) {
        if (currentIndex != typeArray.length - 1 && delta > 0) {
          until++;
        } else if (currentIndex != 0 && delta < 0) {
          until++;
        } else {
          break;
        }
      } else {
        until--;
        break;
      }
    }
    return until;
  }

  /// Deserialize ABI type scheme from string
  /// @param str string representation of ABI type schemes
  /// @return ABI type scheme object
  /// @throws ArgumentError if ABI type serialization strings are corrupted
  static AbiType valueOf(String scheme) {
    if (scheme.endsWith('[]')) {
      return TypeArrayDynamic.valueOf(scheme);
    } else if (scheme.endsWith(']')) {
      return TypeArrayStatic.valueOf(scheme);
    } else if (scheme.startsWith('uint')) {
      return TypeUint.valueOf(scheme);
    } else if (scheme.startsWith('byte')) {
      return TypeByte();
    } else if (scheme.startsWith('ufixed')) {
      return TypeUfixed.valueOf(scheme);
    } else if (scheme.startsWith('bool')) {
      return TypeBool();
    } else if (scheme.startsWith('address')) {
      return TypeAddress();
    } else if (scheme.startsWith('string')) {
      return TypeString();
    } else if (scheme.length >= 2 && scheme[0] == '(' && scheme.endsWith(')')) {
      return TypeTuple.valueOf(scheme);
    } else {
      throw ArgumentError('Cannot infer type from string: $scheme');
    }
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

  /// Take the first 2 bytes in the byte array
  /// (consider the byte array to be an encoding for ABI dynamic typed value)
  /// @param encoded an ABI encoding byte array
  /// @return the first 2 bytes of the ABI encoding byte array
  /// @throws IllegalArgumentException if the encoded byte array has length < 2
  static Uint8List getLengthEncoded(Uint8List encoded) {
    if (encoded.length < ABI_DYNAMIC_HEAD_BYTE_LEN) {
      throw ArgumentError('encode byte size too small, less than 2 bytes');
    }
    final encodedLength = Uint8List(ABI_DYNAMIC_HEAD_BYTE_LEN);
    Array.copy(encoded, 0, encodedLength, 0, ABI_DYNAMIC_HEAD_BYTE_LEN);
    return encodedLength;
  }

  /// Take the bytes after the first 2 bytes in the byte array
  /// (consider the byte array to be an encoding for ABI dynamic typed value)
  /// @param encoded an ABI encoding byte array
  /// @return the tailing bytes after the first 2 bytes of the ABI encoding byte array
  /// @throws IllegalArgumentException if the encoded byte array has length < 2
  static Uint8List getContentEncoded(Uint8List encoded) {
    if (encoded.length < ABI_DYNAMIC_HEAD_BYTE_LEN) {
      throw ArgumentError('encode byte size too small, less than 2 bytes');
    }
    final encodedString = Uint8List(encoded.length - ABI_DYNAMIC_HEAD_BYTE_LEN);
    Array.copy(encoded, ABI_DYNAMIC_HEAD_BYTE_LEN, encodedString, 0,
        encoded.length - ABI_DYNAMIC_HEAD_BYTE_LEN);
    return encodedString;
  }
}
