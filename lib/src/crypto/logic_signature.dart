import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/api/application/application.dart';
import 'package:algorand_dart/src/crypto/crypto.dart';
import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:algorand_dart/src/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logic_signature.g.dart';

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

@JsonSerializable(fieldRename: FieldRename.kebab)
class LogicSignature extends Equatable implements MessagePackable {
  static const LOGIC_PREFIX = 'Program';

  @JsonKey(name: 'l')
  @ByteArraySerializer()
  final Uint8List logic;

  @JsonKey(name: 'arg')
  @ListByteArraySerializer()
  final List<Uint8List>? arguments;

  @JsonKey(name: 'sig')
  @SignatureSerializer()
  final Signature? signature;

  @JsonKey(name: 'msig', includeFromJson: false, includeToJson: false)
  final MultiSignature? multiSignature;

  /// Create a new logic signature.
  /// Throws an [AlgorandException] if unable to check the logic.
  LogicSignature({
    required this.logic,
    this.arguments,
    this.signature,
    this.multiSignature,
  }) {
    // Validate program/logic
    Logic.checkProgram(program: logic, arguments: arguments);
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
    MultiSignature? multiSignature,
  }) {
    return LogicSignature(
      logic: logic ?? this.logic,
      arguments: arguments ?? this.arguments,
      signature: signature ?? this.signature,
      multiSignature: multiSignature ?? this.multiSignature,
    );
  }

  /// Perform signature verification against the sender address.
  Future<bool> verify(Address address) async {
    // Multisig
    if (signature != null && multiSignature != null) {
      return false;
    }

    try {
      Logic.checkProgram(program: logic, arguments: arguments);
    } catch (ex) {
      return false;
    }

    if (signature == null && multiSignature == null) {
      try {
        return address == toAddress();
      } catch (ex) {
        return false;
      }
    }

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

    // Verify multisig
    final verified = await multiSignature?.verify(data: getEncodedProgram());
    return verified ?? false;
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
    MultiSigAddress? multiSigAddress,
  }) async {
    if (multiSigAddress != null) {
      return _signLogicSigAsMultiSig(
        account: account,
        address: multiSigAddress,
      );
    }
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

  /// Sign a logic signature as a multisig.
  Future<LogicSignature> _signLogicSigAsMultiSig({
    required Account account,
    required MultiSigAddress address,
  }) async {
    final publicKey = account.address;
    final index = address.publicKeys.indexOf(publicKey);
    if (index == -1) {
      throw AlgorandException(
        message: 'Multisig account does not contain this secret key',
      );
    }

    // Sign the program
    final signature = await account.sign(getEncodedProgram());

    // Create the multi signature
    final multiSignature = MultiSignature(
      version: address.version,
      threshold: address.threshold,
      subsigs: [],
    );

    for (var i = 0; i < address.publicKeys.length; i++) {
      if (i == index) {
        multiSignature.subsigs.add(
          MultisigSubsig(key: publicKey, signature: signature),
        );
      } else {
        multiSignature.subsigs.add(
          MultisigSubsig(key: address.publicKeys[i]),
        );
      }
    }

    // Update the signature
    return copyWith(multiSignature: multiSignature);
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

  /// Appends a signature to multisig logic signed transaction
  Future<LogicSignature> append({required Account account}) async {
    final multiSignature = this.multiSignature;
    if (multiSignature == null) {
      throw AlgorandException(message: 'The logicsig has no valid multisig');
    }

    final publicKey = account.address;

    final index = multiSignature.subsigs.indexWhere(
      (subsig) => subsig.key == publicKey,
    );

    if (index == -1) {
      throw AlgorandException(
          message: 'Multisig account does not contain this secret key');
    }

    final signature = await account.sign(getEncodedProgram());
    multiSignature.subsigs[index] = MultisigSubsig(
      key: publicKey,
      signature: signature,
    );

    return copyWith(multiSignature: multiSignature);
  }

  /// Get the base64-encoded representation of the transaction..
  String toBase64() => base64Encode(Encoder.encodeMessagePack(toMessagePack()));

  @override
  Map<String, dynamic> toMessagePack() {
    return {
      'l': logic,
      'arg': arguments,
      'sig': signature?.bytes,
      'msig': multiSignature?.toMessagePack(),
    };
  }

  factory LogicSignature.fromJson(Map<String, dynamic> json) =>
      _$LogicSignatureFromJson(json);

  Map<String, dynamic> toJson() => _$LogicSignatureToJson(this);

  @override
  List<Object?> get props => [
        ...logic,
        ...arguments ?? [],
        signature,
        multiSignature,
      ];
}
