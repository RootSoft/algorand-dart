import 'dart:typed_data';

import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:equatable/equatable.dart';

class ParticipationPublicKey extends Equatable {
  /// The length of the public key
  static const PUBLIC_KEY_LENGTH = 32;

  /// The public key, in bytes
  late final Uint8List _bytes;

  ParticipationPublicKey({required Uint8List bytes}) {
    if (bytes.length != PUBLIC_KEY_LENGTH) {
      throw AlgorandException(message: 'VRF Public Key wrong length.');
    }

    _bytes = bytes;
  }

  Uint8List get bytes => _bytes;

  @override
  List<Object?> get props => [..._bytes];
}
