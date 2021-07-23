import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:equatable/equatable.dart';

class Ed25519PublicKey extends Equatable implements MessagePackable {
  static const KEY_LEN_BYTES = 32;

  late final Uint8List _bytes;

  Ed25519PublicKey({required Uint8List bytes}) {
    if (bytes.length != KEY_LEN_BYTES) {
      throw AlgorandException(message: 'ed25519 public key wrong length');
    }

    _bytes = Uint8List.fromList(bytes);
  }

  /// Get the bytes.
  Uint8List get bytes => _bytes;

  @override
  Map<String, dynamic> toMessagePack() {
    return {
      'bytes': bytes,
    };
  }

  @override
  List<Object?> get props => [...bytes];
}
