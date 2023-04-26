import 'dart:typed_data';

import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:equatable/equatable.dart';

class MerkleSignatureVerifier extends Equatable {
  /// The length of the public key
  static const PUBLIC_KEY_LENGTH = 64;

  /// The public key, in bytes
  late final Uint8List _bytes;

  MerkleSignatureVerifier({required Uint8List bytes}) {
    if (bytes.length != PUBLIC_KEY_LENGTH) {
      throw AlgorandException(message: 'Merkle Signature wrong length.');
    }

    _bytes = bytes;
  }

  Uint8List get bytes => Uint8List.fromList(_bytes);

  @override
  List<Object?> get props => [..._bytes];
}
