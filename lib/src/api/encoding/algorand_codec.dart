import 'dart:convert';

import 'package:algorand_dart/src/api/encoding/algorand_decoder.dart';
import 'package:algorand_dart/src/api/encoding/algorand_encoder.dart';

class AlgorandCodec extends Encoding {
  const AlgorandCodec();

  /// The name of this codec is "algorand".
  @override
  String get name => 'algorand';

  @override
  String decode(List<int> encoded, {bool? allowMalformed}) {
    return decoder.convert(encoded);
  }

  @override
  AlgorandEncoder get encoder => AlgorandEncoder();

  @override
  AlgorandDecoder get decoder {
    return AlgorandDecoder();
  }
}
