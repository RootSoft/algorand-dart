import 'dart:typed_data';

class BigIntEncoder {
  static final BigInt MAX_UINT64 = BigInt.parse('FFFFFFFFFFFFFFFF', radix: 16);
  static const UINT64_LENGTH = 8;

  /// Encode an non-negative integer as a big-endian uint64.
  static Uint8List encodeUint64(BigInt value) {
    if (value.compareTo(BigInt.zero) < 0 || value.compareTo(MAX_UINT64) > 0) {
      throw ArgumentError('Value cannot be represented by a uint64');
    }

    final fixedLengthEncoding = Uint8List(UINT64_LENGTH);
    var encodedValue = value.toUint8List();

    if (encodedValue.isNotEmpty && encodedValue[0] == 0) {
      // encodedValue is actually encoded as a signed 2's complement value,
      // so there may be a leading 0 for some encodings -- ignore it
      encodedValue = encodedValue.sublist(1, encodedValue.length);
    }

    final start = UINT64_LENGTH - encodedValue.length;
    final end = start + encodedValue.length;

    fixedLengthEncoding.setRange(start, end, encodedValue);

    return fixedLengthEncoding;
  }

  static BigInt decodeUint64(Uint8List encoded) {
    if (encoded.length != UINT64_LENGTH) {
      throw ArgumentError('Length of byte array is invalid');
    }

    var result = BigInt.from(0);
    for (var i = 0; i < encoded.length; i++) {
      result += BigInt.from(encoded[encoded.length - i - 1]) << (8 * i);
    }
    return result;
  }
}

extension BigIntExtension on BigInt {
  Uint8List toUint8List() {
    final _byteMask = BigInt.from(0xff);
    var number = this;
    var size = (number.bitLength + 7) >> 3;
    var result = Uint8List(size);
    for (var i = 0; i < size; i++) {
      result[size - i - 1] = (number & _byteMask).toInt();
      number = number >> 8;
    }
    return result;
  }
}
