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

  /// Converts a [Uint8List] byte buffer into a [BigInt]
  static BigInt decodeBytesToUint(Uint8List encoded) {
    var result = BigInt.zero;

    for (final byte in encoded) {
      // reading in big-endian, so we essentially concat the new byte to the end
      result = (result << 8) | BigInt.from(byte);
    }
    return result;
  }

  /// Encode an non-negative integer as a big-endian general uint value.
  /// @param value The value to encode.
  /// @param byteNum The size of output bytes.
  /// @throws IllegalArgumentException if value cannot be represented by the
  /// byte array of length byteNum.
  /// @return A byte array containing the big-endian encoding of the value.
  /// Its length will be byteNum.
  static Uint8List encodeUintToBytes(BigInt value, int byteNum) {
    if (value.compareTo(BigInt.zero) < 0) {
      throw ArgumentError('Encode int to byte: input BigInteger < 0');
    }

    final buffer = Uint8List(byteNum);
    var encoded = value.toUint8List();
    if (encoded.length == byteNum + 1) {
      //encoded = Arrays.copyOfRange(encoded, 1, encoded.length);
      encoded = encoded.sublist(1, encoded.length);
    }
    final start = buffer.length - encoded.length;
    final end = start + encoded.length;

    buffer.setRange(start, end, encoded);
    return buffer;
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
