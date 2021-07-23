import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

/// A raw serializable signature class
class Signature extends Equatable implements MessagePackable {
  static const ED25519_SIG_SIZE = 64;

  @JsonKey(name: 'bytes')
  late final Uint8List _bytes;

  Signature({required Uint8List bytes}) {
    if (bytes.length != ED25519_SIG_SIZE) {
      throw AlgorandException(message: 'Given signature length is not valid');
    }
    _bytes = Uint8List.fromList(bytes);
  }

  Uint8List get bytes => Uint8List.fromList(_bytes);

  @override
  Map<String, dynamic> toMessagePack() {
    return {
      'bytes': _bytes,
    };
  }

  @override
  List<Object?> get props => [..._bytes];
}
