import 'dart:convert';

class AlgorandDecoder extends Converter<List<int>, String> {
  Utf8Codec _utf8Codec;

  AlgorandDecoder() : _utf8Codec = const Utf8Codec();

  @override
  String convert(List<int> input) {
    try {
      return _utf8Codec.decode(input, allowMalformed: false);
    } on FormatException catch (ex) {
      return base64Encode(input);
    }
  }
}
