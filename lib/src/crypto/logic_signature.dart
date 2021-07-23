import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/crypto/crypto.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as crypto;

/// Most Algorand transactions are authorized by a signature from a single
/// account or a multisignature account.
///
/// Algorand’s stateful smart contracts allow for a third type of signature
/// using a Transaction Execution Approval Language (TEAL) program,
/// called a logic signature (LogicSig).
///
/// Stateless smart contracts provide two modes for TEAL logic to operate as a
/// LogicSig, to create a contract account that functions similar to an
/// escrow or to delegate signature authority to another account.
///
/// More information, see
/// https://developer.algorand.org/docs/features/asc1/stateless/sdks/
class LogicSignature implements MessagePackable {
  static const LOGIC_PREFIX = 'Program';

  final Uint8List logic;
  final List<Uint8List>? arguments;
  final Signature? signature;

  // @JsonKey(name: 'msig')
  // final MultiSignature? multiSignature;

  /// Create a new logic signature.
  /// Throws an [AlgorandException] if unable to check the logic.
  LogicSignature({required this.logic, this.arguments, this.signature}) {
    // Validate program/logic
    Logic.checkProgram(program: logic, arguments: arguments);

    // TODO Multisig
  }

  /// Create a new logic signature from a given TEAL program.
  /// Throws an [AlgorandException] if unable to check the logic.
  LogicSignature.fromProgram({
    required TEALProgram program,
    List<Uint8List>? arguments,
    Signature? signature,
  }) : this(
          logic: program.program,
          arguments: arguments,
          signature: signature,
        );

  LogicSignature copyWith({
    Uint8List? logic,
    List<Uint8List>? arguments,
    Signature? signature,
  }) {
    return LogicSignature(
      logic: logic ?? this.logic,
      arguments: arguments ?? this.arguments,
      signature: signature ?? this.signature,
    );
  }

  /// Perform signature verification against the sender address.
  Future<bool> verify(Address address) async {
    try {
      Logic.checkProgram(program: logic, arguments: arguments);
    } catch (ex) {
      return false;
    }

    // TODO Multisig

    // Verify signature
    if (signature != null) {
      final verified = await crypto.Ed25519().verify(
        getEncodedProgram(),
        signature: crypto.Signature(
          signature?.bytes ?? [],
          publicKey: address.toVerifyKey(),
        ),
      );

      return verified;
    }

    // TODO Verify multisig
    return true;
  }

  /// Generate escrow address from logic sig program.
  /// Returns the address for the encoded program.
  Address toAddress() {
    final encodedProgram = getEncodedProgram();
    final digest = Uint8List.fromList(sha512256.convert(encodedProgram).bytes);
    return Address(publicKey: digest);
  }

  /// Get the encoded representation of the program with a prefix suitable
  /// for signing.
  Uint8List getEncodedProgram() {
    // Prepend the program prefix
    final txBytes = utf8.encode(LOGIC_PREFIX);

    // Merge the byte arrays
    return Uint8List.fromList([...txBytes, ...logic]);
  }

  /// Sign a logic signature with account secret key.
  Future<LogicSignature> sign({
    required Account account,
  }) async {
    // Get the encoded program
    final encodedProgram = getEncodedProgram();

    // Sign the program with secret key
    final signature = await crypto.Ed25519().sign(
      encodedProgram,
      keyPair: account.keyPair,
    );

    // Update the signature
    return copyWith(
      signature: Signature(bytes: Uint8List.fromList(signature.bytes)),
    );
  }

  /// Create a signed transaction from a LogicSignature and transaction.
  /// LogicSignature must be valid and verifiable against transaction sender
  /// field.
  ///
  /// Returns a signed transaction from a given logic signature.
  Future<SignedTransaction> signTransaction({
    required RawTransaction transaction,
  }) async {
    final sender = transaction.sender;
    if (sender == null) {
      throw AlgorandException(message: 'No sender specified');
    }

    // Verify lsig
    final verified = await verify(sender);
    if (!verified) {
      throw AlgorandException(message: 'Verification failed');
    }

    // Create the signed transaction with logic signature
    final signedTransaction = SignedTransaction(
      transaction: transaction,
      logicSignature: this,
    );

    return signedTransaction;
  }

  @override
  Map<String, dynamic> toMessagePack() {
    return {
      'l': logic,
      'arg': arguments,
      'sig': signature?.bytes,
    };
  }
}
