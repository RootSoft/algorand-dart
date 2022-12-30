import 'dart:math';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/utils/array_utils.dart';
import 'package:collection/collection.dart';

class TypeTuple extends AbiType {
  final List<AbiType> childTypes;

  TypeTuple(this.childTypes);

  factory TypeTuple.valueOf(String scheme) {
    final tupleContent =
        AbiType.parseTupleContent(scheme.substring(1, scheme.length - 1));
    final tupleTypes = <AbiType>[];
    for (var subStr in tupleContent) {
      tupleTypes.add(AbiType.valueOf(subStr));
    }

    return TypeTuple(tupleTypes);
  }

  @override
  Uint8List encode(dynamic obj) {
    if (obj is! List) {
      throw ArgumentError(
          'cannot infer type for unify array/list-like object to object array');
    }

    if (obj.length != childTypes.length) {
      throw ArgumentError(
          'abi tuple child type size != abi tuple element value size');
    }

    final tupleValues = obj;
    final tupleTypes = List<AbiType>.from(childTypes);
    final heads =
        List<Uint8List>.filled(tupleTypes.length, Uint8List.fromList([]));
    final tails =
        List<Uint8List>.filled(tupleTypes.length, Uint8List.fromList([]));

    final dynamicIndex = <int>{};
    for (var i = 0; i < tupleTypes.length; i++) {
      var currType = tupleTypes[i];
      var currValue = tupleValues[i];
      Uint8List currHead, currTail;
      if (currType.isDynamic()) {
        currHead = Uint8List.fromList([0x00, 0x00]);
        currTail = currType.encode(currValue);
        dynamicIndex.add(i);
      } else if (currType is TypeBool) {
        var before = AbiType.findBoolLR(tupleTypes, i, -1);
        var after = AbiType.findBoolLR(tupleTypes, i, 1);
        if (before % 8 != 0) {
          throw ArgumentError('expected before has number of bool mod 8 == 0');
        }

        after = min(after, 7);
        var compressed = 0;
        for (var boolIndex = 0; boolIndex <= after; boolIndex++) {
          final result = tupleValues[i + boolIndex] as bool;
          if (result) {
            compressed |= 1 << (7 - boolIndex);
          }
        }

        currHead = Uint8List.fromList([compressed]);
        currTail = Uint8List.fromList([]);
        i += after;
      } else {
        currHead = currType.encode(currValue);
        currTail = Uint8List.fromList([]);
      }
      heads[i] = currHead;
      tails[i] = currTail;
    }

    var headLength = 0;
    for (var h in heads) {
      headLength += h.length;
    }

    var tailCurrLength = 0;
    for (var i = 0; i < heads.length; i++) {
      if (dynamicIndex.contains(i)) {
        var headValue = headLength + tailCurrLength;
        if (headValue >= (1 << 16)) {
          throw ArgumentError('encoding error: byte length >= 2^16');
        }
        heads[i] = BigIntEncoder.encodeUintToBytes(
            BigInt.from(headValue), AbiType.ABI_DYNAMIC_HEAD_BYTE_LEN);
      }
      tailCurrLength += tails[i].length;
    }

    final buffer = <int>[];
    for (var h in heads) {
      buffer.addAll(h);
    }

    for (var t in tails) {
      buffer.addAll(t);
    }

    return Uint8List.fromList(buffer);
  }

  @override
  Object decode(Uint8List encoded) {
    final dynamicSeg = <int>[];
    final valuePartition = <Uint8List>[];
    var iterIndex = 0;

    for (var i = 0; i < childTypes.length; i++) {
      if (childTypes[i].isDynamic()) {
        if (iterIndex + AbiType.ABI_DYNAMIC_HEAD_BYTE_LEN > encoded.length) {
          throw ArgumentError(
              'ill formed tuple dynamic typed element encoding: not enough bytes for index');
        }
        final encodedIndex = Uint8List(AbiType.ABI_DYNAMIC_HEAD_BYTE_LEN);
        Array.copy(encoded, iterIndex, encodedIndex, 0,
            AbiType.ABI_DYNAMIC_HEAD_BYTE_LEN);
        final index = BigIntEncoder.decodeBytesToUint(encodedIndex).toInt();
        dynamicSeg.add(index);
        valuePartition.add(Uint8List.fromList([]));
        iterIndex += AbiType.ABI_DYNAMIC_HEAD_BYTE_LEN;
      } else if (childTypes[i] is TypeBool) {
        final childTypeArr = List<AbiType>.from(childTypes);
        var before = AbiType.findBoolLR(childTypeArr, i, -1);
        var after = AbiType.findBoolLR(childTypeArr, i, 1);
        if (before % 8 != 0) {
          throw ArgumentError('expected bool number mod 8 == 0');
        }
        after = min(after, 7);
        for (var boolIndex = 0; boolIndex <= after; boolIndex++) {
          var boolMask = (0x80 >> boolIndex);
          var append = ((encoded[iterIndex] & boolMask) != 0) ? 0x80 : 0x00;
          valuePartition.add(Uint8List.fromList([append]));
        }
        i += after;
        iterIndex++;
      } else {
        var expectedLen = childTypes[i].byteLength();
        if (iterIndex + expectedLen > encoded.length) {
          throw ArgumentError(
              'ill formed tuple static typed element encoding: not enough bytes');
        }
        final partition = Uint8List(expectedLen);
        Array.copy(encoded, iterIndex, partition, 0, expectedLen);
        valuePartition.add(partition);
        iterIndex += expectedLen;
      }
      if (i != childTypes.length - 1 && iterIndex >= encoded.length) {
        throw ArgumentError('input bytes not enough to decode');
      }
    }

    if (dynamicSeg.isNotEmpty) {
      dynamicSeg.add(encoded.length);
      iterIndex = encoded.length;
    }

    if (iterIndex < encoded.length) {
      throw ArgumentError('input bytes not fully consumed');
    }

    var indexTemp = -1;
    for (var v in dynamicSeg) {
      if (v >= indexTemp) {
        indexTemp = v;
      } else {
        throw ArgumentError(
            'dynamic segments should display a [l, r] scope where l <= r');
      }
    }

    var segIndex = 0;
    for (var i = 0; i < childTypes.length; i++) {
      if (childTypes[i].isDynamic()) {
        final length = dynamicSeg[segIndex + 1] - dynamicSeg[segIndex];
        final partition = Uint8List(length);
        Array.copy(encoded, dynamicSeg[segIndex], partition, 0, length);
        valuePartition[i] = partition;
        segIndex++;
      }
    }

    final values =
        List<Object?>.filled(childTypes.length, null, growable: false);
    for (var i = 0; i < childTypes.length; i++) {
      values[i] = childTypes[i].decode(valuePartition[i]);
    }

    return values.whereNotNull().toList();
  }

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
    var size = 0;
    for (var i = 0; i < childTypes.length; i++) {
      if (childTypes[i] is TypeBool) {
        final after = AbiType.findBoolLR(childTypes, i, 1);
        i += after;
        final boolNumber = after + 1;
        size += boolNumber ~/ 8;
        size += (boolNumber % 8 != 0) ? 1 : 0;
      } else {
        size += childTypes[i].byteLength();
      }
    }
    return size;
  }

  @override
  bool operator ==(Object other) =>
      other is TypeTuple &&
      runtimeType == other.runtimeType &&
      const ListEquality().equals(childTypes, other.childTypes);

  @override
  int get hashCode => childTypes.hashCode;

  @override
  String toString() {
    final childStrs = <String>[];
    for (var t in childTypes) {
      childStrs.add(t.toString());
    }

    return '(${childStrs.join(',')})';
  }
}
