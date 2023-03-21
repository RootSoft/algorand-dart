import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:equatable/equatable.dart';

class MultiSignature extends Equatable implements MessagePackable {
  static const MULTISIG_VERSION = 1;

  final int version;
  final int threshold;
  final List<MultisigSubsig> subsigs;

  MultiSignature({
    required this.version,
    required this.threshold,
    required this.subsigs,
  });

  /// Performs signature verification
  Future<bool> verify({required Uint8List data}) async {
    if (version != MULTISIG_VERSION || threshold <= 0 || subsigs.isEmpty) {
      return false;
    }

    if (threshold > subsigs.length) {
      return false;
    }

    var verifiedCount = 0;
    for (var i = 0; i < subsigs.length; i++) {
      final subsig = subsigs[i];
      final signature = subsig.signature;
      if (signature == null) {
        continue;
      }

      final pk = Address(publicKey: subsig.key.publicKey).toVerifyKey();
      final verified = await crypto.Ed25519().verify(
        data,
        signature: crypto.Signature(
          signature.bytes,
          publicKey: pk,
        ),
      );

      if (verified) {
        verifiedCount += 1;
      }
    }

    return verifiedCount >= threshold;
  }

  @override
  List<Object?> get props => [version, threshold, ...subsigs];

  @override
  Map<String, dynamic> toMessagePack() {
    return {
      'v': version,
      'thr': threshold,
      'subsig': subsigs.map((subsig) => subsig.toMessagePack()).toList(),
    };
  }
}

class MultisigSubsig extends Equatable implements MessagePackable {
  final Address key;
  final Signature? signature;

  MultisigSubsig({required this.key, this.signature});

  MultisigSubsig copyWith({Signature? signature}) {
    return MultisigSubsig(
      key: key,
      signature: signature,
    );
  }

  @override
  List<Object?> get props => [key, signature];

  @override
  Map<String, dynamic> toMessagePack() {
    return {
      'pk': key.publicKey,
      's': signature?.bytes,
    };
  }
}
