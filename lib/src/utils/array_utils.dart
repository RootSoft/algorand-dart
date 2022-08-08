import 'dart:math';
import 'dart:typed_data';

class Array {
  static void copy(
    List<int> source,
    int sourceOffset,
    List<int> target,
    int targetOffset,
    int length,
  ) {
    target.setRange(targetOffset, targetOffset + length, source, sourceOffset);
  }

  static Uint8List copyOfRange(Uint8List original, int from, int to) {
    var newLength = to - from;
    if (newLength < 0) {
      throw ArgumentError('$from > $to');
    }

    final copy = Uint8List(newLength);
    Array.copy(original, from, copy, 0, min(original.length - from, newLength));
    return copy;
  }
}
