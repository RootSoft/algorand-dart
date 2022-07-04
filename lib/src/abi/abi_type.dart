import 'dart:collection';

import 'package:algorand_dart/src/abi/segment.dart';

class AbiType {
  static const ABI_DYNAMIC_HEAD_BYTE_LEN = 2;

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
}
